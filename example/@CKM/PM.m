function out=PM(species,data)
[species_unique,~,ic] = unique(species);


[~,index] = ismember(species_unique,string(data(:,1)));
PM_vect = cell2mat(data(index,5));
PM_vect = reshape(PM_vect(ic),size(species));

out = PM_vect.*1e-3;
end
