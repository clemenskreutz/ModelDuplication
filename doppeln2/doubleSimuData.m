%After arSimuData

function doubleSimuData

global ar;

arSimuData  % not the same for both parts of the model

for m=1:length(ar.model)
    for d=1:length(ar.model(m).data)
        old_fy = ar.model(m).data(d).fy(~cellfun(@isempty,regexp(ar.model(m).data(d).fy,[doubleSuffix1,'$'])));
        old_fy = regexprep(old_fy,[doubleSuffix1,'$'],'');
        
        if length(old_fy)~=length(ar.model(m).data(d).fy)/2
            old_fy
            ar.model(m).data(d).fy
            error('Half of the observables should match doubleSuffix1');
        end
        
        for k = 1:length(old_fy)
            position1 = find(strcmp([old_fy{k},doubleSuffix1],ar.model(m).data(d).fy));
            position2 = find(strcmp([old_fy{k},doubleSuffix2],ar.model(m).data(d).fy));
            if length(position1)~=1 || length(position2)~=1
                position1
                position2
                old_fy{k}
                ar.model(m).data(d).fy
                error('%s not found in ar.model(%i).data(%i).fy',[old_fy{k},doubleSuffix2],m,d);
            else
                ar.model(m).data(d).yExp(:,position2) = ar.model(m).data(d).yExp(:,position1);
            end
        end
        
%         if ~(ar.model(m).data(d).yExp(:,1:length(old_fy)) == ...
%                 ar.model(m).data(d).yExp(:,(length(ar.model(m).data(d).map.new2.fy)+1):2*length(ar.model(m).data(d).map.new2.fy)))
%             disp('There might be a problem with the Simulated Data!');
%         end
    end
end

