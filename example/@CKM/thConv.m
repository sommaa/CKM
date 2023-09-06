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


function thConv(thermo_data_name)
El = ["D";
"H";
"HE";
"Li";
"Be";
"B";
"C";
"N";
"O";
"F";
"Ne";
"Na";
"Mg";
"Al";
"Si";
"P";
"S";
"Cl";
"AR";
"K";
"Ca";
"Sc";
"Ti";
"V";
"Cr";
"Mn";
"Fe";
"Co";
"Ni";
"Cu";
"Zn";
"Ga";
"Ge";
"As";
"Se";
"Br";
"Kr";
"Rb";
"Sr";
"Y";
"Zr";
"Nb";
"Mo";
"Ru";
"Rh";
"Pd";
"Ag";
"Cd";
"In";
"Sn";
"Sb";
"Te";
"I";
"Xe";
"Cs";
"Ba";
"La";
"Ce";
"Pr";
"Nd";
"Sm";
"Eu";
"Gd";
"Tb";
"Dy";
"Ho";
"Er";
"Tm";
"Yb";
"Lu";
"Hf";
"Ta";
"W";
"Re";
"Os";
"Ir";
"Pt";
"Au";
"Hg";
"Tl";
"Pb";
"Bi";
"Th";
"U"];

MM = [2.01410100000000;
1.00800000000000;
4.00260200000000;
6.94000000000000;
9.01218200000000;
10.8100000000000;
12.0110000000000;
14.0070000000000;
15.9990000000000;
18.9984032000000;
20.1797000000000;
22.9897692800000;
24.3050000000000;
26.9815386000000;
28.0850000000000;
30.9737620000000;
32.0600000000000;
35.4500000000000;
39.9480000000000;
39.0983000000000;
40.0780000000000;
44.9559120000000;
47.8670000000000;
50.9415000000000;
51.9961000000000;
54.9380450000000;
55.8450000000000;
58.9331950000000;
58.6934000000000;
63.5460000000000;
65.3800000000000;
69.7230000000000;
72.6300000000000;
74.9216000000000;
78.9600000000000;
79.9040000000000;
83.7980000000000;
85.4678000000000;
87.6200000000000;
88.9058500000000;
91.2240000000000;
92.9063800000000;
95.9600000000000;
101.070000000000;
102.905500000000;
106.420000000000;
107.868200000000;
112.411000000000;
114.818000000000;
118.710000000000;
121.760000000000;
127.600000000000;
126.904470000000;
131.293000000000;
132.905451900000;
137.327000000000;
138.905470000000;
140.116000000000;
140.907650000000;
144.242000000000;
150.360000000000;
151.964000000000;
157.250000000000;
158.925350000000;
162.500000000000;
164.930320000000;
167.259000000000;
168.934210000000;
173.054000000000;
174.966800000000;
178.490000000000;
180.947880000000;
183.840000000000;
186.207000000000;
190.230000000000;
192.217000000000;
195.084000000000;
196.966569000000;
200.590000000000;
204.380000000000;
207.200000000000;
208.980400000000;
232.038060000000;
238.028910000000];

    % readmode thermodinamics file
    ReadFileID = fopen(strcat(thermo_data_name), 'rt');
    % creating directory if not ex
    if ~exist("thermo/")
        mkdir("thermo/")
    end
    % read first line
    textLine = fgetl(ReadFileID);
    % start counters and vect
    lineCounter = 1;
    specieCounter = 1;
    startWriting = 0;
    element = string;
    dataTh = cell(1,5);

    % looping on lines
    while ischar(textLine)
        if textLine == "END"
            break
        end

        if textLine == "THERMO ALL"
            startWriting = 1;
            textLine = fgetl(ReadFileID);
            textLine = fgetl(ReadFileID);
        end

        if length(textLine)>15 && startWriting == 1
            if textLine(1)~='!'
                specie_name = split(textLine);

                PM = 0;
                mass = strtrim(textLine(25:44));
                mass_splitted = split(mass);
                index_to_cut = find(isnan(str2double(mass_splitted)), 1, 'last' ) + 1;
                mass_raw = strjoin(mass_splitted(1:index_to_cut),"");
                idx_char = isstrprop(mass_raw,'alpha');
                start_idx = 1;
                counter_mm = 1;
                element = string;

                for i = 2:length(mass_raw)
                    if idx_char(i) ~= idx_char(i-1)
                        element(counter_mm) = mass_raw(start_idx:(i-1));
                        start_idx = i;
                        counter_mm = counter_mm +1;
                    end
                end
                element(counter_mm) = mass_raw(start_idx:end);
    
                counter_mm2 = 1;
                for i = 1:length(element)/2
                    indx_El = find(El==element(counter_mm2));
                    PM = MM(indx_El) * str2double(element(counter_mm2+1)) + PM;
                    counter_mm2 = counter_mm2 + 2;
                end

                dataTh(specieCounter*4-3,1) = specie_name(1);
                dataTh(specieCounter*4-3,5) = num2cell(PM);
                dataTh(specieCounter*4-3,2) = join(cellstr(element),',');
                
                for j = 1:3
                    textLine = fgetl(ReadFileID);
                    for i = 1:5
                        dataTh(j+specieCounter*4-3,i) = cellstr(strtrim(textLine(i*15-14:i*15)));
                    end
                end
                specieCounter = specieCounter + 1;
            end
        end
    
    
        % Read the next line.
        textLine = fgetl(ReadFileID);
        lineCounter = lineCounter + 1;
    end
    fclose(ReadFileID);
    save("./thermo/conv.mat","dataTh")
end
