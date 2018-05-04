% This function prepares everything for fitting by model duplication

function doubleFitInit

global ar

if(~isfield(ar,'isprimary'))
    doubleLabelPrimary;
end

%% set introduce useDouble
if(isfield(ar.config,'useDouble'))
    if ar.config.useDouble ~=1
        warning('ar.config.useDouble ~=1')
    end
else
    ar.config.useDouble = 1;
    disp('ar.config.useDouble is set to 1.');
end

%% switch off error correction (dependent on the number of parameters)
ar.config.useFitErrorCorrection = 0;

%% remember last p
ar.plast = ar.p;

%% remember original qFit
ar.qFit_reference = ar.qFit;
for m=1:length(ar.model)
    for d=1:length(ar.model(m).data)
        if ~isfield(ar.model(m).data(d),'qFit_reference')
            ar.model(m).data(d).qFit_reference = ar.model(m).data(d).qFit;
        end
    end
end

%% set non-primary qFit to zero
doubleQFit(1);

%% the reference parameters are overwritten by the primary ones
doublePropagate

