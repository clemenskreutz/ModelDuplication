% ar = doubleUpdateMap(ar,m,field,d)
% 
% This function searches for field entries which are termed according to
% primary/seconary pairs (primary: doubleSuffix1, secondary: doubleSuffix2)

function ar = doubleUpdateMap(ar,m,field,d,ignore)
if(~exist('d','var') || isempty(d))
    d = [];
end
if(~exist('ignore','var') || isempty(ignore))
    ignore = cell(0);
end


if isempty(d)
    model_or_data = ar.model(m);
else
    model_or_data = ar.model(m).data(d);
end

if(~isfield(model_or_data,field))
    field
    warning('field not available')
    return
end

val = model_or_data.(field);
if iscell(val)
    inew1 = find(~cellfun(@isempty,regexp(val,[doubleSuffix1,'$'])));
    inew2 = find(~cellfun(@isempty,regexp(val,[doubleSuffix2,'$'])));
else
    inew1 = ~isempty(regexp(val,[doubleSuffix1,'$']));
    inew2 = ~isempty(regexp(val,[doubleSuffix2,'$']));
end
[~,iignore] = intersect(ignore,val);
iold = setdiff(setdiff(setdiff(1:length(val),inew1),inew2),iignore);  % for all existing single fields, create pairs

if ~isfield(model_or_data,'map') || ~isstruct(model_or_data.map)
    model_or_data.map = struct;
    model_or_data.map.old = struct;
    model_or_data.map.new1 = struct;
    model_or_data.map.new2 = struct;
end

if ~isempty(iold) % there are some new values where duplication is required

    if isfield(model_or_data.map.old,field)
        model_or_data.map.old.(field) = unique(union(val(iold),model_or_data.map.old.(field)));
    else
        if ~isempty(inew1) || ~isempty(inew2)
            model_or_data.map.old.(field) = cell(0);
            model_or_data.map.new1.(field) = cell(0);
            model_or_data.map.new2.(field) = cell(0);
            if length(inew1)==length(inew2)
                for i1=1:length(inew1)
                    i2 = strmatch(strcat(regexprep(model_or_data.(field){inew1(i1)},[doubleSuffix1,'$'],''),doubleSuffix2),model_or_data.(field)(inew2),'exact');
                    if length(i2)~=1
                        strcat(regexprep(model_or_data.(field){inew1(i1)},[doubleSuffix1,'$'],''),doubleSuffix2)
                        error('corresponding secondary not found (should not occur).')
                    end
                    
                    model_or_data.map.old.(field){end+1} = regexprep(model_or_data.(field){inew1(i1)},[doubleSuffix1,'$'],'');
                    model_or_data.map.new1.(field){end+1} = model_or_data.(field){inew1(i1)};
                    model_or_data.map.new2.(field){end+1} = model_or_data.(field){inew2(i2)};
                end
            else
                model_or_data.(field);
                error('length(inew1)==length(inew2)')
            end
%             error('model_or_data.map.old.(%s) was empty but Suffix variables are already in model_or_data.%s.',field,field);
%             model_or_data.map.old.(field)(inew1) = regexprep(model_or_data.(field)(inew1),[doubleSuffix1,'$'],'');
%             model_or_data.map.old.(field)(inew2) = regexprep(model_or_data.(field)(inew2),[doubleSuffix2,'$'],'');
%             model_or_data.map.old.(field)(iold) = val(iold);
        else
            model_or_data.map.old.(field) = val(iold);
        end
    end
    
    model_or_data.map.new1.(field) = strcat(model_or_data.map.old.(field),doubleSuffix1);
    model_or_data.map.new2.(field) = strcat(model_or_data.map.old.(field),doubleSuffix2);
    
    if size(model_or_data.map.new1.(field),1)==1 && size(model_or_data.map.new1.(field),2)>1
        model_or_data.(field) = [model_or_data.map.new1.(field),model_or_data.map.new2.(field)];
    else
        model_or_data.(field) = [model_or_data.map.new1.(field);model_or_data.map.new2.(field)];
    end
else % alles bleibt, wie es ist
    if ~isfield(model_or_data.map.old,field)
        model_or_data.map.old.(field) = [];
        model_or_data.map.new1.(field) = [];
        model_or_data.map.new2.(field) = [];
    end
end

if isempty(d)
    ar.model(m) = model_or_data;
elseif d==1
    ar.model(m).data = model_or_data;
else
    ar.model(m).data(d) = model_or_data;
end

