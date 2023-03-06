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


function chemkin_thermo_converter(thermo_data_name,species)
    % preparing cells
    data = cell(numel(species)*4,5);
    % readmode thermodinamics file
    ReadFileID = fopen(strcat(thermo_data_name), 'rt');
    % creating directory if not ex
    if ~exist("thermo_models/")
       mkdir("thermo_models/")
    end
    % read first line
    textLine = fgetl(ReadFileID);
    % start counters
    lineCounter = 1;
    specieCounter = 1;

    % looping on lines
    while ischar(textLine)
        specie_name = split(textLine);
        if any(strcmp(species,specie_name(1)))
            
            data(specieCounter*4-3,1) = specie_name(1);
            for j = 1:3
                textLine = fgetl(ReadFileID);
                for i = 1:5
                    data(j+specieCounter*4-3,i) = cellstr(strtrim(textLine(i*15-14:i*15)));
                end
            end
            specieCounter = specieCounter + 1;
        end


        % Read the next line.
        textLine = fgetl(ReadFileID);
        lineCounter = lineCounter + 1;
    end
    fclose(ReadFileID);
    save(strcat("thermo_models/",extractBefore(thermo_data_name,'.'),"_reduced.mat"))
end
