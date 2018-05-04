% ar = doubleObservablesData(ar,m,d)
%
%   Duplication of fielsd in ar.model.data belinging to the observables
%   section in arLoadData

function ar = doubleObservablesData(ar,m,d)

iadd = find(cellfun(@isempty,regexp(ar.model(m).data(d).y,[doubleSuffix1,'$'])) ...
    & cellfun(@isempty,regexp(ar.model(m).data(d).y,[doubleSuffix2,'$'])));  % Suffix1 and Suffix2 not found

% [~,iold] = intersect(regexprep(ar.model(m).data(d).y,[doubleSuffix1,'$'],''),ar.model(m).data(d).map.old.y);

model_map = ar.model(m).map;
if ~isfield(model_map.old,'y') % no observables in the model def
    model_map.old.y = cell(0);
    model_map.new1.y = cell(0);
    model_map.new2.y = cell(0);
    
    model_map.old.fy = cell(0);
    model_map.new1.fy = cell(0);
    model_map.new2.fy = cell(0);
    
    model_map.old.fystd = cell(0);
    model_map.new1.fystd = cell(0);
    model_map.new2.fystd = cell(0);
    
    model_map.old.yNames = cell(0);
    model_map.new1.yNames = cell(0);
    model_map.new2.yNames = cell(0);
    
    model_map.old.py_sep = cell(0);
    model_map.new1.py_sep = cell(0);
    model_map.new2.py_sep = cell(0);
elseif ~isfield(model_map.old,'py_sep')
    model_map.old.py_sep = cell(0);
    model_map.new1.py_sep = cell(0);
    model_map.new2.py_sep = cell(0);
end

ar.model(m).data(d).map.old.y = [model_map.old.y,ar.model(m).data(d).y(iadd)];
ar.model(m).data(d).map.new1.y = [model_map.new1.y,strcat(ar.model(m).data(d).y(iadd),doubleSuffix1)];
ar.model(m).data(d).map.new2.y = [model_map.new2.y,strcat(ar.model(m).data(d).y(iadd),doubleSuffix2)];
ar.model(m).data(d).y = [ar.model(m).data(d).map.new1.y,ar.model(m).data(d).map.new2.y];

ar.model(m).data(d).map.old.yNames = [model_map.old.yNames,ar.model(m).data(d).yNames(iadd)];
ar.model(m).data(d).map.new1.yNames = [model_map.new1.yNames,strcat(ar.model(m).data(d).yNames(iadd),doubleSuffix1)];
ar.model(m).data(d).map.new2.yNames = [model_map.new2.yNames,strcat(ar.model(m).data(d).yNames(iadd),doubleSuffix2)];
ar.model(m).data(d).yNames = [ar.model(m).data(d).map.new1.yNames,ar.model(m).data(d).map.new2.yNames];

ar.model(m).data(d).yUnits = [ar.model(m).data(d).yUnits; ar.model(m).data(d).yUnits(iadd,:);ar.model(m).data(d).yUnits(iadd,:)];
ar.model(m).data(d).normalize = [ar.model(m).data(d).normalize, ar.model(m).data(d).normalize(iadd),ar.model(m).data(d).normalize(iadd)];
ar.model(m).data(d).logfitting = [ar.model(m).data(d).logfitting, ar.model(m).data(d).logfitting(iadd),ar.model(m).data(d).logfitting(iadd)];
ar.model(m).data(d).logplotting = [ar.model(m).data(d).logplotting, ar.model(m).data(d).logplotting(iadd),ar.model(m).data(d).logplotting(iadd)];

