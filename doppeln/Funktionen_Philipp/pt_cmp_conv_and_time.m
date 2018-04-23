function [conv_and_time , GlobalMin , time] = cmp_conv_and_time(nfits)
    
    GlobalMin = zeros(1,2);
    time = zeros(1,2);
    
    Setup;
    arFitLHS(nfits);
    GlobalMin(1,1) = length(ar.ps(ar.chi2s - min(ar.chi2s) < 0.1));
    time(1,1) = sum(ar.timing(~isnan(ar.timing)));
    
    Setup_double;
    doubleFitInit;
    arFitLHS(nfits);
    GlobalMin(1,2)= length(ar.ps(ar.chi2s - min(ar.chi2s) < 0.1));
    time(1,2)= sum(ar.timing(~isnan(ar.timing)));
    
    conv_and_time = [GlobalMin(1,2) / GlobalMin(1,1) ; time(1,2) / time(1,1)];
end
    
    
    
    