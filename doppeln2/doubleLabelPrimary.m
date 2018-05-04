% [iprimary,iref] = doubleLabelPrimary
% 
%   This function searches for parameter names with suffix-pairs specified
%   by doubleSuffix1 and doubleSuffix2 and creates ar.iref, ar.iprimary,
%   ar.isref, ar.isprimary
function varargout = doubleLabelPrimary
global ar

iref = find(~cellfun(@isempty,regexp(ar.pLabel,[doubleSuffix2,'$'])));
if(isempty(iref))
    error('No reference parameters found')
end
iprimary = find(~cellfun(@isempty,regexp(ar.pLabel,[doubleSuffix1,'$'])));

inot = setdiff(setdiff(1:length(ar.p),iref),iprimary);
if ~isempty(inot)
    arPrint(inot)
    error('Some parameters don''t have as suffix indicating primar[y/secondary.');
end


if(length(iprimary)~=length(iref))
    iref
    iprimary
    setdiff(strcat(ar.pLabel(iprimary),'_'),ar.pLabel(iref))
    setdiff(ar.pLabel(iref),strcat(ar.pLabel(iprimary),'_'))
    error('length(iprimary)~=length(iref)')
end

[~,ia,ib] = intersect(regexprep(ar.pLabel(iprimary),[doubleSuffix1,'$'],''),regexprep(ar.pLabel(iref),[doubleSuffix2,'$'],''));
ar.iref = iref(ib);
ar.iprimary = iprimary(ia);

ar.isprimary = false(size(ar.p));
ar.isprimary(ar.iprimary) = true;
ar.isref = false(size(ar.p));
ar.isref(ar.iref) = true;

if nargout>0
    varargout{1} = iprimary;
    varargout{2} = iref;
end
