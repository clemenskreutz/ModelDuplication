% This function copies parameter information from primary to reference
% parameters

function doublePropagate
global ar
if(~isfield(ar,'isprimary'))
    doubleLabelPrimary;
end

ar.p(ar.iref)       = ar.p(ar.iprimary);
ar.mean(ar.iref)    = ar.mean(ar.iprimary);
ar.std(ar.iref)     = ar.std(ar.iprimary);
ar.type(ar.iref)    = ar.type(ar.iprimary);
ar.lb(ar.iref)      = ar.lb(ar.iprimary);
ar.ub(ar.iref)      = ar.ub(ar.iprimary);

if isfield(ar,'qFit_reference')
    ar.qFit_reference(ar.iref) = ar.qFit_reference(ar.iprimary);
end