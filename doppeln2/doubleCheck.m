% [ar1,ar2]=doubleCheck
%
function varargout = doubleCheck

global ar

if(~isfield(ar,'iprimary'))
    doubleLabelPrimary
end


if length(ar.iprimary)~=length(ar.iref)
    warning('length(ar.iprimary)~=length(ar.iref)');
end

inot = setdiff(setdiff(1:length(ar.p),ar.iprimary),ar.iref);
if ~isempty(inot)
    arPrint(inot)
    warning('Some parameters are neither primary nor reference/secondary.');
end

try
    in.p = ar.p;
    in.mean = ar.mean;
    in.std = ar.std;
    in.type = ar.type;
    
    dp = rand(size(ar.p))-.5;
    
    ar.p = ar.p+dp;
    
    doubleQFit('all')
    arCalcMerit(true)
    depOnBoth = sum(abs(ar.sres(:,ar.iprimary) >1e-8 & ar.sres(:,ar.iref) >1e-8 ));
    if(sum(depOnBoth>0)>0)
        depOnBoth
        arPrint(find(depOnBoth>0))
        
        fprintf('!\n! There seems to be residuals which are sensitive to both, primary and reference parameters. !\n!\n')
        fprintf('  -> Check with arPlotMulti')
        resok = false;
    else
        resok = true;
    end
    
    fvals1 = doubleChi2;
    ar1 = arDeepCopy(ar);
    
    ptmp = ar.p +0.0;
    ar.p(ar.iprimary) = ptmp(ar.iref);
    ar.p(ar.iref) = ptmp(ar.iprimary);
    ar.mean(ar.iprimary) = in.mean(ar.iref);
    ar.mean(ar.iref)     = in.mean(ar.iprimary);
    ar.std(ar.iprimary)  = in.std(ar.iref);
    ar.std(ar.iref)      = in.std(ar.iprimary);
    ar.type(ar.iprimary) = in.type(ar.iref);
    ar.type(ar.iref)     = in.type(ar.iprimary);
    arCalcMerit(true)
    fvals2 = doubleChi2;
    
    fvals1
    fvals2
    if(sum(abs(fvals1-fvals2(end:-1:1))<1e-8) && resok)
        fprintf('\n doubleCheck passed successfully.\n\n')
    end
    ar2 = ar;%arDeepCopy(ar);
    
    ar.p = in.p;
    ar.mean = in.mean;
    ar.std = in.std;
    ar.type = in.type;
catch  err
    ar.p = in.p;
    ar.mean = in.mean;
    ar.std = in.std;
    ar.type = in.type;
    rethrow(err)
end



if nargout>0
    varargout{1} = ar1;
    varargout{2} = ar2;
end
