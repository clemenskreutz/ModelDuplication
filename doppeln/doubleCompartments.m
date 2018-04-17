function ar = doubleCompartments(ar,m)


ar.model(m).map.old.c = ar.model(m).c;
ar.model(m).map.new.c = cell(size(ar.model(m).map.old.c));
for i=1:length(ar.model(m).map.old.c)
    ar.model(m).map.new.c{i} = strcat(ar.model(m).map.old.c{i},'_');
end
ar.model(m).c = [ar.model(m).map.old.c,ar.model(m).map.new.c];


ar.model(m).cUnits = [ar.model(m).cUnits;ar.model(m).cUnits];

ar.model(m).pc = [ar.model(m).pc,ar.model(m).pc];

ar.model(m).map.old.px = ar.model(m).px;
ar.model(m).map.new.px = strcat(ar.model(m).px,'_');
ar.model(m).px = [ar.model(m).map.old.px;ar.model(m).map.new.px];

