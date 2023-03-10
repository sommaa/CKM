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

function out = trProp(specie,T,P,prop,data_trans,PM_table,data)
% collision integrals coefficients fitted for (9,6)potential function from
% https://nvlpubs.nist.gov/nistpubs/jres/72A/jresv72An4p359_A1b.pdf

cc1 = [0.5059 0.5741 2.217 3.153 0.6251 0.9346 0.6495 0.01513];
cc2 = [1.109 0.3815 0.5508 2.097 1.603 2.097 0.2839 -0.01345];

PM = zeros(1,length(specie));
index = zeros(1,length(specie));
type = zeros(1,length(specie));
epsonk = zeros(1,length(specie));
lennar = zeros(1,length(specie));
mu = zeros(1,length(specie));
alpha = zeros(1,length(specie));
Zrot0 = zeros(1,length(specie));

for i =1:length(specie)
    PM(i) = PM_fun(specie(i),PM_table); %molecular mass Kg/mol
    index(i) = find(strcmp(data_trans(:,1),specie(i))==1);
    type(i) = str2double(data_trans(index(i),2));
    epsonk(i) = str2double(data_trans(index(i),3)); %K
    lennar(i) = str2double(data_trans(index(i),4))*1e-10; %m
    mu(i) = str2double(data_trans(index(i),5));
    alpha(i) = str2double(data_trans(index(i),6));
    Zrot0(i) = str2double(data_trans(index(i),7));
end

kb = 1.3806488e-23; %J/K
NA = 6.02214076e23;
Tred = T./epsonk;
R = 8.3144621;

if prop == "vi" && length(specie)==1
    coll2_2 = cc2(1)/(Tred)^cc2(2)+cc2(3)/exp(cc2(4)*Tred)+cc2(5)/exp(cc2(6)*Tred)+cc2(7)/exp(cc2(8)*Tred);
    out = 5/16*sqrt(pi*PM*kb*T/NA)/(pi*lennar^2*coll2_2);
    
elseif prop == "kt" && length(specie)==1
    cvtrans = 3/2;
    
    if type == 0
        cvrot = 0;
    elseif type == 1
        cvrot = 1;
    elseif type == 2
        cvrot = 3/2;
    else
        error('error in type')
    end
    
    cv = all_thermo(specie,"cp",T,data)/R-1;
    cvvib = cv-cvtrans-cvrot;
    
    coll1_1 = cc1(1)/(Tred(1))^cc1(2)+cc1(3)/exp(cc1(4)*Tred(1))+cc1(5)/exp(cc1(6)*Tred(1))+cc1(7)/exp(cc1(8)*Tred(1));
    pDii = 3/16*sqrt(2*pi*kb^3*T^3/(PM/NA))/(pi*lennar^2*coll1_1);
    coll2_2 = cc2(1)/(Tred)^cc2(2)+cc2(3)/exp(cc2(4)*Tred)+cc2(5)/exp(cc2(6)*Tred)+cc2(7)/exp(cc2(8)*Tred);
    vi = 5/16*sqrt(pi*PM*kb*T/NA)/(pi*lennar^2*coll2_2);
    fvib = PM/R/T*pDii/vi;
    A = 5/2-fvib;
    Zrot = Zrot0/(1+pi^(3/2)/2+(pi^2/4+2)*Tred^-1+pi^(3/2)*Tred^(-3/2))*(1+pi^(3/2)/2+(pi^2/4+2)*298^-1+pi^(3/2)*298^(-3/2));
    B = Zrot+2/pi*(5/3*cvrot/R+fvib);
    C = 2/pi*A/B;
    frot = fvib*(1+C);
    ftrans = 5/2*(1-C*cvrot/cvtrans);
    out = vi/PM*R*(ftrans*cvtrans+frot*cvrot+fvib*cvvib);
    
elseif prop == "diff" && length(specie)==2
    if (alpha(1)==0  && alpha(2)~=0) || (alpha(2)==0  && alpha(1)~=0) %non polar + polar
        P = 1e5*P; %Pa (input in bar)
        mij = (PM(1)*PM(2)/NA^2)/(PM(1)/NA+PM(2)/NA);
        [alphan,inn] = min(alpha);
        [~,inp] = max(alpha);
        alphanred = alphan/lennar(inn)^3;
        mupred = mu(inp)/sqrt(epsonk(inp)*lennar(inp)^3);
        roten = 1+1/4*alphanred*mupred*sqrt(max(epsonk)/min(epsonk));
        lennarij = 0.5*(lennar(1)+lennar(2))*roten^(-1/6);
        epsonkij = roten^2*sqrt(epsonk(1)*epsonk(2));
        Tred = T/epsonkij;
        coll1_1ij = cc1(1)/(Tred)^cc1(2)+cc1(3)/exp(cc1(4)*Tred)+cc1(5)/exp(cc1(6)*Tred)+cc1(7)/exp(cc1(8)*Tred);
        out = 3/16*sqrt(2*pi*kb^3*T^3/(mij))/(pi*lennarij^2*coll1_1ij)/P;
    else % non polar + non polar or polar + polar
        
        P = 1e5*P; %Pa (input in bar)
        lennarij = 0.5*(lennar(2)+lennar(2));
        mij = (PM(1)*PM(2)/NA^2)/(PM(1)/NA+PM(2)/NA);
        epsonkij = sqrt(epsonk(1)*epsonk(2));
        Tred = T/epsonkij;
        coll1_1ij = cc1(1)/(Tred)^cc1(2)+cc1(3)/exp(cc1(4)*Tred)+cc1(5)/exp(cc1(6)*Tred)+cc1(7)/exp(cc1(8)*Tred);
        out = 3/16*sqrt(2*pi*kb^3*T^3/(mij))/(pi*lennarij^2*coll1_1ij)/P;
        
    end
else
    error('only vi,kt,diff supported and only 2 species at a time for diff coeff')
end
