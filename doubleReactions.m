function ar = doubleReactions(ar,m)

ar.model(m).v = [ar.model(m).v,ar.model(m).v];

ar.model(m).map.old.fv = ar.model(m).fv;
ar.model(m).map.new.fv = cell(size(ar.model(m).map.old.fv));
for i=1:length(ar.model(m).map.old.fv)
    ar.model(m).map.new.fv{i} = char(subs(subs(subs(ar.model(m).map.old.fv{i},ar.model(m).map.old.px,ar.model(m).map.new.px),ar.model(m).map.old.x,ar.model(m).map.new.x),ar.model(m).map.old.u,ar.model(m).map.new.u));
end
ar.model(m).fv = [ar.model(m).map.old.fv;ar.model(m).map.new.fv];

ar.model(m).map.old.fv_source = ar.model(m).fv_source;
ar.model(m).map.new.fv_source = cell(size(ar.model(m).map.old.fv_source));
for i=1:length(ar.model(m).map.old.fv_source)
    assym = subs(ar.model(m).fv_source{i}, ar.model(m).map.old.x, ar.model(m).map.new.x);
    for j=1:length(assym)
        ar.model(m).map.new.fv_source{i}{j} = char(assym(j));
    end
end
ar.model(m).fv_source = [ar.model(m).map.old.fv_source;ar.model(m).map.new.fv_source];

ar.model(m).map.old.fv_target = ar.model(m).fv_target;
ar.model(m).map.new.fv_target = cell(size(ar.model(m).map.old.fv_target));
for i=1:length(ar.model(m).map.old.fv_target)
    assym = subs(ar.model(m).fv_target{i}, ar.model(m).map.old.x, ar.model(m).map.new.x);
    for j=1:length(assym)
        ar.model(m).map.new.fv_target{i}{j} = char(assym(j));
    end
end
ar.model(m).fv_target = [ar.model(m).map.old.fv_target;ar.model(m).map.new.fv_target];


ar.model(m).fv_ma_reverse_pbasename = [ar.model(m).fv_ma_reverse_pbasename,ar.model(m).fv_ma_reverse_pbasename];

ar.model(m).vUnits = [ar.model(m).vUnits;ar.model(m).vUnits];




ar.model(m).map.old.pvs = ar.model(m).pvs;
ar.model(m).map.new.pvs = cell(size(ar.model(m).map.old.pvs));
for i=1:length(ar.model(m).map.old.pvs)
    ar.model(m).map.new.pvs{i} = cell(size(ar.model(m).map.old.pvs{i}));
    assym = subs(ar.model(m).map.old.pvs{i}, ar.model(m).map.old.x, ar.model(m).map.new.x);
    for j=1:length(assym)
        ar.model(m).map.new.pvs{i}{j} = char(assym(j));
    end
end
ar.model(m).pvs = [ar.model(m).map.old.pvs;ar.model(m).map.new.pvs];



ar.model(m).map.old.pv = ar.model(m).pv;
ar.model(m).map.new.pv = cell(size(ar.model(m).map.old.pv));
for i=1:length(ar.model(m).map.old.pv)
    ar.model(m).map.new.pv{i} = strcat(ar.model(m).map.old.pv{i},'_');
end
ar.model(m).pv = [ar.model(m).map.old.pv;ar.model(m).map.new.pv];



%% setting N
iold = find(cellfun(@isempty,regexp(ar.model(m).x,'_$')));
inew = setdiff(1:length(ar.model(m).x),iold);
ar.model(m).N = [ar.model(m).N,[ar.model(m).N(inew,:);ar.model(m).N(iold,:)]];

% ar.model(m).N = zeros(length(ar.model(m).x),length(ar.model(m).fv));
% for vcount = 1:length(ar.model(m).fv)
%     for jj=1:length(ar.model(m).fv_source)
%         for j=find(ismember(ar.model(m).x, ar.model(m).fv_source{jj})) %R2013a compatible
%             ar.model(m).N(j, vcount) = ar.model(m).N(j, vcount) + 1;
%         end
%     end
% 
%     for jj=1:length(ar.model(m).fv_target)
%         for j=find(ismember(ar.model(m).x, ar.model(m).fv_target{jj})) %R2013a compatible
%             ar.model(m).N(j, vcount) = ar.model(m).N(j, vcount) - 1;
%         end
%     end
% end

