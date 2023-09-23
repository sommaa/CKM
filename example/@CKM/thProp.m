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

function out=thProp(specie,prop,T,data)

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
[~,index_specie] = ismember(specie,speciename);

% index_specie = find(ismember(speciename,specie)==1);

% T>1000
coeffH = [data(vect(index_specie),1) data(vect(index_specie),2) data(vect(index_specie),3)...
    data(vect(index_specie),4) data(vect(index_specie),5) data(vect(index_specie)+1,1) data(vect(index_specie)+1,2)];
coeffH = str2double(coeffH);

%T<1000 && T>200 || T==1000
coeffL = [data(vect(index_specie)+1,3) data(vect(index_specie)+1,4) data(vect(index_specie)+1,5) data(vect(index_specie)+2,1)...
    data(vect(index_specie)+2,2) data(vect(index_specie)+2,3) data(vect(index_specie)+2,4)];
coeffL = str2double(coeffL);

LOWlogical = T<1000;
HIGHlogical = ~LOWlogical;

% rotate T if vertical
if size(T,1)>size(T,2)
    T = T';
end

if prop == "cp"
    out= (coeffH(:,1)+coeffH(:,2).*T+coeffH(:,3).*T.*T+coeffH(:,4).*T.*T.*T+coeffH(:,5).*T.*T.*T.*T)*R.*HIGHlogical' +...
        (coeffL(:,1)+coeffL(:,2).*T+coeffL(:,3).*T.*T+coeffL(:,4).*T.*T.*T+coeffL(:,5).*T.*T.*T.*T)*R.*LOWlogical';
elseif prop == "H"
    out= (coeffH(:,1)+coeffH(:,2).*T/2+coeffH(:,3).*T.*T/3+coeffH(:,4).*T.*T.*T/4+coeffH(:,5).*T.*T.*T.*T/5+coeffH(:,6)/T)*R.*T.*HIGHlogical'+...
        (coeffL(:,1)+coeffL(:,2).*T/2+coeffL(:,3).*T.*T/3+coeffL(:,4).*T.*T.*T/4+coeffL(:,5).*T.*T.*T.*T/5+coeffL(:,6)/T)*R.*T.*LOWlogical';
elseif prop == "S"
    out= (coeffH(:,1)*log(T)+coeffH(:,2).*T+coeffH(:,3).*T/2+coeffH(:,4).*T.*T.*T/3+coeffH(:,5).*T.*T.*T.*T/4+coeffH(:,7))*R.*HIGHlogical'+...
        (coeffL(:,1)*log(T)+coeffL(:,2).*T+coeffL(:,3).*T/2+coeffL(:,4).*T.*T.*T/3+coeffL(:,5).*T.*T.*T.*T/4+coeffL(:,7))*R.*LOWlogical';
elseif prop == "G"
    H= (coeffH(:,1)+coeffH(:,2).*T/2+coeffH(:,3).*T.*T/3+coeffH(:,4).*T.*T.*T/4+coeffH(:,5).*T.*T.*T.*T/5+coeffH(:,6)/T)*R.*T.*HIGHlogical'+...
        (coeffL(:,1)+coeffL(:,2).*T/2+coeffL(:,3).*T.*T/3+coeffL(:,4).*T.*T.*T/4+coeffL(:,5).*T.*T.*T.*T/5+coeffL(:,6)/T)*R.*T.*LOWlogical';
    S= (coeffH(:,1)*log(T)+coeffH(:,2).*T+coeffH(:,3).*T.*T/2+coeffH(:,4).*T.*T.*T/3+coeffH(:,5).*T.*T.*T.*T/4+coeffH(:,7))*R.*HIGHlogical'+...
        (coeffL(:,1)*log(T)+coeffL(:,2).*T+coeffL(:,3).*T.*T/2+coeffL(:,4).*T.*T.*T/3+coeffL(:,5).*T.*T.*T.*T/4+coeffL(:,7))*R.*LOWlogical';
    out= H-T*S;
else
    disp('only cp,G,S,H supported')
end
end
