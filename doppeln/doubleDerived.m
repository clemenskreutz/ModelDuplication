function ar = doubleDerived(ar,m)

ar.model(m).map.old.z = ar.model(m).z;
ar.model(m).map.new.z = strcat(ar.model(m).z,'_');
ar.model(m).z = [ar.model(m).map.old.z,ar.model(m).map.new.z];


ar.model(m).map.old.fz = ar.model(m).fz;
ar.model(m).map.new.fz = cell(size(ar.model(m).fz));
for i=1:length(ar.model(m).fz)
    ar.model(m).map.new.fz{i} = char(subs(ar.model(m).map.old.fz{i},ar.model(m).map.old.x,ar.model(m).map.new.x));
end
ar.model(m).fz = [ar.model(m).map.old.fz;ar.model(m).map.new.fz];

ar.model(m).zUnits = [ar.model(m).zUnits;ar.model(m).zUnits];

ar.model(m).qPlotZ = [ar.model(m).qPlotZ,ar.model(m).qPlotZ];

