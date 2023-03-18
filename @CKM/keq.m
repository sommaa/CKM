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

function Keq=keq(T,species,coeff,data)
    ckm = CKM;
    G=zeros(1,length(species));
    R=8.314;
    for i=1:length(species)
        G(i)=ckm.thProp(species(i),"G",T,data);
    end
    DGR=coeff*G';
    Keq=exp(-DGR/R/T);
end
