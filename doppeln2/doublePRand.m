function ar = doublePRand(ar)

% for m=1:length(ar.model)
%     for d=1:length(ar.model(m).data)
%         ar.model(m).data(d).map.old.prand = ar.model(m).data(d).prand;
%         ar.model(m).data(d).map.new1.prand = strcat(ar.model(m).data(d).prand,doubleSuffix1);
%         ar.model(m).data(d).map.new2.prand = strcat(ar.model(m).data(d).prand,doubleSuffix2);
%         ar.model(m).data(d).prand = [ar.model(m).data(d).map.new1.prand,ar.model(m).data(d).map.new2.prand];
%         
%         ar.model(m).data(d).map.old.rand_type = ar.model(m).data(d).rand_type;
%         ar.model(m).data(d).map.new1.rand_type = ar.model(m).data(d).rand_type;
%         ar.model(m).data(d).map.new2.rand_type = ar.model(m).data(d).rand_type;
%         ar.model(m).data(d).rand_type = [ar.model(m).data(d).map.new1.rand_type,ar.model(m).data(d).map.new2.rand_type];
%         
%         [~,ia1] = intersect(ar.model(m).data(d).pcond,ar.model(m).data(d).map.new1.pcond);
%         [~,ia2] = intersect(ar.model(m).data(d).pcond,ar.model(m).data(d).map.new2.pcond);
%         for r=1:length(ar.model(m).data(d).map.old.prand)
%             for i=1:length(ia1)
%                 ar.model(m).data(d).pcond(ia1(i)) = strrep(ar.model(m).data(d).pcond(ia1(i)),ar.model(m).data(d).map.old.prand{r},ar.model(m).data(d).map.new1.prand{r});
%             end
%             for i=1:length(ia2)
%                 ar.model(m).data(d).pcond(ia2(i)) = strrep(ar.model(m).data(d).pcond(ia2(i)),ar.model(m).data(d).map.old.prand{r},ar.model(m).data(d).map.new2.prand{r});
%             end
%         end
%     end
% end
