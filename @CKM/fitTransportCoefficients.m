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
% fitTransportCoefficients fits transport coefficients in the form:
% exp( ck(1) + ck(2)*log(T) + ck(3)*(log(T)).^2 + ck(4)*(log(T)).^3 ),
% where T is the temperature [K] and ck is the transport coefficient
% vector. The function writes out coefficients in transport folder as:
%   - ckK (thermal conductivity);
%   - ckD (binary diffusivity);
%   - ckV (viscosity);
%   - HumanReadable/TransportFitTable.dat (Human readable coefficients);
%
% - out = fitTransportCoefficients(dataTh, dataTr, npoints, boundary):
%   - dataTh = thermodynamic data matrix (see thConv or thRed);
%   - dataTr = transport data matrix (see trConv or trRed);
%   - npoints = number of points on which the fitting is performed 
%       (50 is enough);
%   - boundary = temperature range ex: [300 2000];

function fitTransportCoefficients(dataTh, dataTr, npoints, boundary)
    % create the Temperature points to fit
    Tpoints = linspace(boundary(1), boundary(2), npoints);
    nspecies = length(dataTr);
    
    % import CKM module and allocate memory
    ckm = CKM;
    vi = zeros(nspecies,npoints);
    k = zeros(nspecies, npoints);
    ckV = cell(nspecies,5);
    ckK = cell(nspecies,5);
    errV = zeros(1,nspecies);
    errK = zeros(1,nspecies);
    opt = optimoptions("lsqnonlin","MaxFunctionEvaluations",3000,"MaxIterations",800,...
        "OptimalityTolerance",1e-10,"Display","off");

    % loop on species
    for i = 1:nspecies
        % loop on Temperature
        for j = 1:npoints
            % calculate k and vi
            k(i,j) = ckm.trProp(dataTr(i,1),Tpoints(j),1,"kt",dataTr,dataTh,"calc");
            vi(i,j) = ckm.trProp(dataTr(i,1),Tpoints(j),1,"vi",dataTr,dataTh,"calc");
        end
        % get species names
        ckK(i,1) = dataTr(i,1);
        ckV(i,1) = dataTr(i,1);
        % fit k and vi and get error values
        [tmp,errK(i)] = lsqnonlin(@(ck) fitkOrVi(ck,k(i,:),Tpoints),[3e-01 -3 5e-01 -2e-02],...
            [],[],[],[],[],[],[],opt);
        ckK(i,2:5) = num2cell(tmp);
        [tmp,errV(i)] = lsqnonlin(@(ck) fitkOrVi(ck,vi(i,:),Tpoints),[-1.5e+01 2 -2e-01 9e-03],...
            [],[],[],[],[],[],[],opt);
        ckV(i,2:5) = num2cell(tmp);
    end
    
    % allocate memory and get the combinations of species
    speciesDjk= nchoosek(dataTr(:,1),2);
    ckD = cell(length(speciesDjk),6);
    D = zeros(length(speciesDjk),npoints);

    % allocate memory
    ckD(:,1:2) = cellstr(speciesDjk);
    errD = zeros(1,length(speciesDjk));

    % loop on species combinations
    for i = 1:length(speciesDjk)
        % loop on temperature
        for j = 1:npoints %T
            % calculate Diff values
            D(i,j) = ckm.trProp([speciesDjk(i,:)],Tpoints(j),1,"diff",dataTr,dataTh,"calc");
        end
        % fit values and get error
        [tmp,errD(i)] = lsqnonlin(@(ck) fitDjk(ck,D(i,:),Tpoints),[-20 3 -0.3 5e-3],...
            [],[],[],[],[],[],[],opt);
        ckD(i,3:6) = num2cell(tmp);
    end
    
    % vi and k fit function
    function out = fitkOrVi(ck,expected,T)
        fit = exp( ck(1) + ck(2)*log(T) + ck(3)*(log(T)).^2 + ck(4)*(log(T)).^3 );
        out = abs(fit - expected)./expected;
    end
    
    % Diff fit function
    function out = fitDjk(ck,expected,T)
        fit = exp( ck(1) + ck(2)*log(T) + ck(3)*(log(T)).^2 + ck(4)*(log(T)).^3 );
        out = abs(fit - expected)./expected;
    end
    
    % prepare directories to save files
    if ~exist("transport_models/","dir")
       mkdir("transport_models/")
    end
    if ~exist("transport_models/HumanReadable/","dir")
       mkdir("transport_models/HumanReadable/")
    end
    if exist("transport_models/HumanReadable/TransportFitTable.dat","file")
       delete transport_models/HumanReadable/TransportFitTable.dat
    end
    
    % save matrix
    save("./transport_models/ckD.mat","ckD")
    save("./transport_models/ckV.mat","ckV")
    save("./transport_models/ckK.mat","ckK")

    % save coefficients in text file
    writecell(cellstr(["Thermal conductivity"; " "]),"./transport_models/HumanReadable/TransportFitTable.dat",...
        "WriteMode","append")
    writecell(ckK,"./transport_models/HumanReadable/TransportFitTable.dat","WriteMode","append",...
        "FileType","text","Delimiter"," ")
    
    writecell(cellstr([" ";"Viscosity";" "]),"./transport_models/HumanReadable/TransportFitTable.dat",...
        "WriteMode","append")
    writecell(ckV,"./transport_models/HumanReadable/TransportFitTable.dat","WriteMode","append",...
        "FileType","text","Delimiter"," ")
    
    writecell(cellstr([" ";"Diffusivity";" "]),"./transport_models/HumanReadable/TransportFitTable.dat",...
        "WriteMode","append")
    writecell(ckD,"./transport_models/HumanReadable/TransportFitTable.dat","WriteMode","append",...
        "FileType","text","Delimiter"," ")
    
    disp(" ")
    disp("---------------------------------------------------------------")
    disp("Fitting of Transport coefficients")
    disp(strcat("Average Error Viscosity: ", num2str(sum(errV/npoints))))
    disp(strcat("Max Error Viscosity: ", num2str(max(errV))))
    disp(" ")
        disp(strcat("Average Error thermal conductivity: ", num2str(sum(errV/npoints))))
    disp(strcat("Max Error thermal conductivity: ", num2str(max(errV))))
    disp(" ")
        disp(strcat("Average Error Diffusivity: ", num2str(sum(errD/npoints))))
    disp(strcat("Max Error Diffusivity: ", num2str(max(errD))))
    disp("---------------------------------------------------------------")
    disp(" ")
end