ar.model(m).data(d).map.old.fy = [model_map.old.fy,ar.model(m).data(d).fy(iadd)];
ar.model(m).data(d).map.new1.fy = [model_map.new1.fy,cell(size(ar.model(m).data(d).fy(iadd)))];
ar.model(m).data(d).map.new2.fy = [model_map.new2.fy,cell(size(ar.model(m).data(d).fy(iadd)))];
for i=length(model_map.old.fy)+1:length(ar.model(m).data(d).map.old.fy)
    %     ar.model(m).data(d).map.new1.fy{i} = doubleOld2New(ar.model(m).data(d).map.old.fy{i},[],1);
    %     ar.model(m).data(d).map.new2.fy{i} = doubleOld2New(ar.model(m).data(d).map.old.fy{i},[],2);
    ar.model(m).data(d).map.new1.fy{i} = char(subs(subs(subs(subs(ar.model(m).data(d).map.old.fy{i},model_map.old.x,model_map.new1.x),ar.model(m).data(d).map.old.py,ar.model(m).data(d).map.new1.py),model_map.old.z,model_map.new1.z),model_map.old.u,model_map.new1.u));
    ar.model(m).data(d).map.new2.fy{i} = char(subs(subs(subs(subs(ar.model(m).data(d).map.old.fy{i},model_map.old.x,model_map.new2.x),ar.model(m).data(d).map.old.py,ar.model(m).data(d).map.new2.py),model_map.old.z,model_map.new2.z),model_map.old.u,model_map.new2.u));
end
ar.model(m).data(d).fy = [ar.model(m).data(d).map.new1.fy; ar.model(m).data(d).map.new2.fy];

% ar.model(m).data(d).map.old.fu = ar.model(m).data(d).fu;
% ar.model(m).data(d).map.new1.fu = cell(size(ar.model(m).data(d).fu));
% ar.model(m).data(d).map.new2.fu = cell(size(ar.model(m).data(d).fu));
% for i=1:length(ar.model(m).data(d).map.old.fu)
%     ar.model(m).data(d).map.new1.fu{i} = char(subs(subs(subs(subs(subs(ar.model(m).data(d).map.old.fu{i},model_map.old.x,model_map.new1.x),ar.model(m).data(d).map.old.py,ar.model(m).data(d).map.new1.py),model_map.old.z,model_map.new1.z),model_map.old.u,model_map.new1.u),model_map.old.pu,model_map.new1.pu));
%     ar.model(m).data(d).map.new2.fu{i} = char(subs(subs(subs(subs(subs(ar.model(m).data(d).map.old.fu{i},model_map.old.x,model_map.new2.x),ar.model(m).data(d).map.old.py,ar.model(m).data(d).map.new2.py),model_map.old.z,model_map.new2.z),model_map.old.u,model_map.new2.u),model_map.old.pu,model_map.new2.pu));
% end
% ar.model(m).data(d).fu = [ar.model(m).data(d).map.new1.fu; ar.model(m).data(d).map.new2.fu];

if size(ar.model(m).data(d).fystd(iadd),1)==1
    ar.model(m).data(d).fystd = ar.model(m).data(d).fystd'; % make column
end

ar.model(m).data(d).map.old.fystd = [model_map.old.fystd;ar.model(m).data(d).fystd(iadd)];
ar.model(m).data(d).map.new1.fystd = [model_map.new1.fystd;cell(size(ar.model(m).data(d).fystd(iadd)))];
ar.model(m).data(d).map.new2.fystd = [model_map.new2.fystd;cell(size(ar.model(m).data(d).fystd(iadd)))];
for i=length(model_map.old.fystd)+1:length(ar.model(m).data(d).map.old.fystd)
    ar.model(m).data(d).map.new1.fystd{i} = char(subs(subs(subs(ar.model(m).data(d).map.old.fystd{i}, model_map.old.x,model_map.new1.x),  ar.model(m).data(d).map.old.py,ar.model(m).data(d).map.new1.py),   ar.model(m).data(d).map.old.y,ar.model(m).data(d).map.new1.y) );
    ar.model(m).data(d).map.new2.fystd{i} = char(subs(subs(subs(ar.model(m).data(d).map.old.fystd{i}, model_map.old.x,model_map.new2.x),  ar.model(m).data(d).map.old.py,ar.model(m).data(d).map.new2.py),   ar.model(m).data(d).map.old.y,ar.model(m).data(d).map.new2.y) );
    
    if isfield(ar.model(m).data(d).map.old,'pystd')
        ar.model(m).data(d).map.new1.fystd{i} = char(subs(ar.model(m).data(d).map.old.fystd{i},  ar.model(m).data(d).map.old.pystd,ar.model(m).data(d).map.new1.pystd) );
        ar.model(m).data(d).map.new2.fystd{i} = char(subs(ar.model(m).data(d).map.old.fystd{i},  ar.model(m).data(d).map.old.pystd,ar.model(m).data(d).map.new2.pystd) );
    else
        ar.model(m).data(d).map.new1.fystd{i} = char(subs(ar.model(m).data(d).map.old.fystd{i},  ar.model(m).data(d).pystd, strcat(ar.model(m).data(d).pystd,doubleSuffix1) ));
        ar.model(m).data(d).map.new2.fystd{i} = char(subs(ar.model(m).data(d).map.old.fystd{i},  ar.model(m).data(d).pystd, strcat(ar.model(m).data(d).pystd,doubleSuffix2) ));
    end
