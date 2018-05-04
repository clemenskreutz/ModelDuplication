function ar = doubleReactions(ar,m,ODE_check)

ar.model(m).v = [ar.model(m).v,ar.model(m).v];

ar.model(m).map.old.fv = ar.model(m).fv;
ar.model(m).map.new1.fv = cell(size(ar.model(m).map.old.fv));
ar.model(m).map.new2.fv = cell(size(ar.model(m).map.old.fv));
for i=1:length(ar.model(m).map.old.fv)
%     ar.model(m).map.new1.fv{i} = char(subs(subs(subs(subs(subs(ar.model(m).map.old.fv{i},ar.model(m).map.old.px,ar.model(m).map.new1.px),ar.model(m).map.old.x,ar.model(m).map.new1.x),ar.model(m).map.old.u,ar.model(m).map.new1.u),ar.model(m).map.old.pu, ar.model(m).map.new1.pu),ar.model(m).map.old.pv, ar.model(m).map.new1.pv));
%     ar.model(m).map.new2.fv{i} = char(subs(subs(subs(subs(subs(ar.model(m).map.old.fv{i},ar.model(m).map.old.px,ar.model(m).map.new2.px),ar.model(m).map.old.x,ar.model(m).map.new2.x),ar.model(m).map.old.u,ar.model(m).map.new2.u),ar.model(m).map.old.pu, ar.model(m).map.new2.pu),ar.model(m).map.old.pv, ar.model(m).map.new2.pv));
    ar.model(m).map.new1.fv{i} = doubleOld2New(ar.model(m).map.old.fv{i},[],1);
    ar.model(m).map.new2.fv{i} = doubleOld2New(ar.model(m).map.old.fv{i},[],2);
end
ar.model(m).fv = [ar.model(m).map.new1.fv;ar.model(m).map.new2.fv];

if ODE_check
    ar.model(m).map.old.N = ar.model(m).N(1:size(ar.model(m).N,1),:);
    ar.model(m).map.new1.N = ar.model(m).N(1:size(ar.model(m).N,1),:);
    ar.model(m).map.new2.N = ar.model(m).N(1:size(ar.model(m).N,1),:);
    ar.model(m).N = [ar.model(m).map.new1.N,zeros(size(ar.model(m).map.old.N)); zeros(size(ar.model(m).map.old.N)),ar.model(m).map.new1.N];
else
    ar.model(m).map.old.N = ar.model(m).N(1:size(ar.model(m).N,1)/2,:);
    ar.model(m).map.new1.N = ar.model(m).N(1:size(ar.model(m).N,1)/2,:);
    ar.model(m).map.new2.N = ar.model(m).N(1:size(ar.model(m).N,1)/2,:);
    ar.model(m).N = [ar.model(m).map.new1.N,zeros(size(ar.model(m).map.old.N)); zeros(size(ar.model(m).map.old.N)),ar.model(m).map.new1.N];
end
% 



ar.model(m).map.old.fv_source = ar.model(m).fv_source;
ar.model(m).map.new1.fv_source = cell(size(ar.model(m).map.old.fv_source));
ar.model(m).map.new2.fv_source = cell(size(ar.model(m).map.old.fv_source));
for i=1:length(ar.model(m).map.old.fv_source)
    assym = subs(ar.model(m).fv_source{i}, ar.model(m).map.old.x, ar.model(m).map.new1.x);
    for j=1:length(assym)
        ar.model(m).map.new1.fv_source{i}{j} = char(assym(j));
    end
    assym = subs(ar.model(m).fv_source{i}, ar.model(m).map.old.x, ar.model(m).map.new2.x);
    for j=1:length(assym)
        ar.model(m).map.new2.fv_source{i}{j} = char(assym(j));
    end
end
ar.model(m).fv_source = [ar.model(m).map.new1.fv_source;ar.model(m).map.new2.fv_source];

ar.model(m).map.old.fv_target = ar.model(m).fv_target;
ar.model(m).map.new1.fv_target = cell(size(ar.model(m).map.old.fv_target));
ar.model(m).map.new2.fv_target = cell(size(ar.model(m).map.old.fv_target));
for i=1:length(ar.model(m).map.old.fv_target)
    assym = subs(ar.model(m).fv_target{i}, ar.model(m).map.old.x, ar.model(m).map.new1.x);
    for j=1:length(assym)
        ar.model(m).map.new1.fv_target{i}{j} = char(assym(j));
    end
    assym = subs(ar.model(m).fv_target{i}, ar.model(m).map.old.x, ar.model(m).map.new2.x);
    for j=1:length(assym)
        ar.model(m).map.new2.fv_target{i}{j} = char(assym(j));
    end
end
ar.model(m).fv_target = [ar.model(m).map.new1.fv_target;ar.model(m).map.new2.fv_target];


ar.model(m).fv_ma_reverse_pbasename = [ar.model(m).fv_ma_reverse_pbasename,ar.model(m).fv_ma_reverse_pbasename];

ar.model(m).vUnits = [ar.model(m).vUnits;ar.model(m).vUnits];




% ar.model(m).map.old.pvs = ar.model(m).pvs;
% ar.model(m).map.new1.pvs = cell(size(ar.model(m).map.old.pvs));
% ar.model(m).map.new2.pvs = cell(size(ar.model(m).map.old.pvs));
% for i=1:length(ar.model(m).map.old.pvs)
%     ar.model(m).map.new1.pvs{i} = cell(size(ar.model(m).map.old.pvs{i}));
%     assym = subs(ar.model(m).map.old.pvs{i}, ar.model(m).map.old.x, ar.model(m).map.new1.x);
%     for j=1:length(assym)
%         ar.model(m).map.new1.pvs{i}{j} = char(assym(j));
%     end
%     ar.model(m).map.new2.pvs{i} = cell(size(ar.model(m).map.old.pvs{i}));
%     assym = subs(ar.model(m).map.old.pvs{i}, ar.model(m).map.old.x, ar.model(m).map.new2.x);
%     for j=1:length(assym)
%         ar.model(m).map.new2.pvs{i}{j} = char(assym(j));
%     end
% end
% ar.model(m).pvs = [ar.model(m).map.new1.pvs;ar.model(m).map.new2.pvs];



% %% setting N
% %Einschub Philipp: Für ODE Modelle gibt es einen Fehler, da ar.model.N
% %falsche Dimension hat? ->Zusätzliche N nicht notwendig?
% if ~ODE_check
%     iold = find(cellfun(@isempty,regexp(ar.model(m).x,[doubleSuffix1,'$'])));
%     inew = find(cellfun(@isempty,regexp(ar.model(m).x,[doubleSuffix2,'$'])));
%     
%     ar.model(m).N = [ar.model(m).N(iold,:);ar.model(m).N(iold,:)];  % muss verdoppelt werden
% end

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

