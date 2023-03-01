%            ________  ___  __        _____ ______                 %
%           |\   ____\|\  \|\  \     |\   _ \  _   \               %
%           \ \  \___|\ \  \/  /|_   \ \  \\\__\ \  \              %
%            \ \  \    \ \   ___  \   \ \  \\|__| \  \             %
%             \ \  \____\ \  \\ \  \ __\ \  \    \ \  \            %
%              \ \_______\ \__\\ \__\\__\ \__\    \ \__\           %
%               \|_______|\|__| \|__\|__|\|__|     \|__|           %
%                                                                  %
%                     Author: Andrea Somma;                        % 
%                     Politecnico of Milan 2021-2022               % 
%                                                                  %
clc; clear all; close all

%% reducing and parsing thermo model
species=["CH4" "H2O" "CO" "H2" "CO2" "N2"];
chemkin_thermo_reducer("thermo.txt",species)
chemkin_trans_reducer("trans.txt",species)

%% models
load('./thermo_models/thermo_reduced.mat');
load('./PM/PM_table.mat');
load('./transport_models/trans_reduced.mat');

%% dati reazioni
EA=[265 88 275]*1e3; %J/mol
k0=[13.2 136 1.68];
K0=[6.65*1e-4 1.77*1e5 8.23*1e-5 6.12*1e-9 0 0];
DH=[-38.28 88.68 -70.65 -82.90 0 0]*1e3; %J/mol
nu=[-1 -1 +1 +3 +0 +0
    +0 -1 -1 +1 +1 +0
    -1 -2 +0 +4 +1 +0];

%% dati tubo
Di_vect=[3 4 5]*0.0254; %m
s_tube=[1.2 1.5 1.8]*1e-2; %m
De_vect=Di_vect+s_tube*2;
L0=10; %m
Sv_vect=(Di_vect*pi*L0)./(Di_vect.^2/4*pi*L0);

C_vect=[17.22 0.0578 3.930 0.816 %top
    5.819 0.17 2.791 1.138]; %side
k_tube=29.8; %W/m/K

%% dati cat
deq_vect=[0.59 0.86]*1e-2; %m
eps_vect=[0.55 0.62];
rho_bed_vect=[1058 556.3]; %kgcat/m3
effcat_vect=[0.01 0.02];
costo=[50 70]; %$/kgcat
alpha0=70; %W/m2/K
type_vect=[1 2];

disatt=0.40; % %/3anni

%% dati
Tin=800; %K
Qtot=18*1e6; %W

n_tubi=80;
Fin=1050*1000/3600; %mol/s
x=[0.222 0.770 1e-10 1e-10 0.005 0.003];
R=8.314; %J/mol/K
Qtube_vect=Qtot./(Di_vect*L0*pi)/n_tubi;

%% vincoli
H2_min=715*1000/3600/n_tubi; %mol/s singolo tubo
conv_CH4_min=0.85;
Pout=20*1e5; %Pa
dP_max=2*1e5; %Pa
T_pelle_max=1220; %K

%%

counter = 0;
field_vect = ["first_SD_TOP" "first_SD_SIDE" "first_LOWDP_TOP" "first_LOWDP_SIDE" "second_SD_TOP" "second_SD_SIDE" "second_LOWDP_TOP" "second_LOWDP_SIDE" "third_SD_TOP" "third_SD_SIDE" "third_LOWDP_TOP" "third_LOWDP_SIDE"];
plot_vect = ["first SD TOP" "first SD SIDE" "first LOWDP TOP" "first LOWDP SIDE" "second SD TOP" "second SD SIDE" "second LOWDP TOP" "second LOWDP SIDE" "third SD TOP" "third SD SIDE" "third LOWDP TOP" "third LOWDP SIDE"];
vincoli=zeros(12,4);