end
ar.model(m).data(d).fystd = [ar.model(m).data(d).map.new1.fystd; ar.model(m).data(d).map.new2.fystd];


if isempty(model_map.old.py_sep)
    ar.model(m).data(d).map.old.py_sep  = ar.model(m).data(d).py_sep(iadd);
    ar.model(m).data(d).map.new1.py_sep = ar.model(m).data(d).py_sep(iadd);
    ar.model(m).data(d).map.new2.py_sep = ar.model(m).data(d).py_sep(iadd);
else
    ar.model(m).data(d).map.old.py_sep  = [model_map.old.py_sep, ar.model(m).data(d).py_sep(iadd)];
    ar.model(m).data(d).map.new1.py_sep = [model_map.new1.py_sep, ar.model(m).data(d).py_sep(iadd)];
    ar.model(m).data(d).map.new2.py_sep = [model_map.new2.py_sep, ar.model(m).data(d).py_sep(iadd)];
end
for i=length(model_map.old.py_sep)+1:length(ar.model(m).data(d).map.old.py_sep)
    for j=1:length(ar.model(m).data(d).map.new1.py_sep(i).pars)
        ar.model(m).data(d).map.new1.py_sep(i).pars{j} = char(subs(subs(subs(ar.model(m).data(d).map.old.py_sep(i).pars{j}, model_map.old.x,model_map.new1.x),  ar.model(m).data(d).map.old.py,ar.model(m).data(d).map.new1.py),   ar.model(m).data(d).map.old.y,ar.model(m).data(d).map.new1.y) );
        ar.model(m).data(d).map.new2.py_sep(i).pars{j} = char(subs(subs(subs(ar.model(m).data(d).map.old.py_sep(i).pars{j}, model_map.old.x,model_map.new2.x),  ar.model(m).data(d).map.old.py,ar.model(m).data(d).map.new2.py),   ar.model(m).data(d).map.old.y,ar.model(m).data(d).map.new2.y) );
        
        if isfield(ar.model(m).data(d).map.old,'pystd')
            ar.model(m).data(d).map.new1.py_sep(i).pars{j} = char(subs(ar.model(m).data(d).map.old.py_sep(i).pars{j},  ar.model(m).data(d).map.old.pystd,ar.model(m).data(d).map.new1.pystd) );
            ar.model(m).data(d).map.new2.py_sep(i).pars{j} = char(subs(ar.model(m).data(d).map.old.py_sep(i).pars{j},  ar.model(m).data(d).map.old.pystd,ar.model(m).data(d).map.new2.pystd) );
        end
    end
    %     ar.model(m).data(d).map.new1.py_sep{i} = doubleOld2New(ar.model(m).data(d).map.old.py_sep{i}, [],1);
    %     ar.model(m).data(d).map.new2.py_sep{i} = doubleOld2New(ar.model(m).data(d).map.old.py_sep{i}, [],2);
end
ar.model(m).data(d).py_sep = [ar.model(m).data(d).map.new1.py_sep,ar.model(m).data(d).map.new2.py_sep];

