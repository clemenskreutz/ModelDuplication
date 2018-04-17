function ar = doubleUpdateMap(ar,m,field,d)
if(~exist('d','var') || isempty(d))
    d = [];
end

if isempty(d)
    model_or_data = ar.model(m);
else
    model_or_data = ar.model(m).data(d);
end

if(~isfield(model_or_data,field))
%     field
    warning('field not available')
    return
end

val = model_or_data.(field);
inew = find(~cellfun(@isempty,regexp(val,'_$')));
iold = setdiff(1:length(val),inew);

model_or_data.map.old.(field) = cell(0);
model_or_data.map.new.(field) = cell(0);
for i=1:length(iold)
    model_or_data.map.old.(field){i,1} = val{iold(i)};   
    model_or_data.map.new.(field){i,1} = strcat(val{iold(i)},'_');
end

model_or_data.(field) = [model_or_data.map.old.(field);model_or_data.map.new.(field)];


if isempty(d)
    ar.model(m) = model_or_data;
elseif d==1
    ar.model(m).data = model_or_data;
else
    ar.model(m).data(d) = model_or_data;
end

