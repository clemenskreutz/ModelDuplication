% The image should look "symmetric", i.e. the same patterns should be
% visible (for different residuals).
% 

function doubleCheck_Sres_Image(thresh)
if ~exist('thresh','var') || isempty(thresh)
    thresh = 1e-8;
end

global ar

doubleLabelPrimary

if sum(abs(ar.p(ar.iprimary) - ar.p(ar.iref)))>1e-10
    warning('Execution of doublePropagate is recommended for this check.')
end

close all

arCalcMerit(true)

figure
subplot(1,2,1)
imagesc(abs(ar.sres(:,ar.iprimary))>thresh)
title('sres(:,ar.iprimary)');
ylabel('residuals')
xlabel('primary parameters')
subplot(1,2,2)
imagesc(abs(ar.sres(:,ar.iref))>thresh)
title('sres(:,ar.iref)');
xlabel('secondary parameters')
