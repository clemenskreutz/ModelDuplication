function [sres,sresFD] = doubleFD(dp,ips)
global ar
if nargin<2
    ips = 1:length(ar.iprimary);
end


in.p = ar.p;

doublePropagate
p = ar.p;
try
    doubleQFit('all');
    arChi2
    
%     g = 2*ar.res*ar.sres;
    sres = ar.sres;
%     sresFD = NaN(size(sres));

    for i=1:length(ips)
        ip = ips(i);
        ar.p = p;
        ar.p(ar.iref(ip)) = ar.p(ar.iref(ip))-dp;
        ar.p(ar.iprimary(ip)) = ar.p(ar.iprimary(ip))+dp;
        arChi2
        [fval,res] = doubleChi2;
        sresFD(:,ip) = (res(1,:)'-res(2,:)')/(2*dp);
    end
catch err
    ar.p = in.p;
    doubleQFit;
    rethrow(err)
end

ar.p = in.p;
doubleQFit;

figure
nx = ceil(sqrt(length(ips)));
ny = ceil(length(ips)/nx);

sresPlot = abs(sres);
sresPlot(sresPlot<1e-10) =NaN;

for i=1:length(ips)
    subplot(nx,ny,i)
    loglog(sresPlot(1:size(sresFD,1),ar.iprimary(ips(i))),  abs(sresFD(1:size(sresFD,1),ips(i))),'.')
    set(gca,'FontSize',5)
    title(strrep(ar.pLabel{ips(i)},'_','\_'),'FontSize',5)
end


