function doubleFitIndexCorrection

    global ar
    
    if (length(ar.iprimary) > sum(ar.qFit))
        ar.iprimary_correction = zeros(size(ar.qFit,1),sum(ar.qFit));
        pos = find(ar.qFit);
        ptcount = 1;
        for ptin = ar.iprimary
            if (sum(pos == ptin) == 1)
                ar.iprimary_correction(ptcount) = ptin;
                ptcount = ptcount + 1;
            end
        end
        ar.iref_correction = zeros(size(ar.iprimary_correction,1),length(ar.iprimary_correction));
        for ptp=1:length(ar.iprimary_correction)
            for ptr=ar.iref
                if (strcmp(ar.pLabel(ptr),strcat(ar.pLabel(ar.iprimary_correction(ptp)),'_')))
                    ar.iref_correction(ptp) = ptr;
                end
            end
        end
        disp('ar.iprimary_correction and ar.iref_correction were created');
    end