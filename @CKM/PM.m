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
% PM calculates the molecular weights in SI
% 
% - PM=PM(species,data): where "species" is the vector of the species, and
%       data is the thermo matrix converted from CHEMKIN thermo sheet 
%       (see thConv or thRed).

function out=PM(species,data)
[species_unique,~,ic] = unique(species);


[~,index] = ismember(species_unique,string(data(:,1)));
PM_vect = cell2mat(data(index,5));
PM_vect = reshape(PM_vect(ic),size(species));

out = PM_vect.*1e-3;
end
