function ar = doubleInputsData(ar,m,d)

ar.model(m).data(d).map.old.fu = ar.model(m).data(d).fu;
ar.model(m).data(d).map.new1.fu = cell(size(ar.model(m).data(d).fu));
ar.model(m).data(d).map.new2.fu = cell(size(ar.model(m).data(d).fu));
if isfield(ar.model(m).data(d).map.old,'pu')
    for i=1:length(ar.model(m).data(d).fu)
        ar.model(m).data(d).map.new1.fu{i} = char(subs(ar.model(m).data(d).fu{i},ar.model(m).data(d).map.old.pu,ar.model(m).data(d).map.new1.pu));
        ar.model(m).data(d).map.new2.fu{i} = char(subs(ar.model(m).data(d).fu{i},ar.model(m).data(d).map.old.pu,ar.model(m).data(d).map.new2.pu));
    end
else
    for i=1:length(ar.model(m).data(d).fu)
        ar.model(m).data(d).map.new1.fu{i} = ar.model(m).data(d).fu{i};
        ar.model(m).data(d).map.new2.fu{i} = ar.model(m).data(d).fu{i};
    end
end
ar.model(m).data(d).fu = [ar.model(m).data(d).map.new1.fu,ar.model(m).data(d).map.new2.fu];

