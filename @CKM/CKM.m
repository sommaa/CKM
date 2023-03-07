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