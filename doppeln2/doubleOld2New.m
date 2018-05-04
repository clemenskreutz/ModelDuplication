% val = doubleOld2New(val,map,new1or2,fields)
%
%   This function replaces old naming (before doubbling) with new names
%   (after adding suffix1 or suffix2).
%
% Example:
% ar.model(m).fp = doubleOld2New(ar.model(m).fp,ar.model(m).map,1,{'px','pu','pv','px0'})
function val = doubleOld2New(val,map,new1or2,fields,ignore)
if ~exist('map','var') || isempty(map)
    map = [];
end
if(~exist('ignore','var') || isempty(ignore))
    ignore = cell(0);
end


if new1or2 ==1
    suffix = doubleSuffix1;
elseif new1or2 ==2
    suffix = doubleSuffix2;
end

if ~isempty(map)
    if new1or2 ==1
        new = map.new1;
    elseif new1or2 ==2
        new = map.new2;
    else
        error('new1or2 has to be 1 or 2.')
    end
end

if ~exist('fields','var') || isempty(fields)
    fields = cell(0);
else
    fields = intersect(fields,fieldnames(map.old));
end

if iscell(val)
    for i=1:length(val)
        val{i} = doubleOld2New(val{i},map,new1or2,fields,ignore);
    end
    
elseif ischar(val)
    
    if isempty(fields)
        s = sym(val);
        svars = symvar(s);
        for i=1:length(svars)
            if isempty(intersect(char(svars(i)),ignore))            
                s = arSubs(s,svars(i),sym([char(svars(i)),suffix]));
            end
        end
        val = char(s);
    else
        for f=1:length(fields)
            s = sym(val);
            for i=1:length(map.old.(fields{f}))
                if isempty(intersect(map.old.(fields{f}){i},ignore))
                    s = arSubs(s,sym(map.old.(fields{f}){i}),sym(new.(fields{f}){i}));
                end
            end
            val = char(s);
        end
    end
    
else
    val
    class(val)
    error('type not implemented')
end

