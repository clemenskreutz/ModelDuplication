% yExp, yExpStd
% 
function ar = doubleData(ar,m,d)

for i=1:length(ar.model(m).data(d).map.old.y)
    i1 = strmatch(ar.model(m).data(d).map.old.y{i},            ar.model(m).data(d).y,'exact');
    i2 = strmatch(strcat(ar.model(m).data(d).map.old.y{i},'_'),ar.model(m).data(d).y,'exact');
    ar.model(m).data(d).yExp(:,i2) = ar.model(m).data(d).yExp(:,i1);
    ar.model(m).data(d).yExpStd(:,i2) = ar.model(m).data(d).yExpStd(:,i1);
    ar.model(m).data(d).yExp(:,i2) = ar.model(m).data(d).yExp(:,i1);
end


