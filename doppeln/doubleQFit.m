%   doubleQFit(doprimary)
% 
%   the function switches between three states of qFit
%     doprimary==1:         original qFit & isprimary       (false for non-primary)
%     doprimary==0:         original qFit & ~isprimary      (false for primary)
%     isempty(doprimary):   original qFit                   original values as backupped in qFit_reference
%     'all':                all qFit are set to one.        original values as backupped in qFit_reference

function doubleQFit(doprimary)
if(~exist('doprimary','var') || isempty(doprimary))
    doprimary = [];  % in this cae
end

global ar
if(~isfield(ar,'isprimary'))
    doubleLabelPrimary;
end


if(isempty(doprimary))
    if(~isfield(ar,'qFit_reference'))
        return % no need
    else
        ar.qFit = ar.qFit_reference;
        for m=1:length(ar.model)
            for d=1:length(ar.model(m).data)
                if ~isfield(ar.model(m).data(d),'qFit_reference') || isempty(ar.model(m).data(d).qFit_reference)
                    ar.model(m).data(d).qFit = ar.model(m).data(d).qFit_reference;
                end
            end
        end
    end
else    
    
    %% set backup fields: qFit_reference
    if(~isfield(ar,'qFit_reference'))
        ar.qFit_reference = ar.qFit;
    end
    for m=1:length(ar.model)
        for d=1:length(ar.model(m).data)
            if ~isfield(ar.model(m).data(d),'qFit_reference') || isempty(ar.model(m).data(d).qFit_reference)
                ar.model(m).data(d).qFit_reference = ar.model(m).data(d).qFit;
            end
        end
    end

    if ischar(doprimary) && strcmp(doprimary,'all')==1
        ar.qFit(:)=1;    
    elseif(doprimary)
        ar.qFit = ar.qFit_reference & ar.isprimary;
        ar.qFit(~ar.isprimary) = 0;
    else
        ar.qFit = ar.qFit_reference & ~ar.isprimary;
        ar.qFit(ar.isprimary) = 0;
    end
    
    for m=1:length(ar.model)
        for d=1:length(ar.model(m).data)
            if ischar(doprimary) && strcmp(doprimary,'all')==1
                ar.model(m).data(d).qFit(:) = 1;
            elseif(doprimary)
                ar.model(m).data(d).qFit = ar.model(m).data(d).qFit_reference & cellfun(@isempty,regexp(ar.model(m).data(d).y,'_$'));
            else
                ar.model(m).data(d).qFit = ar.model(m).data(d).qFit_reference & ~cellfun(@isempty,regexp(ar.model(m).data(d).y,'_$'));
            end
        end
    end
     
end