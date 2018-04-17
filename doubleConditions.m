function ar = doubleConditions(ar,m,d)
if(~exist('d','var') || isempty(d))
    d = [];
end

if(~isempty(d))
    if(~isfield(ar.model(m).data(d).map.old,'x'))
        ar.model(m).data(d).map.old.x = ar.model(m).map.old.x;
        ar.model(m).data(d).map.new.x = ar.model(m).map.new.x;
    end
    if(~isfield(ar.model(m).data(d).map.old,'u'))
        ar.model(m).data(d).map.old.u = ar.model(m).map.old.u;
        ar.model(m).data(d).map.new.u = ar.model(m).map.new.u;
    end
    mo_or_da = ar.model(m).data(d);
else
    mo_or_da = ar.model(m);
end

iold = find(cellfun(@isempty,regexp(mo_or_da.pcond,'_$')));
mo_or_da.map.old.pcond = mo_or_da.pcond(iold);
mo_or_da.map.new.pcond = strcat(mo_or_da.pcond(iold),'_');
mo_or_da.pcond = [mo_or_da.map.old.pcond;mo_or_da.map.new.pcond];

inew = find(~cellfun(@isempty,regexp(mo_or_da.p,'_$')));
for i=1:length(inew)
    iold = strmatch(mo_or_da.p{inew(i)}(1:end-1),mo_or_da.p,'exact');
    if(length(iold)~=1)
        mo_or_da.p{inew(i)}(1:end-1)
        error('corresponding primary parameter not found')
    end

    mo_or_da.fp{inew(i)} = char(subs(subs(subs(subs(mo_or_da.fp{iold},mo_or_da.map.old.p,mo_or_da.map.new.p), mo_or_da.map.old.x,mo_or_da.map.new.x), mo_or_da.map.old.u,mo_or_da.map.new.u), mo_or_da.map.old.pcond,mo_or_da.map.new.pcond));

    % is the following necessary (in the Becker example, it seems so)
    for m2=1:(m-1)
        tmp = char(subs(subs(mo_or_da.fp{inew(i)},ar.model(m2).map.old.p,ar.model(m2).map.new.p),ar.model(m2).map.old.pcond,ar.model(m2).map.new.pcond));
%         if(strcmp(tmp,mo_or_da.fp{inew(i)})~=1)
%             tmp
%             mo_or_da.fp{inew(i)}
%         end
        mo_or_da.fp{inew(i)} = tmp;
        
    end
        
end

if(~isempty(d))
    ar.model(m).data(d) = mo_or_da;
else
    ar.model(m) = mo_or_da;
end
