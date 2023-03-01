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

function out=all_thermo(specie,prop,T,data)

R=8.314;

[nspecies,~] = size(data);
nspecies=nspecies/4;

speciename=cell(1,nspecies);

for ii = 1:nspecies
    if ii == 1
        A = split(data(ii,1));
        speciename(ii) = A(1,1);
    else
        A = split(data((ii-1)*4+1,1));
        speciename(ii) = A(1,1);
    end
end
vect= 2:4:nspecies*4;
index_specie = find(ismember(speciename,specie)==1);

if T>1000 && T<5000 || T==5000
    
    coeff = [data(vect(index_specie),1) data(vect(index_specie),2) data(vect(index_specie),3)...
        data(vect(index_specie),4) data(vect(index_specie),5) data(vect(index_specie)+1,1) data(vect(index_specie)+1,2)];
    coeff = str2double(coeff);
    
elseif  T<1000 && T>200 || T==1000
    coeff = [data(vect(index_specie)+1,3) data(vect(index_specie)+1,4) data(vect(index_specie)+1,5) data(vect(index_specie)+2,1)...
        data(vect(index_specie)+2,2) data(vect(index_specie)+2,3) data(vect(index_specie)+2,4)];
    coeff = str2double(coeff);
    
else
    disp('temperature range not supported, only 200 to 4000 range accepted')
end

if prop == "cp"
    out= (coeff(1)+coeff(2)*T+coeff(3)*T^2+coeff(4)*T^3+coeff(5)*T^4)*R;
elseif prop == "H"
    out= (coeff(1)+coeff(2)*T/2+coeff(3)*T^2/3+coeff(4)*T^3/4+coeff(5)*T^4/5+coeff(6)/T)*R*T;
elseif prop == "S"
    out= (coeff(1)*log(T)+coeff(2)*T+coeff(3)*T^2/2+coeff(4)*T^3/3+coeff(5)*T^4/4+coeff(7))*R;
elseif prop == "G"
    H= (coeff(1)+coeff(2)*T/2+coeff(3)*T^2/3+coeff(4)*T^3/4+coeff(5)*T^4/5+coeff(6)/T)*R*T;
    S= (coeff(1)*log(T)+coeff(2)*T+coeff(3)*T^2/2+coeff(4)*T^3/3+coeff(5)*T^4/4+coeff(7))*R;
    out= H-T*S;
else
    disp('only cp,G,S,H supported')
end
end