for i=1:length(De_vect)
    for j=1:length(type_vect)
        for kk=1:2 %tipo bruciatori
            
            effcat=effcat_vect(j);
            type=type_vect(j);
            deq=deq_vect(j);
            eps=eps_vect(j);
            De=De_vect(i);
            Di=Di_vect(i);
            C=C_vect(kk,:);
            rho_bed=rho_bed_vect(j);
            Sv=Sv_vect(i);
            Qtube=Qtube_vect(i);
            lunghezza_vect=[0 10];
            
            %% ode
            
            %% first try & init
            nin=1050*1000/3600/n_tubi; %mol/s
            Pin_vect=[22.4068 22.3636 21.1764 21.1556 20.9270 20.9094 20.4119 20.4044 20.4365 20.4281 20.1813 20.1779]; %bar
            counter = 1+counter;
            Pin = Pin_vect(counter);
            init=[0 0 0 0 0 0 Tin Pin]; init(1:6)=nin.*x;
            opt = odeset('InitialStep',1e-14,'Refine',3,'MaxStep',0.02);
            [L,sol]=ode15s(@(L,I) diff3(L,I,nu,EA,k0,K0,DH,species,deq,eps,rho_bed,effcat,Di,L0,Qtube,R,C,type,data,PM_table,Sv,counter,data_trans),lunghezza_vect,init,opt);
            
            
            %% Tpe control
            
            Tpe=zeros(1,length(L));
            for k = 1:length(L)
                Tpe(k) = control_Tpe(L(k),sol(k,:),species,k_tube,deq,alpha0,Di,De,L0,Qtube,R,C,type,data,PM_table,data_trans);
            end
            
            %% results
            
            value = [L,sol,Tpe'];
            my_field = field_vect(counter);
            results.(my_field) = value;
            vincoli(counter,:) = [max(Tpe) sol(1,8)-sol(end,8) (sol(1,1)-sol(end,1))/sol(1,1) sol(end,4)];
            disp(["Tpe max" "P loss" "conv CH4" "FH2"])
            disp(vincoli(counter,:))
            
            fh = figure(counter);
            fh.WindowState = 'maximized';
            subplot(1,3,1)
            yyaxis right
            plot(L,sol(:,7),L,Tpe)
            ylabel('T and Tpe (K)')
            yyaxis left
            plot(L,sol(:,8))
            ylabel('P (bar)')
            xlabel('L (m)')
            title('T,Tpe,P');
            
            subplot(1,3,2)
            plot(L,(sol(1,1)-sol(:,1))/sol(1,1),'--')
            xlabel('L (m)')
            ylabel('conv CH4 (-)')
            title('conv CH4');
            
            subplot(1,3,3)
            plot(L,sol(:,1)./sum(sol(end,1:6)),L,sol(:,2)./sum(sol(end,1:6)),L,sol(:,3)./sum(sol(end,1:6)),L,sol(:,4)./sum(sol(end,1:6)),L,sol(:,5)./sum(sol(end,1:6)),L,sol(:,6)./sum(sol(end,1:6)))
            xlabel('L (m)')
            ylabel('x (-)')
            title('composition');
            
            b = ceil(length(L)/2.5);
            for aa = 1:length(species)
                text(L(b),sol(b,aa)/sum(sol(end,1:6))+0.005,species(aa))
                b = b + 50;
            end
            
            sgtitle(plot_vect(counter))
            
            
        end
    end
end

%% functions

function ode=diff3(L,I,nu,EA,k0,K0,DH,species,deq,eps,rho_bed,effcat,Di,L0,Qtube,R,C,type,data,PM_table,Sv,counter,data_trans)

ni=I(1:6);
T=I(7);
P=I(8);

%xi
x=(ni/sum(ni))';

% partial p
p=P*x;

% rho
PM=PM_fun(species,PM_table);
PMmix=PM*x';
rho=P*100000*PMmix/R/T;

%v
v=sum(ni)*PMmix/rho/(pi()*Di^2/4);

%cp
cp=zeros(1,length(species));
for i=1:length(species)
    cp(i)=all_thermo(species(i),"cp",T,data);
end

cpmix=cp*x';

%reaction kin
kj=k0.*exp(-EA./R*(1/T-1/873));
Kj=K0.*exp(-DH./R/T);
Keq=[vanthoff_all(T,species,nu(1,:),data)
    vanthoff_all(T,species,nu(2,:),data)
    vanthoff_all(T,species,nu(3,:),data)];

%r1

r(1)=(kj(1)/p(4)^2.5*(p(1)*p(2)-p(4)^3*p(3)/Keq(1))/(1+Kj(3)*p(3)+Kj(4)*p(4)+Kj(1)*p(1)+Kj(2)*p(2)/p(4))^2)*1000/3600;

%r2

r(2)=(kj(2)/p(4)*(p(3)*p(2)-p(4)*p(5)/Keq(2))/(1+Kj(3)*p(3)+Kj(4)*p(4)+Kj(1)*p(1)+Kj(2)*p(2)/p(4))^2)*1000/3600;

%r3

r(3)=(kj(3)/p(4)^3.5*(p(1)*p(2)^2-p(4)^4*p(5)/Keq(3))/(1+Kj(3)*p(3)+Kj(4)*p(4)+Kj(1)*p(1)+Kj(2)*p(2)/p(4))^2)*1000/3600;


%DH0R
DH0R_vect=zeros(1,length(species));
for i=1:length(species)
    DH0R_vect(i)=all_thermo(species(i),"H",T,data);
end
DH0R=nu*DH0R_vect';

%Q
Q=Qtube*(C(1)*(L/L0+C(2))*exp(-C(3)*(L/L0)^C(4)));
% visc
vi=zeros(1,length(species));
for i=1:length(species)
    vi(i)=stat_trans(species(i),T,P,"vi",data_trans,PM_table,data);
end

phi = zeros(length(species),length(species));
for j=1:length(species)
    for k=1:length(species)
        phi(k,j)=1/sqrt(8)*(1+PM(k)/PM(j))^-0.5*(1+((vi(k)/vi(j))^0.5)*(PM(j)/PM(k))^0.25)^2;
    end
end
vi_=sum(x.*vi./sum(x.*phi)); %C. R. Wilke, Journal of Chemical Physics 18:517 (1950)

% Re
Re=rho*v*deq/vi_;

%U & f
if type==1
    f=10.5*(1-eps)^1.2/eps^3*Re^-0.3;
elseif type==2
    f=4.63*(1-eps)^1.2/eps^3*Re^-0.16;
end

%ode
ode(1:6)=rho_bed*(r*nu)*effcat*(pi*Di^2/4); %numero di moli della specie i
ode(7)=((-rho_bed*effcat*sum(DH0R'.*r))+Sv*Q)*(Di^2*pi/4)/sum(ni)/cpmix;
ode(8)=-f*rho*v^2/deq/100000;
ode=ode';

end

function Tpe=control_Tpe(L,I,species,k_tube,deq,alpha0,Di,De,L0,Qtube,R,C,type,data,PM_table,data_trans)

ni=I(1:6);
T=I(7);
P=I(8);

%xi
x=(ni/sum(ni))';

% rho
PM=PM_fun(species,PM_table);
PMmix=PM*x;
rho=P*101325*PMmix/R/T;

%v
v=sum(ni)*PMmix/rho/(pi()*Di^2/4);

%cp
cp=zeros(1,length(species));
for i=1:length(species)
    cp(i)=all_thermo(species(i),"cp",T,data);
end

cpmix=cp*x;

%Q
Q=Qtube*(C(1)*(L/L0+C(2))*exp(-C(3)*(L/L0)^C(4)));

% visc
vi=zeros(1,length(species));
for i=1:length(species)
    vi(i)=stat_trans(species(i),T,P,"vi",data_trans,PM_table,data);
end


phi = zeros(length(species),length(species));

for j=1:length(species)
    for k=1:length(species)
        phi(k,j)=1/sqrt(8)*(1+PM(k)/PM(j))^-0.5*(1+((vi(k)/vi(j))^0.5)*(PM(j)/PM(k))^0.25)^2;
    end
end
vi_=sum(x'.*vi./sum(x'.*phi)); %C. R. Wilke, Journal of Chemical Physics 18:517 (1950) CHEMKIN MANUAL

% kt
kt=zeros(1,length(species));
for i=1:length(species)
    kt(i)=stat_trans(species(i),T,P,"kt",data_trans,PM_table,data);
end
kt_=0.5*(sum(x.*kt')+1/(sum(x'./kt)));  %S. Mathur, P. K. Tondon, and S. C. Saxena, Molecular Physics 12:569 (1967) CHEMKIN MANUAL

% Re Pr
Re=rho*v*deq/vi_;
Pr=vi_*cpmix/PMmix/kt_;

%U & f
if type==1
    hint=(alpha0*deq/kt_+0.25*Re^0.72*Pr^0.33)*kt_/deq;
elseif type==2
    hint=(alpha0*deq/kt_+0.15*Re^0.76*Pr^0.33)*kt_/deq;
end

U=1/(Di*log(De/Di)/2/k_tube+1/hint);
Tpe=T+Q/U;
end
