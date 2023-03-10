function out=PM(species,PM_table)
    
    PM_vect=zeros(1,length(species));
    
    for i=1:length(species)
        index = find(strcmp(cellstr(PM_table(:,1)),species(i))==1);
        PM_vect(i) = cell2mat(PM_table(index,2));
    end
    out = PM_vect.*1e-3;
end