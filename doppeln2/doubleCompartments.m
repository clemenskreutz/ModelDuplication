function ar = doubleCompartments(ar,m)


ar.model(m).map.old.c = ar.model(m).c;
ar.model(m).map.new1.c = strcat(ar.model(m).c,doubleSuffix1);
ar.model(m).map.new2.c = strcat(ar.model(m).c,doubleSuffix2);
ar.model(m).c = [ar.model(m).map.new1.c,ar.model(m).map.new2.c];


ar.model(m).cUnits = [ar.model(m).cUnits;ar.model(m).cUnits];

ar.model(m).pc = [ar.model(m).pc,ar.model(m).pc];

ar.model(m).map.old.px = ar.model(m).px;
ar.model(m).map.new1.px = strcat(ar.model(m).px,doubleSuffix1);
ar.model(m).map.new2.px = strcat(ar.model(m).px,doubleSuffix2);
ar.model(m).px = [ar.model(m).map.new1.px;ar.model(m).map.new2.px];

