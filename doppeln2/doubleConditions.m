function ar = doubleConditions(ar,m,d)
if(~exist('d','var') || isempty(d))
    d = [];
end

if(~isempty(d))
    if(~isfield(ar.model(m).data(d).map.old,'x'))
        ar.model(m).data(d).map.old.x = ar.model(m).map.old.x;
        ar.model(m).data(d).map.new1.x = ar.model(m).map.new1.x;
        ar.model(m).data(d).map.new2.x = ar.model(m).map.new2.x;
    end
    if(~isfield(ar.model(m).data(d).map.old,'u'))
        ar.model(m).data(d).map.old.u = ar.model(m).map.old.u;
        ar.model(m).data(d).map.new1.u = ar.model(m).map.new1.u;
        ar.model(m).data(d).map.new2.u = ar.model(m).map.new2.u;
    end
    mo_or_da = ar.model(m).data(d);
else
    mo_or_da = ar.model(m);
end

iold = find(cellfun(@isempty,regexp(mo_or_da.pcond,[doubleSuffix2,'$'])));  % alles was nicht Suffix2 hat

mo_or_da.map.old.pcond = mo_or_da.pcond(iold);
mo_or_da.map.new1.pcond = strcat(mo_or_da.pcond(iold),doubleSuffix1);
mo_or_da.map.new2.pcond = strcat(mo_or_da.pcond(iold),doubleSuffix2);
mo_or_da.pcond = [mo_or_da.map.new1.pcond;mo_or_da.map.new2.pcond];

% inew1 = find(~cellfun(@isempty,regedp(mo_or_da.p,[doubleSuffix1,'$'])));  % suffix 1 not found
% for i=1:length(inew1)
%     iold = strmatch([regexprep(mo_or_da.p{inew1(i)},[doubleSuffix2,'$'],''),doubleSuffix1],mo_or_da.p,'exact');
%     if(length(iold)~=1)
%         mo_or_da.p{inew1(i)}(1:end-1)
%         error('corresponding primary parameter not found')
%     end
%     mo_or_da.fp{inew1(i)} = char(subs(subs(subs(subs(mo_or_da.fp{iold^},mo_or_da.map.old.p,mo_or_da.map.new2.p), mo_or_da.map.old.x,mo_or_da.map.new2.x), mo_or_da.map.old.u,mo_or_da.map.new2.u), mo_or_da.map.old.pcond,mo_or_da.map.new2.pcond));
%     % is the following necessary (in the Becker example, it seems so)
%     for m2=1:(m-1)
%         tmp = char(subs(subs(mo_or_da.fp{inew1(i)},ar.model(m2).map.old.p,ar.model(m2).map.new2.p),ar.model(m2).map.old.pcond,ar.model(m2).map.new2.pcond));
%         mo_or_da.fp{inew1(i)} = tmp;        
%     end        
% end
% 
% inew2 = find(~cellfun(@isempty,regexp(mo_or_da.p,[doubleSuffix2,'$'])));
% for i=1:length(inew2)
%     iold = strmatch([regexprep(mo_or_da.p{inew2(i)},[doubleSuffix2,'$'],''),doubleSuffix1],mo_or_da.p,'exact');
%     if(length(iold)~=1)
%         mo_or_da.p{inew2(i)}(1:end-1)
%         error('corresponding primary parameter not found')
%     end
%     mo_or_da.fp{inew2(i)} = char(subs(subs(subs(subs(mo_or_da.fp{iold},mo_or_da.map.old.p,mo_or_da.map.new2.p), mo_or_da.map.old.x,mo_or_da.map.new2.x), mo_or_da.map.old.u,mo_or_da.map.new2.u), mo_or_da.map.old.pcond,mo_or_da.map.new2.pcond));
%     % is the following necessary (in the Becker example, it seems so)
%     for m2=1:(m-1)
%         tmp = char(subs(subs(mo_or_da.fp{inew2(i)},ar.model(m2).map.old.p,ar.model(m2).map.new2.p),ar.model(m2).map.old.pcond,ar.model(m2).map.new2.pcond));
%         mo_or_da.fp{inew2(i)} = tmp;        
%     end        
% end

if(~isempty(d))
    ar.model(m).data(d) = mo_or_da;
else
    ar.model(m) = mo_or_da;
end
