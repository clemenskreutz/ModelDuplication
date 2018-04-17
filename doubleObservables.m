function ar = doubleObservables(ar,m)

if(~isfield(ar.model(m),'y'))
    return
end

ar.model(m).map.old.y = ar.model(m).y;
ar.model(m).map.new.y = cell(size(ar.model(m).y));
for i=1:length(ar.model(m).map.old.y)
    ar.model(m).map.new.y{i} = strcat(ar.model(m).map.old.y{i},'_');
end
ar.model(m).y = [ar.model(m).map.old.y,ar.model(m).map.new.y];

ar.model(m).map.old.yNames = ar.model(m).yNames;
ar.model(m).map.new.yNames = cell(size(ar.model(m).yNames));
for i=1:length(ar.model(m).yNames)
    ar.model(m).map.new.yNames{i} = strcat(ar.model(m).map.old.yNames{i},'_');
end
ar.model(m).yNames = [ar.model(m).map.old.yNames,ar.model(m).map.new.yNames];

ar.model(m).yUnits = [ar.model(m).yUnits;ar.model(m).yUnits];

ar.model(m).normalize = [ar.model(m).normalize,ar.model(m).normalize];

ar.model(m).logfitting = [ar.model(m).logfitting,ar.model(m).logfitting];

ar.model(m).logplotting = [ar.model(m).logplotting,ar.model(m).logplotting];

ar.model(m).map.old.fy = ar.model(m).fy;
ar.model(m).map.new.fy = cell(size(ar.model(m).fy));
for i=1:length(ar.model(m).fy)
    ar.model(m).map.new.fy{i} = char(subs(subs(subs(ar.model(m).map.old.fy{i},ar.model(m).map.old.x,ar.model(m).map.new.x),ar.model(m).map.old.py,ar.model(m).map.new.py),ar.model(m).map.old.z,ar.model(m).map.new.z));
end
ar.model(m).fy = [ar.model(m).map.old.fy; ar.model(m).map.new.fy];
        
ar.model(m).map.old.fystd = ar.model(m).fystd;
ar.model(m).map.new.fystd = cell(size(ar.model(m).fystd));
for i=1:length(ar.model(m).fystd)
    ar.model(m).map.new.fystd{i} = char(subs(subs(subs(ar.model(m).map.old.fystd{i},ar.model(m).map.old.x,ar.model(m).map.new.x),ar.model(m).map.old.py,ar.model(m).map.new.py),ar.model(m).map.old.pystd,ar.model(m).map.new.pystd));
end
if(size(ar.model(m).map.old.fystd,2)>1)
    ar.model(m).fystd = [ar.model(m).map.old.fystd,ar.model(m).map.new.fystd];
else
    ar.model(m).fystd = [ar.model(m).map.old.fystd;ar.model(m).map.new.fystd];
end
    
