function chemkin_trans_reducer(trans_data_name,species)
    % preparing cells
    data_trans = cell(numel(species),7);
    % readmode thermodinamics file
    ReadFileID = fopen(strcat("./transport_models_full/",trans_data_name), 'rt');
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
                data_trans(specieCounter,1:7) = splitted(1:7);
            specieCounter = specieCounter + 1;
        end

        % Read the next line.
        textLine = fgetl(ReadFileID);
        lineCounter = lineCounter + 1;
    end
    fclose(ReadFileID);
    save(strcat("transport_models/",extractBefore(trans_data_name,'.'),"_reduced.mat"))
end