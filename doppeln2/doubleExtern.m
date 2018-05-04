function ar = doubleExtern(ar)

fields = {'pExtern','qFitExtern','qLog10Extern','lbExtern','ubExtern'};
ar.map.old.pExternLabels = strcat(ar.pExternLabels,doubleSuffix1);
ar.map.new.pExternLabels = strcat(ar.pExternLabels,doubleSuffix2);

for f=1:length(fields)
    ar.(fields{f}) = [ar.(fields{f}),ar.(fields{f})];
end
