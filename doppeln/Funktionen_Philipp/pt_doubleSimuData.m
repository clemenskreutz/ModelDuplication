%Use it after doubled eq. and arSimuData

function doubleSimuData

global ar;

for k = 1:length(ar.model.data.map.old.fy)
    position = find(strcmp(ar.model.data.map.new.fy(k),ar.model.data.fy));
    for j = 1:length(ar.model.data.yExp)
        ar.model.data.yExp(j,position) = ar.model.data.yExp(j,k);
    end
end

if ~(ar.model.data.yExp(:,1:length(ar.model.data.map.old.fy)) == ...
        ar.model.data.yExp(:,(length(ar.model.data.map.new.fy)+1):2*length(ar.model.data.map.new.fy)))
    disp('There might be a problem with the Simulated Data!');
end
    