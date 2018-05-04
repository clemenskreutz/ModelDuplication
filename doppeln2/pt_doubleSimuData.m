%Use it after doubled eq. and arSimuData
% 
%  This function copies simulated data from the primary experimental data
%  to the secondary part.

function doubleSimuData

global ar;

for m=1:length(ar.model)
    for d=1:length(ar.model(m).data)
        
        for k = 1:length(ar.model.data.map.old.fy)                       
            i1 = strmatch(ar.model(m).data(d).map.new1.fy{k},ar.model(m).data(d).fy,'exact');
            i2 = strmatch(ar.model(m).data(d).map.new2.fy{k},ar.model(m).data(d).fy,'exact');
                        
            ar.model.data.yExp(:,i2) = ar.model.data.yExp(:,i1);
            ar.model.data.yExpStd(:,i2) = ar.model.data.yExpStd(:,i1);
        end

        if length(i1)~=1 || length(i2)~=1
            disp('There might be a problem with the Simulated Data!');
        end
    end
end
