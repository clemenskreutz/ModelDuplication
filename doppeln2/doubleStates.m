% Duplication of 
% 
%   ar.model.x
%   ar.model.px0
%   ar.model.xNames
%   ar.model.xUnits
%   ar.model.cLink
%   ar.model.qPlotX
%   ar.model.qPositiveX

function ar = doubleStates(ar,m)

ar.model(m).map.old.x = ar.model(m).x;
ar.model(m).map.new1.x = strcat(ar.model(m).x,doubleSuffix1);
ar.model(m).map.new2.x = strcat(ar.model(m).x,doubleSuffix2);
ar.model(m).x = [ar.model(m).map.new1.x,ar.model(m).map.new2.x];
    
ar.model(m).map.old.px0 = ar.model(m).px0;
ar.model(m).map.new1.px0 = strcat(ar.model(m).px0,doubleSuffix1);
ar.model(m).map.new2.px0 = strcat(ar.model(m).px0,doubleSuffix2);
ar.model(m).px0 = [ar.model(m).map.new1.px0,ar.model(m).map.new2.px0];
    
ar.model(m).map.old.xNames = ar.model(m).xNames;
ar.model(m).map.new1.xNames = strcat(ar.model(m).xNames,doubleSuffix1);
ar.model(m).map.new2.xNames = strcat(ar.model(m).xNames,doubleSuffix2);
ar.model(m).xNames = [ar.model(m).map.new1.xNames,ar.model(m).map.new2.xNames];
    
ar.model(m).xUnits = [ar.model(m).xUnits;ar.model(m).xUnits];
ar.model(m).cLink = [ar.model(m).cLink,ar.model(m).cLink];
ar.model(m).qPlotX = [ar.model(m).qPlotX,ar.model(m).qPlotX];
ar.model(m).qPositiveX = [ar.model(m).qPositiveX,ar.model(m).qPositiveX];

