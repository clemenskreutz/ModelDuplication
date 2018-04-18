% [fval,res] = doubleChi2
% 
%   This function evaluates the objective fucntion (corresponding to arChi2
%   or arCalcMerit) for the primary/reference parameters individually.
% 
% 
% fval(1)  for the primary parameters
% fval(2)  for the secondary ones
% 

function [fval,res] = doubleChi2

global ar

doSimu = false;
fval = NaN(1,2);

if(~isfield(ar,'isprimary'))
    doubleLabelPrimary;
end

qFitIn = ar.qFit;

doubleQFit(false)
% arChi2([],[],[],doSimu)
% arChi2([],ar.p(ar.qFit==1),[],doSimu)
arCalcMerit([],ar.p(ar.qFit==1),[],doSimu)
res = ar.res;
fval(2) = sum(ar.res.^2);

doubleQFit(true)
% arChi2([],[],[],doSimu)
% arChi2([],ar.p(ar.qFit==1),[],doSimu)
arCalcMerit([],ar.p(ar.qFit==1),[],doSimu)
res(2,:) = ar.res;
fval(1) = sum(ar.res.^2);

% [fval,diff(fval)]

ar.qFit = qFitIn;

