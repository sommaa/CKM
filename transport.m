function out=transport(prop,ii,T) %% perry's correlations
species={'CH4' 'H2O' 'CO' 'H2' 'CO2' 'N2'};
ii = find(ismember(species,ii)==1);

if prop=="kt"
    C1=[8.40e-06	6.20e-06	0.00059882	0.002653	3.69	0.00033143];
    C2=[1.4268	1.3973	0.6863	0.7452	-0.3838	0.7722];
    C3=[-49.654	0	57.13	12	964	16.323];
    C4=[0	0	501.92	0	1860000	373.72];
    
    out = C1(ii).*T.^(C2(ii))./(1+C3(ii)./T+C4(ii)./T.^2); %[W/m/K]
elseif prop=="vi"
    C1=[5.25e-07 1.71e-08 1.11e-06 1.80e-07 2.15e-06 6.56e-07];
    C2=[0.59006 1.1146 0.5338 0.685 0.46 0.6081];
    C3=[105.67 0 94.7 -0.59 290 54.714];
    C4=[0 0 0 140 0 0];
    out = C1(ii).*T.^(C2(ii))./(1+C3(ii)./T+C4(ii)./T.^2); %[Pa*s]
else
    error('error in visc and cond')
end
end