% [iprimary,iref] = doubleLabelPrimary
function varargout = doubleLabelPrimary
global ar

iref = find(~cellfun(@isempty,regexp(ar.pLabel,'_$')));
if(isempty(iref))
    error('No reference parameters found')
end
iprimary = setdiff(1:length(ar.p),iref);
if(length(iprimary)~=length(iref))
    iref
    iprimary
    setdiff(strcat(ar.pLabel(iprimary),'_'),ar.pLabel(iref))
    setdiff(ar.pLabel(iref),strcat(ar.pLabel(iprimary),'_'))
    error('length(iprimary)~=length(iref)')
end

[~,ia,ib] = intersect(strcat(ar.pLabel(iprimary),'_'),ar.pLabel(iref));
ar.iref = iref(ib);
ar.iprimary = iprimary(ia);

ar.isprimary = false(size(ar.p));
ar.isprimary(iprimary) = true;

if nargout>0
    varargout{1} = iprimary;
    varargout{2} = iref;
end
