function ar = doubleInputs(ar,m)

ar.model(m).map.old.u = ar.model(m).u;
ar.model(m).map.new1.u = strcat(ar.model(m).u,doubleSuffix1);
ar.model(m).map.new2.u = strcat(ar.model(m).u,doubleSuffix2);
ar.model(m).u = [ar.model(m).map.new1.u,ar.model(m).map.new2.u];


ar.model(m).uUnits = [ar.model(m).uUnits;ar.model(m).uUnits];

ar.model(m).qPlotU = [ar.model(m).qPlotU,ar.model(m).qPlotU];

ar.model(m).map.old.pu = ar.model(m).pu;
ar.model(m).map.new1.pu = strcat(ar.model(m).pu,doubleSuffix1);
ar.model(m).map.new2.pu = strcat(ar.model(m).pu,doubleSuffix2);
ar.model(m).pu = [ar.model(m).map.new1.pu;ar.model(m).map.new2.pu];

ar.model(m).map.old.fu = ar.model(m).fu;
ar.model(m).map.new1.fu = cell(size(ar.model(m).fu));
ar.model(m).map.new2.fu = cell(size(ar.model(m).fu));
for i=1:length(ar.model(m).fu)
    ar.model(m).map.new1.fu{i} = char(subs(ar.model(m).fu{i},ar.model(m).map.old.pu,ar.model(m).map.new1.pu));
    ar.model(m).map.new2.fu{i} = char(subs(ar.model(m).fu{i},ar.model(m).map.old.pu,ar.model(m).map.new2.pu));
end
if size(ar.model(m).map.new1.fu,1)>1
    ar.model(m).fu = [ar.model(m).map.new1.fu;ar.model(m).map.new2.fu];
else
    ar.model(m).fu = [ar.model(m).map.new1.fu,ar.model(m).map.new2.fu];
end


% %% Vorher: Ergebnis bei mehreren Inputs(Beispielhaft) = "Matrix(['___','___','___','___'])" bei 2 Inputs
% %  Siehe Oxygen_Metabolic_Rates_2016 zum Vergleich
% for i=1:length(ar.model(m).fu)
%     inp = char(  subs(ar.model(m).fu{i}, ar.model(m).map.old.pu, ar.model(m).map.new2.pu)  );
%     ar.model(m).fu{end+1} = inp;
% end
% %ar.model(m).fu = [ar.model(m).fu;char(subs(ar.model(m).fu,ar.model(m).map.old.pu,ar.model(m).map.new2.pu))];
