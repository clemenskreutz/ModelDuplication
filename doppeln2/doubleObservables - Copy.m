function ar = doubleObservables(ar,m)

if(~isfield(ar.model(m),'y'))
    return
end

ar.model(m).map.old.y = ar.model(m).y;
ar.model(m).map.new1.y = strcat(ar.model(m).y,doubleSuffix1);
ar.model(m).map.new2.y = strcat(ar.model(m).y,doubleSuffix2);
ar.model(m).y = [ar.model(m).map.new1.y,ar.model(m).map.new2.y];

ar.model(m).map.old.yNames = ar.model(m).yNames;
ar.model(m).map.new1.yNames = strcat(ar.model(m).yNames,doubleSuffix1);
ar.model(m).map.new2.yNames = strcat(ar.model(m).yNames,doubleSuffix2);
ar.model(m).yNames = [ar.model(m).map.new1.yNames,ar.model(m).map.new2.yNames];

ar.model(m).yUnits = [ar.model(m).yUnits;ar.model(m).yUnits];

ar.model(m).normalize = [ar.model(m).normalize,ar.model(m).normalize];

ar.model(m).logfitting = [ar.model(m).logfitting,ar.model(m).logfitting];

ar.model(m).logplotting = [ar.model(m).logplotting,ar.model(m).logplotting];

ar.model(m).map.old.fy = ar.model(m).fy;
ar.model(m).map.new1.fy = cell(size(ar.model(m).fy));
ar.model(m).map.new2.fy = cell(size(ar.model(m).fy));
for i=1:length(ar.model(m).fy)
%     ar.model(m).map.new1.fy{i} = char(subs(subs(subs(ar.model(m).map.old.fy{i},ar.model(m).map.old.x,ar.model(m).map.new1.x),ar.model(m).map.old.py,ar.model(m).map.new1.py),ar.model(m).map.old.z,ar.model(m).map.new1.z));
%     ar.model(m).map.new2.fy{i} = char(subs(subs(subs(ar.model(m).map.old.fy{i},ar.model(m).map.old.x,ar.model(m).map.new2.x),ar.model(m).map.old.py,ar.model(m).map.new2.py),ar.model(m).map.old.z,ar.model(m).map.new2.z));
    ar.model(m).map.new1.fy{i} = doubleOld2New(ar.model(m).map.old.fy{i},[],1);
    ar.model(m).map.new2.fy{i} = doubleOld2New(ar.model(m).map.old.fy{i},[],2);
end
ar.model(m).fy = [ar.model(m).map.new1.fy; ar.model(m).map.new2.fy];
        
ar.model(m).map.old.fystd = ar.model(m).fystd;
ar.model(m).map.new1.fystd = cell(size(ar.model(m).fystd));
ar.model(m).map.new2.fystd = cell(size(ar.model(m).fystd));
for i=1:length(ar.model(m).fystd)
%     ar.model(m).map.new1.fystd{i} = char(subs(subs(subs(ar.model(m).map.old.fystd{i},ar.model(m).map.old.x,ar.model(m).map.new1.x),ar.model(m).map.old.py,ar.model(m).map.new1.py),ar.model(m).map.old.pystd,ar.model(m).map.new1.pystd));
%     ar.model(m).map.new2.fystd{i} = char(subs(subs(subs(ar.model(m).map.old.fystd{i},ar.model(m).map.old.x,ar.model(m).map.new2.x),ar.model(m).map.old.py,ar.model(m).map.new2.py),ar.model(m).map.old.pystd,ar.model(m).map.new2.pystd));
    ar.model(m).map.new1.fystd{i} = doubleOld2New(ar.model(m).map.old.fystd{i},[],1);
    ar.model(m).map.new2.fystd{i} = doubleOld2New(ar.model(m).map.old.fystd{i},[],2);
end
if(size(ar.model(m).map.old.fystd,2)>1)
    ar.model(m).fystd = [ar.model(m).map.new1.fystd,ar.model(m).map.new2.fystd];
else
    ar.model(m).fystd = [ar.model(m).map.new1.fystd;ar.model(m).map.new2.fystd];
end
    
