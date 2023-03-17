<a name="readme-top"></a>
![](https://img.shields.io/github/last-commit/sommaa/Chemkin_on_matlab?&style=for-the-badge&color=CFFC49&logoColor=171718&labelColor=171718)
[![](https://img.shields.io/github/repo-size/sommaa/Chemkin_on_matlab?color=%23DDB6F2&label=SIZE&logo=codesandbox&style=for-the-badge&logoColor=D9E0EE&labelColor=171718)](https://github.com/sommaa/Chemkin_on_matlab)

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/sommaa/Chemkin_on_matlab">
    <img src="https://user-images.githubusercontent.com/120776791/222243117-399a90cb-31e4-45be-afb8-ce26e24b7cd5.png" alt="Logo" width="300" height="75">
    
  </a>

  <h3 align="center">Chemkin on matlab</h3>

  <p align="center">
    A series of functions to use with chemkin like files on matlab!
    <br />
    <a href="https://github.com/sommaa/Chemkin_on_matlab/issues">Report Bug</a>
    ·
    <a href="https://github.com/sommaa/Chemkin_on_matlab/issues">Request Feature</a>
  </p>
</div>

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=sommaa/CKM)

## Documentation

- [thProp](/@CKM/thProp.m) out = thProp(specie,prop,T,data):
  - specie = name of the specie in chemkin format,
  - out = property to evaluate:
    - H = entalpy;
    - G = free energy;
    - cp = specific heat at constant pressure;
    - S = entropy;
  - T = temperature [K]
  - data = chemkin thermo data;
- [keq](/@CKM/keq.m) out = keq(T,species,coeff,data):

  - T = temperature [K];
  - specie = name of the species in chemkin format in a vector [a,b,c,d];
  - coeff = [A,B,C,D] stechiometric coefficients in a vector;
  - data = chemkin thermo data.

- [trProp](/@CKM/trProp.m) out = trProp(specie,T,P,prop,data_trans,PM_table,data):

  - specie = name of the species in chemkin format in a vector [a,b,c,d];
  - T = temperature [K];
  - P = pressure [bar];
  - prop = property to evaluate, based on collision integral:
    - vi = viscosity;
    - kt = thermal conductivity;
    - diff = diffusion mass coefficient;

- [thRed](/@CKM/thRed.m) out = thRed(path,species):
  - path = path of the chemkin thermo file;
  - specie = name of the species in chemkin format in a vector [a,b,c,d];
  - out = automatically saved .mat file
  
- [trRed](/@CKM/trRed.m) out = trRed(path,species):

  - path = path of the chemkin trans file;
  - specie = name of the species in chemkin format in a vector [a,b,c,d];
  - out = automatically saved .mat file

- [thConv](/@CKM/thConv.m) out = thConv(path):
  - path = path of the chemkin thermo file;
  - out = automatically saved .mat file
  
- [trConv](/@CKM/trConv.m) out = trConv(path):
  - path = path of the chemkin trans file;
  - out = automatically saved .mat file

- [SteamReformer.m](/example/SteamReformer.m): example of usage of functions. Parametric analysis of a steam reforming tube.

## Coming Soon
- Chemical equilibrium trough Gibbs minimization
- Chemkin Reaction Kinetic Mechanism support (not that soon probably)
