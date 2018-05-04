%   doubleQFit(doprimary)
%
%   the function switches between three states of qFit
%     doprimary==1:         original qFit & isprimary       (false for non-primary)
%     doprimary==0:         original qFit & ~isprimary      (false for primary)
%     isempty(doprimary):   original qFit                   original values as backupped in qFit_reference
%     'all':                all qFit are set to one.        original values as backupped in qFit_reference
%     'both':               original qFit for primary and secondary     original values as backupped in qFit_reference

function doubleQFit(doprimary)
if(~exist('doprimary','var') || isempty(doprimary))
    doprimary = [];  % in this cae
end

global ar
if(~isfield(ar,'isprimary'))
    doubleLabelPrimary;
end

if sum(ar.qFit>1)>0
    error('doubleQFit currently only handels ar.qFit==0 or ar.qFit==1. Changing ar.qFit=2 -> ar.qFit=0 might be a solution.\n In this case, type the following commands:\n ar.qFit(ar.qFit==2) = 0;');
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
    elseif ischar(doprimary) && strcmp(doprimary,'original')==1
        ar.qFit = ar.qFit_reference;
    elseif ischar(doprimary) && strcmp(doprimary,'both')==1
        ar.qFit = ar.qFit_reference & (ar.isprimary | ar.isref);
    elseif(doprimary)
        ar.qFit = ar.qFit_reference & ar.isprimary;
        ar.qFit(~ar.isprimary) = 0;
    elseif ~doprimary
        ar.qFit = ar.qFit_reference & ~ar.isprimary;
        ar.qFit(ar.isprimary) = 0;
    else
        error('case not yet implemented.')
    end
    
    for m=1:length(ar.model)
        for d=1:length(ar.model(m).data)
            if ischar(doprimary) && strcmp(doprimary,'all')==1
                ar.model(m).data(d).qFit(:) = 1;
            elseif ischar(doprimary) && strcmp(doprimary,'original')==1
                ar.model(m).data(d).qFit = ar.model(m).data(d).qFit_reference;
            elseif ischar(doprimary) && strcmp(doprimary,'both')==1
                ar.model(m).data(d).qFit = ar.model(m).data(d).qFit_reference & (~cellfun(@isempty,regexp(ar.model(m).data(d).y,[doubleSuffix1,'$'])) | ~cellfun(@isempty,regexp(ar.model(m).data(d).y,[doubleSuffix2,'$'])));
            elseif(doprimary)
                ar.model(m).data(d).qFit = ar.model(m).data(d).qFit_reference & ~cellfun(@isempty,regexp(ar.model(m).data(d).y,[doubleSuffix1,'$']));
            elseif ~doprimary
                ar.model(m).data(d).qFit = ar.model(m).data(d).qFit_reference & ~cellfun(@isempty,regexp(ar.model(m).data(d).y,[doubleSuffix2,'$']));
            else
                error('case not yet implemented.')
            end
        end
    end
    
end