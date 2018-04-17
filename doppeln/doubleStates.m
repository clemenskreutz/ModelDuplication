function ar = doubleStates(ar,m)

ar.model(m).map.old.x = ar.model(m).x;
ar.model(m).map.new.x = strcat(ar.model(m).x,'_');
ar.model(m).x = [ar.model(m).map.old.x,ar.model(m).map.new.x];
    
ar.model(m).map.old.px0 = ar.model(m).px0;
ar.model(m).map.new.px0 = strcat(ar.model(m).px0,'_');
ar.model(m).px0 = [ar.model(m).map.old.px0,ar.model(m).map.new.px0];
    
ar.model(m).map.old.xNames = ar.model(m).xNames;
ar.model(m).map.new.xNames = strcat(ar.model(m).xNames,'_');
ar.model(m).xNames = [ar.model(m).map.old.xNames,ar.model(m).map.new.xNames];
    
ar.model(m).xUnits = [ar.model(m).xUnits;ar.model(m).xUnits];
ar.model(m).cLink = [ar.model(m).cLink,ar.model(m).cLink];
ar.model(m).qPlotX = [ar.model(m).qPlotX,ar.model(m).qPlotX];
ar.model(m).qPositiveX = [ar.model(m).qPositiveX,ar.model(m).qPositiveX];

