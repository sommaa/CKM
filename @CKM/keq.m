%            ________  ___  __        _____ ______                 
%           |\   ____\|\  \|\  \     |\   _ \  _   \                        
%           \ \  \___|\ \  \/  /|_   \ \  \\\__\ \  \                     
%            \ \  \    \ \   ___  \   \ \  \\|__| \  \                    
%             \ \  \____\ \  \\ \  \ __\ \  \    \ \  \                   
%              \ \_______\ \__\\ \__\\__\ \__\    \ \__\                  
%               \|_______|\|__| \|__\|__|\|__|     \|__|                  
%                                                                         
%                     Author: Andrea Somma;                                
%                     Politecnico of Milan                                 
%                                               
% keq calculated the equilibrium constant of a wanted reaction for ideal
% gas approximation
%
% - Keq=keq(T,species,coeff,data): where T is the temperature [K], species
%       is the string vector of the species in the reaction, coeff is the
%       vector of the corresponding stochiometric coefficients and data is 
%       the converted thermo matrix (see thConv or thRed).
%
function Keq=keq(T,species,coeff,data)
    ckm = CKM;
    R=8.314;
    G=ckm.thProp(species,"G",T,data)';
    DGR=coeff*G';
    Keq=exp(-DGR/R/T);
end
