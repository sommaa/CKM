# Chemkin on matlab
A series of functions to use Chemkin-like files on matlab.

- [all_thermo.m](https://github.com/sommaa/Chemkin_on_matlam/blob/main/all_thermo.m) out = (specie,prop,T,data):
  - specie = name of the specie in chemkin format,
  - prop = property to evaluate:
    - H = entalpy;
    - G = free energy;
    - cp = specific heat at constant pressure;
    - S = entropy;
  - T = temperature [K]
  - data = chemkin thermo data;
  
- [vanthoff_all.m](https://github.com/sommaa/Chemkin_on_matlam/blob/main/vanthoff_all.m) Keq = (T,species,coeff,data):
  - T = temperature [K];
  - specie = name of the species in chemkin format in a vector [a,b,c,d];
  - coeff = [A,B,C,D] stechiometric coefficients in a vector;
  - data = chemkin thermo data.

- [stat_trans.m](https://github.com/sommaa/Chemkin_on_matlam/blob/main/stat_trans.m) out = stat_trans(specie,T,P,prop,data_trans,PM_table,data):
  - specie = name of the species in chemkin format in a vector [a,b,c,d];
  - T = temperature [K];
  - P = pressure [bar];
  - prop = property to evaluate, based on collision integral:
    - vi = viscosity;
    - kt = thermal conductivity;
    - diff = diffusion mass coefficient;

- [chemkin_thermo_reducer.m](https://github.com/sommaa/Chemkin_on_matlab/blob/main/functions/chemkin_thermo_reducer.m) out = chemkin_thermo_reducer(path,species):
  - path = path of the chemkin thermo file;
  - specie = name of the species in chemkin format in a vector [a,b,c,d];
  
- [chemkin_trans_reducer.m](https://github.com/sommaa/Chemkin_on_matlab/blob/main/functions/chemkin_trans_reducer.m) out = chemkin_trans_reducer(path,species):
  - path = path of the chemkin trans file;
  - specie = name of the species in chemkin format in a vector [a,b,c,d];
  
- [SteamReformer.m](https://github.com/sommaa/Chemkin_on_matlam/blob/main/SteamReformer.m): example of usage of functions. Parametric analysis of a steam reforming tube.
