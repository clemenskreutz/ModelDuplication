function ar = doubleObservablesData(ar,m,d)

iold = find(cellfun(@isempty,regexp(ar.model(m).data(d).y,'_$')));


ar.model(m).data(d).map.old.y = ar.model(m).data(d).y(iold);
ar.model(m).data(d).map.new.y = cell(size(ar.model(m).data(d).y(iold)));
for i=1:length(ar.model(m).data(d).map.old.y)
    ar.model(m).data(d).map.new.y{i} = strcat(ar.model(m).data(d).map.old.y{i},'_');
end
ar.model(m).data(d).y = [ar.model(m).data(d).map.old.y,ar.model(m).data(d).map.new.y];

ar.model(m).data(d).map.old.yNames = ar.model(m).data(d).yNames(iold);
ar.model(m).data(d).map.new.yNames = cell(size(ar.model(m).data(d).yNames(iold)));
for i=1:length(ar.model(m).data(d).map.old.yNames)
    ar.model(m).data(d).map.new.yNames{i} = strcat(ar.model(m).data(d).map.old.yNames{i},'_');
end
ar.model(m).data(d).yNames = [ar.model(m).data(d).map.old.yNames,ar.model(m).data(d).map.new.yNames];

ar.model(m).data(d).yUnits = ar.model(m).data(d).yUnits(iold,:);
ar.model(m).data(d).yUnits = [ar.model(m).data(d).yUnits;ar.model(m).data(d).yUnits];

ar.model(m).data(d).normalize = ar.model(m).data(d).normalize(iold);
ar.model(m).data(d).normalize = [ar.model(m).data(d).normalize,ar.model(m).data(d).normalize];

ar.model(m).data(d).logfitting = ar.model(m).data(d).logfitting(iold);
ar.model(m).data(d).logfitting = [ar.model(m).data(d).logfitting,ar.model(m).data(d).logfitting];

ar.model(m).data(d).logplotting = ar.model(m).data(d).logplotting(iold);
ar.model(m).data(d).logplotting = [ar.model(m).data(d).logplotting,ar.model(m).data(d).logplotting];

ar.model(m).data(d).map.old.fy = ar.model(m).data(d).fy(iold);
ar.model(m).data(d).map.new.fy = cell(size(ar.model(m).data(d).fy(iold)));
for i=1:length(ar.model(m).data(d).map.old.fy)
    ar.model(m).data(d).map.new.fy{i} = char(subs(subs(subs(subs(ar.model(m).data(d).map.old.fy{i},ar.model(m).map.old.x,ar.model(m).map.new.x),ar.model(m).data(d).map.old.py,ar.model(m).data(d).map.new.py),ar.model(m).map.old.z,ar.model(m).map.new.z),ar.model(m).map.old.u,ar.model(m).map.new.u));
end
ar.model(m).data(d).fy = [ar.model(m).data(d).map.old.fy; ar.model(m).data(d).map.new.fy];
        
ar.model(m).data(d).map.old.fystd = ar.model(m).data(d).fystd(iold);
ar.model(m).data(d).map.new.fystd = cell(size(ar.model(m).data(d).fystd(iold)));
for i=1:length(ar.model(m).data(d).map.old.fystd)
    ar.model(m).data(d).map.new.fystd{i} = char(subs(subs(subs(subs(ar.model(m).data(d).map.old.fystd{i}, ar.model(m).map.old.x,ar.model(m).map.new.x),  ar.model(m).data(d).map.old.py,ar.model(m).data(d).map.new.py),  ar.model(m).data(d).map.old.pystd,ar.model(m).data(d).map.new.pystd),  ar.model(m).data(d).map.old.y,ar.model(m).data(d).map.new.y) );
end
if(size(ar.model(m).data(d).map.old.fystd,2)>1) 
    ar.model(m).data(d).fystd = [ar.model(m).data(d).map.old.fystd,ar.model(m).data(d).map.new.fystd];
else
    ar.model(m).data(d).fystd = [ar.model(m).data(d).map.old.fystd;ar.model(m).data(d).map.new.fystd];
end


ar.model(m).data(d).map.old.py_sep = ar.model(m).data(d).py_sep(iold);
ar.model(m).data(d).map.new.py_sep = struct;
for i=1:length(ar.model(m).data(d).map.old.py_sep)
    for j=1:length(ar.model(m).data(d).map.old.py_sep(i).pars)
        tmp = char(subs(subs(subs(subs(ar.model(m).data(d).map.old.py_sep(i).pars{j},  ar.model(m).map.old.x,ar.model(m).map.new.x),  ar.model(m).data(d).map.old.py,  ar.model(m).data(d).map.new.py),ar.model(m).data(d).map.old.pystd, ar.model(m).data(d).map.new.pystd),  ar.model(m).map.old.u,ar.model(m).map.new.u));
        ar.model(m).data(d).map.new.py_sep(i).pars{j} = tmp;
    end
end
ar.model(m).data(d).py_sep = [ar.model(m).data(d).map.old.py_sep, ar.model(m).data(d).map.new.py_sep];
