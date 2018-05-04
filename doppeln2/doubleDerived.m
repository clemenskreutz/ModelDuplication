function ar = doubleDerived(ar,m)

ar.model(m).map.old.z = ar.model(m).z;
ar.model(m).map.new1.z = strcat(ar.model(m).z,doubleSuffix1);
ar.model(m).map.new2.z = strcat(ar.model(m).z,doubleSuffix2);
ar.model(m).z = [ar.model(m).map.new1.z,ar.model(m).map.new2.z];


ar.model(m).map.old.fz = ar.model(m).fz;
ar.model(m).map.new1.fz = cell(size(ar.model(m).fz));
ar.model(m).map.new2.fz = cell(size(ar.model(m).fz));
for i=1:length(ar.model(m).fz)
    ar.model(m).map.new1.fz{i} = char(subs(ar.model(m).fz{i},ar.model(m).map.old.x,ar.model(m).map.new1.x));
    ar.model(m).map.new2.fz{i} = char(subs(ar.model(m).fz{i},ar.model(m).map.old.x,ar.model(m).map.new2.x));
end
ar.model(m).fz = [ar.model(m).map.new1.fz;ar.model(m).map.new2.fz];

ar.model(m).zUnits = [ar.model(m).zUnits;ar.model(m).zUnits];

ar.model(m).qPlotZ = [ar.model(m).qPlotZ,ar.model(m).qPlotZ];

