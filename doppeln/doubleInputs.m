function ar = doubleInputs(ar,m)

ar.model(m).map.old.u = ar.model(m).u;
ar.model(m).map.new.u = cell(size(ar.model(m).u));
for i=1:length(ar.model(m).u)
    ar.model(m).map.new.u{i} = strcat(ar.model(m).map.old.u{i},'_');
end
ar.model(m).u = [ar.model(m).map.old.u,ar.model(m).map.new.u];


ar.model(m).uUnits = [ar.model(m).uUnits;ar.model(m).uUnits];

ar.model(m).qPlotU = [ar.model(m).qPlotU,ar.model(m).qPlotU];

ar.model(m).map.old.pu = ar.model(m).pu;
ar.model(m).map.new.pu = cell(size(ar.model(m).pu));
for i=1:length(ar.model(m).pu)
    ar.model(m).map.new.pu{i} = strcat(ar.model(m).map.old.pu{i},'_');
end
ar.model(m).pu = [ar.model(m).map.old.pu;ar.model(m).map.new.pu];
%% Vorher: Ergebnis bei mehreren Inputs(Beispielhaft) = "Matrix(['___','___','___','___'])" bei 2 Inputs
%  Siehe Oxygen_Metabolic_Rates_2016 zum Vergleich
for i=1:length(ar.model(m).fu)
    inp = char(subs(ar.model(m).fu{i},ar.model(m).map.old.pu,ar.model(m).map.new.pu));
    ar.model(m).fu{end+1} = inp;
end
%ar.model(m).fu = [ar.model(m).fu;char(subs(ar.model(m).fu,ar.model(m).map.old.pu,ar.model(m).map.new.pu))];
