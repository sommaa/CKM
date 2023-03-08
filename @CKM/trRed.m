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

function trRed(trans_data_name,species)
    % preparing cells
    dataTr = cell(numel(species),7);
    % readmode thermodinamics file
    ReadFileID = fopen(strcat(trans_data_name), 'rt');
    % creating directory if not ex
    if ~exist("transport_models/")
       mkdir("transport_models/")
    end
    % read first line
    textLine = fgetl(ReadFileID);
    % start counters
    lineCounter = 1;
    specieCounter = 1;

    % looping on lines
    while ischar(textLine)
        splitted = split(textLine);
        if any(strcmp(species,splitted(1)))
                dataTr(specieCounter,1:7) = splitted(1:7);
            specieCounter = specieCounter + 1;
        end

        % Read the next line.
        textLine = fgetl(ReadFileID);
        lineCounter = lineCounter + 1;
    end
    fclose(ReadFileID);
    save("./transport_models/red.mat","dataTr")
end
