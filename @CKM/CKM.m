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

classdef CKM
   methods (Static)
        Keq=keq(T,species,coeff,data)
   end
   methods (Static)
        thConv(thermo_data_name)
   end
   methods (Static)
        out=thProp(specie,prop,T,data)
   end
   methods (Static)
        thRed(thermo_data_name,species)
   end
   methods (Static)
        trConv(trans_data_name)
   end
   methods (Static)
        out = trProp(specie,T,P,prop,data_trans,PM_table,data)
   end
   methods (Static)
        trRed(trans_data_name,species)
   end
   methods (Static)
        PM(species,PM_table)
   end
end