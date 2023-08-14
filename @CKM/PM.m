function out=PM(species,data)
    
    PM_vect=zeros(1,length(species));
    
    for i=1:length(species)
        index = find((species(i)==string(data(:,1)))==1);
        PM_vect(i) = cell2mat(data(index,5));
    end
    out = PM_vect.*1e-3;
end