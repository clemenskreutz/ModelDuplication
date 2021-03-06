% Load Model definition to next free index position
% 
% arLoadModel(name)
%
% name      filename of model definition file
%
% Copyright Andreas Raue 2011 (andreas.raue@fdm.uni-freiburg.de)

function arLoadModel_Double(name, m)

global ar

if(isempty(ar))
    error('please initialize by arInit')
end 

disp('  arLoadModel_Double Version 2 started ...');

% load model from mat-file
if(~exist('Models','dir'))
    error('folder Models/ does not exist')
end
if(~exist(['Models/' name '.def'],'file'))
    error('model definition file %s.def does not exist in folder Models/', name)
end

if(~exist('m','var'))
    if(isfield(ar, 'model'))
        m = length(ar.model) + 1;
    else
        m = 1;
    end
else
    error(['Usage arLoadModel(name, m) is deprecated. Please use arLoadModel(name) ' ...
        'and note that the model will be loaded to the next free index position by default.']);
end

fprintf('loading model #%i, from file Models/%s.def...\n', m, name);
fid = fopen(['Models/' name '.def'], 'r');

% initial setup
ar.model(m).name = name;

% DESCRIPTION
str = textscan(fid, '%s', 1, 'CommentStyle', ar.config.comment_string);
if(isempty(strfind(str{1},'DESCRIPTION')))
    error('parsing model %s for DESCRIPTION', ar.model(m).name);
end

% check version
if(strcmp(str{1},'DESCRIPTION'))
    % def_version = 1;
elseif(strcmp(str{1},'DESCRIPTION-V2'))
    error('DESCRIPTION-V2 not supported yet');
else
    error('invalid version identifier: %s', cell2mat(str{1}));
end

% read comments
str = textscan(fid, '%q', 1, 'CommentStyle', ar.config.comment_string);
ar.model(m).description = {};
while(~strcmp(str{1},'PREDICTOR'))
    ar.model(m).description(end+1,1) = str{1};
    str = textscan(fid, '%q', 1, 'CommentStyle', ar.config.comment_string);
end

% PREDICTOR
C = textscan(fid, '%s %q %q %q %n %n\n',1, 'CommentStyle', ar.config.comment_string);
ar.model(m).t = cell2mat(C{1});
ar.model(m).tUnits(1) = C{2};
ar.model(m).tUnits(2) = C{3};
ar.model(m).tUnits(3) = C{4};
ar.model(m).tLim = [C{5} C{6}];
if(isnan(ar.model(m).tLim(1)))
    ar.model(m).tLim(1) = 0;
end
if(isnan(ar.model(m).tLim(2)))
    ar.model(m).tLim(2) = 10;
end


% COMPARTMENTS
ar.model(m).c = {};
ar.model(m).cUnits = {};
ar.model(m).pc = {};
ar.model(m).px = {};
C = textscan(fid, '%s %q %q %q %f\n',1, 'CommentStyle', ar.config.comment_string);
while(~strcmp(C{1},'STATES'))
    if(~strcmp(C{1},'COMPARTMENTS'))
        ar.model(m).c(end+1) = C{1};
        ar.model(m).cUnits(end+1,1) = C{2};
        ar.model(m).cUnits(end,2) = C{3};
        ar.model(m).cUnits(end,3) = C{4};
        if(isnan(C{5}))
            ar.model(m).px(end+1) = {['vol_' cell2mat(C{1})]};
            ar.model(m).pc(end+1) = {['vol_' cell2mat(C{1})]};
        else
            ar.model(m).pc(end+1) = {num2str(C{5})};
        end
    end
    C = textscan(fid, '%s %q %q %q %f\n',1, 'CommentStyle', ar.config.comment_string);
end

% STATES
% ck: alle States verdoppeln, Namen ver�ndern
ar.model(m).px0 = {};
ar.model(m).x = {};
ar.model(m).xNames = {};
ar.model(m).xUnits = {};
ar.model(m).cLink = [];
ar.model(m).qPlotX = [];
ar.model(m).qPositiveX = [];
C = textscan(fid, '%s %q %q %q %s %n %q %n\n',1, 'CommentStyle', ar.config.comment_string);
while(~strcmp(C{1},'INPUTS'))
    if ( strcmp( C{1}, 'REACTIONS' ) )
        error( 'Missing field INPUTS. This section should be specified after STATES and before REACTIONS. See: "Setting up models"' );
    end    
    
    if(length(cell2mat(C{1}))<2)
        error('STATE names need to be longer than 1');
    end
    if(isempty(symvar(sym(C{1}))))
        error('STATE name ''%s'' is reserved by MATLAB. Please rename!',cell2mat(C{1}));
    end
    ar.model(m).x(end+1) = C{1};
    ar.model(m).xUnits(end+1,1) = C{2};
    ar.model(m).xUnits(end,2) = C{3};
    ar.model(m).xUnits(end,3) = C{4};
    if(~isempty(ar.model(m).c))
        qcomp = ismember(ar.model(m).c, C{5}); %R2013a compatible
        if(sum(qcomp)~=1)
            error('unknown compartement %s', cell2mat(C{5}));
        end
        ar.model(m).cLink(end+1) = find(qcomp);
    end
    if(isempty(C{6}) || isnan(C{6}))
        ar.model(m).qPlotX(end+1) = 1;
    else
        ar.model(m).qPlotX(end+1) = C{6};
    end
    if(~isempty(cell2mat(C{7})))
        ar.model(m).xNames(end+1) = C{7};
    else
        ar.model(m).xNames{end+1} = ar.model(m).x{end};
    end
    if(isempty(C{8}) || isnan(C{8}))
        ar.model(m).qPositiveX(end+1) = 1;
    else
        ar.model(m).qPositiveX(end+1) = C{8};
    end
    ar.model(m).px0(end+1) = {['init_' cell2mat(C{1})]};
    C = textscan(fid, '%s %q %q %q %s %n %q %n\n',1, 'CommentStyle', ar.config.comment_string);
end

ar = doubleCompartments(ar,m);
ar = doubleStates(ar,m);

% INPUTS
% ck: Inputs k�nnen von p abh�ngen, darum auch alle Inputs verdoppeln, Namen ver�ndern
ar.model(m).u = {};
ar.model(m).uUnits = {};
ar.model(m).fu = {};
C = textscan(fid, '%s %q %q %q %q\n',1, 'CommentStyle', ar.config.comment_string);
while(~strcmp(C{1},'REACTIONS') && ~strcmp(C{1},'REACTIONS-AMOUNTBASED') && ~strcmp(C{1},'ODES'))
    if(~strcmp(C{1},''))
        if(sum(ismember(ar.model(m).x, [cell2mat(C{1}),doubleSuffix1]))>0) %R2013a compatible
            error('input %s already defined in STATES', cell2mat(C{1}));
        end
        ar.model(m).u(end+1) = C{1};
        ar.model(m).uUnits(end+1,1) = C{2};
        ar.model(m).uUnits(end,2) = C{3};
        ar.model(m).uUnits(end,3) = C{4};
        ar.model(m).fu(end+1,1) = C{5};
    end
    C = textscan(fid, '%s %q %q %q %q\n',1, 'CommentStyle', ar.config.comment_string);
end
ar.model(m).qPlotU = ones(size(ar.model(m).u));


% input parameters
varlist = cellfun(@symvar, ar.model(m).fu, 'UniformOutput', false);
ar.model(m).pu = setdiff(vertcat(varlist{:}), {ar.model(m).t, ''}); %R2013a compatible

ar = doubleInputs(ar,m);

% REACTIONS (or ODES)
% ck: in den Reaktionen die Namen der Parameter und Zust�nde �ndern, 
% LHS auf die verdoppelten Zustaende mappen, variablen source und target

ar.model(m).N = [];
ar.model(m).v = {};
ar.model(m).fv = {};
ar.model(m).fv_source = {};
ar.model(m).fv_target = {};
ar.model(m).fv_ma_reverse_pbasename = {};
ar.model(m).vUnits = {};
%Einschub Philipp
ODE_check = 0;
if(strcmp(C{1},'REACTIONS') || strcmp(C{1},'REACTIONS-AMOUNTBASED'))
    ar.model(m).isReactionBased = true;
    if(strcmp(C{1},'REACTIONS-AMOUNTBASED'))
        ar.model(m).isAmountBased = true;
    else
        ar.model(m).isAmountBased = false;
    end
    vcount = 1;
    str = textscan(fid, '%s',1, 'CommentStyle', ar.config.comment_string);
    while(~strcmp(str{1},'INVARIANTS') && ~strcmp(str{1},'DERIVED'))
        source = {};

        if ( strcmp(str{1}, 'OBSERVABLES') || strcmp(str{1}, 'CONDITIONS') )
            error('Missing field DERIVED. This section should be specified after REACTIONS and before OBSERVABLES / CONDITIONS. See: "Setting up models paragraph 1.7"');
        end
        while(~strcmp(str{1},'->') && ~strcmp(str{1},'<->'))
            if(~strcmp(str{1},'0') && ~strcmp(str{1},'+'))
                source(end+1) = str{1}; %#ok<AGROW>
            end
            str = textscan(fid, '%s',1, 'CommentStyle', ar.config.comment_string);
        end
        if(sum(~ismember(source, ar.model(m).map.old.x)) > 0) %R2013a compatible
            error('undefined source species in reaction %i: %s', vcount, ...
                source{~ismember(source, ar.model(m).x)}) %R2013a compatible
        end
        
        if(strcmp(str{1},'<->'))
            reversible = true;
        else
            reversible = false;
        end
        
        target = {};
        str = textscan(fid, '%s',1, 'CommentStyle', ar.config.comment_string);
        while(~strcmp(str{1},'CUSTOM') && ~strcmp(str{1},'MASSACTION') && ~strcmp(str{1},'MASSACTIONKD'))
            if(~strcmp(str{1},'0') && ~strcmp(str{1},'+'))
                target(end+1) = str{1}; %#ok<AGROW>
            end
            str = textscan(fid, '%s',1, 'CommentStyle', ar.config.comment_string);
        end
        if(sum(~ismember(target, ar.model(m).map.old.x)) > 0) %R2013a compatible
            error('undefined target species in reaction %i: %s', vcount, ...
                target{~ismember(target, ar.model(m).x)}) %R2013a compatible
        end
        
        % infer flux units
        if(~isempty(source))
            ix = find(ismember(ar.model(m).map.old.x, source{1})); %R2013a compatible
        elseif(~isempty(target))
            ix = find(ismember(ar.model(m).map.old.x, target{1})); %R2013a compatible
        else
            error('reaction with empty N');
        end
        ar.model(m).vUnits{end+1,1} = [ar.model(m).xUnits{ix,1} '/' ar.model(m).tUnits{1}];
        ar.model(m).vUnits{end,2} = [ar.model(m).xUnits{ix,2} '/' ar.model(m).tUnits{2}];
        ar.model(m).vUnits{end,3} = [ar.model(m).xUnits{ix,3} '/' ar.model(m).tUnits{3}];
        
        if(strcmp(str{1},'MASSACTION'))
            massaction = true;
            massactionkd = false;
        else
            massaction = false;
        end
        if(strcmp(str{1},'MASSACTIONKD'))
            massaction = true;
            massactionkd = true;
        end
        
        C = textscan(fid, '%q %q\n', 1, 'CommentStyle', ar.config.comment_string);
        str = C(1);
        if ( ~isempty(cell2mat(C{2})) )
            ar.model(m).v{end+1} = cell2mat(C{2});
        else
            ar.model(m).v{end+1} = sprintf('v_%d', length(ar.model(m).v) );
        end
        
        ar.model(m).fv_ma_reverse_pbasename{end+1} = '';
        if(~massaction)
            if(reversible)
                error('reversible reactions for type CUSTOM not allowed.');
            else
                ar.model(m).fv(end+1,1) = str{1};
            end
        else
            if(~reversible)
                ar.model(m).fv{end+1,1} = cell2mat(str{1});
                for j=1:length(source)
                    ar.model(m).fv{end,1} = [ar.model(m).fv{end,1} '*' source{j}];
                end
            else
                if(massactionkd)
                    ar.model(m).fv{end+1,1} = [cell2mat(str{1}) '_1*' cell2mat(str{1}) '_2'];
                else
                    ar.model(m).fv{end+1,1} = [cell2mat(str{1}) '_1'];
                end
                ar.model(m).fv_ma_reverse_pbasename{end} = cell2mat(str{1});
                for j=1:length(source)
                    ar.model(m).fv{end,1} = [ar.model(m).fv{end,1} '*' source{j}];
                end
            end
        end
        
        % setup N 1
        ar.model(m).N(1:length(ar.model(m).x),vcount) = 0;
        for jj=1:length(source)
            for j=find(ismember(ar.model(m).map.old.x, source{jj})) %R2013a compatible
                ar.model(m).N(j, vcount) = ar.model(m).N(j, vcount) - 1;
            end
        end
        for jj=1:length(target)
            for j=find(ismember(ar.model(m).map.old.x, target{jj})) %R2013a compatible
                ar.model(m).N(j, vcount) = ar.model(m).N(j, vcount) + 1;
            end
        end
        ar.model(m).fv_source{end+1,1} = source;
        ar.model(m).fv_target{end+1,1} = target;
        
        % check for inconsistent educt compartments
        if(~isempty(ar.model(m).c) && ~ar.model(m).isAmountBased)
            for j=1:size(ar.model(m).N,2)
                if(length(unique(ar.model(m).cLink(ar.model(m).N(:,j)>0)))>1)
                    error('efflux from different compartments in reaction %s', ...
                        ar.model(m).fv{end});
                end
                if(length(unique(ar.model(m).cLink(ar.model(m).N(:,j)<0)))>1)
                    error('influx from different compartments in reaction %s', ...
                        ar.model(m).fv{end});
                end
            end
        end
        
        vcount = vcount + 1;
        
        % setup reversed reaction
        if(massaction && reversible)
            ar.model(m).fv{end+1,1} = [cell2mat(str{1}) '_2'];
            ar.model(m).fv_source{end+1,1} = ar.model(m).fv_target{end,1};
            ar.model(m).fv_target{end+1,1} = ar.model(m).fv_source{end,1};
            ar.model(m).fv_ma_reverse_pbasename{end+1} = cell2mat(str{1});
            for j=1:length(target)
                ar.model(m).fv{end,1} = [ar.model(m).fv{end,1} '*' target{j}];
            end
            
            % infer flux units
            if(~isempty(target))
                ix = find(ismember(ar.model(m).map.old.x, target{1})); %R2013a compatible
            elseif(~isempty(source))
                ix = find(ismember(ar.model(m).map.old.x, source{1})); %R2013a compatible
            else
                error('reaction with empty N');
            end
            ar.model(m).vUnits{end+1,1} = [ar.model(m).xUnits{ix,1} '/' ar.model(m).tUnits{1}];
            ar.model(m).vUnits{end,2} = [ar.model(m).xUnits{ix,2} '/' ar.model(m).tUnits{2}];
            ar.model(m).vUnits{end,3} = [ar.model(m).xUnits{ix,3} '/' ar.model(m).tUnits{3}];
            if ( ~isempty(cell2mat(C{2})) )
                ar.model(m).v{end+1} = cell2mat(C{2});
            else
                ar.model(m).v{end+1} = sprintf('v_%d', length(ar.model(m).v) );
            end
            
            % setup N 2
            ar.model(m).N(1:length(ar.model(m).x),vcount) = 0;
            for jj=1:length(source)
                for j=find(ismember(ar.model(m).map.old.x, source{jj})) %R2013a compatible
                    ar.model(m).N(j, vcount) = ar.model(m).N(j, vcount) + 1;
                end
            end
            for jj=1:length(target)
                for j=find(ismember(ar.model(m).map.old.x, target{jj})) %R2013a compatible
                    ar.model(m).N(j, vcount) = ar.model(m).N(j, vcount) - 1;
                end
            end
            
            % check for inconsistent educt compartments
            if(~isempty(ar.model(m).c))
                for j=1:size(ar.model(m).N,2)
                    if(length(unique(ar.model(m).cLink(ar.model(m).N(:,j)>0)))>1)
                        error('efflux from different compartments in reaction %s', ...
                            ar.model(m).fv{end});
                    end
                    if(length(unique(ar.model(m).cLink(ar.model(m).N(:,j)<0)))>1)
                        error('influx from different compartments in reaction %s', ...
                            ar.model(m).fv{end});
                    end
                end
            end
            
            vcount = vcount + 1;
        end
        
        str = textscan(fid, '%s',1, 'CommentStyle', ar.config.comment_string);
    end
elseif(strcmp(C{1},'ODES'))
    ar.model(m).isReactionBased = false;
    str = textscan(fid, '%q\n',1, 'CommentStyle', ar.config.comment_string);
    ode_count = 0;
    while(~strcmp(str{1},'INVARIANTS') && ~strcmp(str{1},'DERIVED'))
        if(~strcmp(str{1},''))
            ode_count = ode_count + 1;
            ar.model(m).fv{end+1,1} = cell2mat(str{1});
            ar.model(m).fv_ma_reverse_pbasename{end+1} = '';
            ar.model(m).vUnits{end+1,1} = [ar.model(m).xUnits{ode_count,1} '/' ar.model(m).tUnits{1}];
            ar.model(m).vUnits{end,2} = [ar.model(m).xUnits{ode_count,2} '/' ar.model(m).tUnits{2}];
            ar.model(m).vUnits{end,3} = [ar.model(m).xUnits{ode_count,3} '/' ar.model(m).tUnits{3}];
        end
        str = textscan(fid, '%q\n',1, 'CommentStyle', ar.config.comment_string);
    end
    %%Einschub Philipp: �berspringen des Fehlers
    if(ode_count ~= length(ar.model(m).x(1,1:(length(ar.model(m).x)/2))))
        error('number of ODES ~= number of variables');
    end
    ODE_check = 1;
    ar.model(m).N = eye(length(ar.model(m).map.old.x));
end
if(isempty(ar.model(m).fv))
    ar.model(m).isReactionBased = false;
end

ar = doubleReactions(ar,m,ODE_check);
ar.model(m).qPlotV = ones(1,length(ar.model(m).fv));

% dynamic parameters
ar.model(m).pvs = cell(size(ar.model(m).fv));
ar.model(m).pv = {};
for jv=1:length(ar.model(m).fv)
    varlist = symvar(ar.model(m).fv{jv});
    ar.model(m).pvs{jv} = setdiff(varlist, union(ar.model(m).t, union(ar.model(m).x, ar.model(m).u))); %R2013a compatible
    ar.model(m).pv = union(ar.model(m).pv, ar.model(m).pvs{jv});
end

ar.model(m).px = union(union(ar.model(m).pv, ar.model(m).px), ar.model(m).px0); %R2013a compatible
ar.model(m).p = union(ar.model(m).px, ar.model(m).pu); %R2013a compatible


% setup rhs
C = cell(size(ar.model(m).N));
if(length(ar.model(m).c)>1)    
    if(~isfield(ar.model(m),'isAmountBased') || ~ar.model(m).isAmountBased)
        for j=1:size(ar.model(m).N,1) % for every species j
            qinfluxwitheducts = ar.model(m).N(j,:) > 0 & sum(ar.model(m).N < 0,1) > 0;
            eductcompartment = zeros(size(qinfluxwitheducts));
            for jj=find(qinfluxwitheducts)
				eductcompartment(jj) = unique(ar.model(m).cLink(ar.model(m).N(:,jj)<0)); %R2013a compatible
            end
            
            cfaktor = cell(size(qinfluxwitheducts));
            for jj=1:size(ar.model(m).N,2) % for every reaction jj
                if(qinfluxwitheducts(jj) && eductcompartment(jj)~=ar.model(m).cLink(j))
                    cfaktor{jj} = [ar.model(m).pc{eductcompartment(jj)} '/' ...
                        ar.model(m).pc{ar.model(m).cLink(j)}];
                else
                    cfaktor{jj} = '1';
                end
            end
            C(j,:) = transpose(cfaktor);
        end
    else
        for j=1:size(ar.model(m).N,1) % for every species j
            for jj=1:size(ar.model(m).N,2) % for every reaction jj
                C{j,jj} = ['1/' ar.model(m).pc{ar.model(m).cLink(j)}];
            end
        end
    end
else
    for j=1:size(ar.model(m).N,1) % for every species j
        for jj=1:size(ar.model(m).N,2) % for every reaction jj
            C{j,jj} = '1';
        end
    end
end
ar.model(m).fx = cell(length(ar.model(m).x),1);
tmpfx = (sym(ar.model(m).N).*sym(C)) * sym(ar.model(m).fv);
for j=1:length(ar.model(m).x) % for every species j
    ar.model(m).fx{j} = char(tmpfx(j));
end

% DERIVED (previously INVARIANTS)
% ck: alle Derived verdoppeln und ersetzungen durchf�hren

if(strcmp(str{1},'INVARIANTS'))
    error(['Section INVARIANTS in model definition file is deprecated! ' ...
        'Please replace by DERIVED and see usage in: ' ...
        'https://bitbucket.org/d2d-development/d2d-software/wiki/Setting%20up%20models']);
end
ar.model(m).z = {};
ar.model(m).zUnits = {};
ar.model(m).fz = {};
C = textscan(fid, '%s %q %q %q %q\n',1, 'CommentStyle', ar.config.comment_string);
while(~strcmp(C{1},'CONDITIONS') && ~strcmp(C{1},'OBSERVABLES'))
    if(~strcmp(C{1},''))
        if(sum(ismember(ar.model(m).x, [cell2mat(C{1}),doubleSuffix1]))>0) %R2013a compatible
            error('derived variable %s already defined in STATES', cell2mat(C{1}));
        end
        if(sum(ismember(ar.model(m).u, [cell2mat(C{1}),doubleSuffix1]))>0) %R2013a compatible
            error('derived variable %s already defined in INPUTS', cell2mat(C{1}));
        end
        if(sum(ismember(ar.model(m).p, [cell2mat(C{1}),doubleSuffix1]))>0) %R2013a compatible
            error('derived variable %s already defined as parameter', cell2mat(C{1}));
        end
        ar.model(m).z(end+1) = C{1};
        ar.model(m).zUnits(end+1,1) = C{2};
        ar.model(m).zUnits(end,2) = C{3};
        ar.model(m).zUnits(end,3) = C{4};
        ar.model(m).fz(end+1,1) = C{5};
    end
    C = textscan(fid, '%s %q %q %q %q\n',1, 'CommentStyle', ar.config.comment_string);
end
ar.model(m).qPlotZ = ones(size(ar.model(m).z));

ar = doubleDerived(ar,m);

% derived variables parameters
varlist = cellfun(@symvar, ar.model(m).fz, 'UniformOutput', false);
ar.model(m).pz = setdiff(setdiff(vertcat(varlist{:}), {ar.model(m).t, ''}), union(ar.model(m).x, ar.model(m).u)); %R2013a compatible
ar.model(m).px = union(ar.model(m).px, ar.model(m).pz); %R2013a compatible
ar.model(m).p = union(ar.model(m).p, ar.model(m).pz); %R2013a compatible


% ck: alle Observablen verkoppeln und abh. von Zust�nden ersetzen, ebenso
% die errors f�r die Observablen �bernehmen
if(strcmp(C{1},'OBSERVABLES'))
    
    % OBSERVABLES
    ar.model(m).y = {};
    ar.model(m).yNames = {};
    ar.model(m).yUnits = {};
    ar.model(m).normalize = [];
    ar.model(m).logfitting = [];
    ar.model(m).logplotting = [];
    ar.model(m).fy = {};
    C = textscan(fid, '%s %q %q %q %n %n %q %q\n',1, 'CommentStyle', ar.config.comment_string);
    while(~strcmp(C{1},'ERRORS'))
        if ( strcmp( C{1}, 'CONDITIONS' ) )
            error( 'When OBSERVABLES section is specified; ERRORS section must also be specified.' );
        end        
        ar.model(m).y(end+1) = C{1};
        ar.model(m).yUnits(end+1,1) = C{2};
        ar.model(m).yUnits(end,2) = C{3};
        ar.model(m).yUnits(end,3) = C{4};
        ar.model(m).normalize(end+1) = C{5};
        ar.model(m).logfitting(end+1) = C{6};
        ar.model(m).logplotting(end+1) = C{6};
        ar.model(m).fy(end+1,1) = C{7};
        if(~isempty(cell2mat(C{8})))
            ar.model(m).yNames(end+1) = C{8};
        else
            ar.model(m).yNames(end+1) = ar.model(m).y(end);
        end
        C = textscan(fid, '%s %q %q %q %n %n %q %q\n',1, 'CommentStyle', ar.config.comment_string);
        if(sum(ismember(ar.model(m).x, ar.model(m).y{end}))>0) %R2013a compatible
            error('%s already defined in STATES', ar.model(m).y{end});
        end
        if(sum(ismember(ar.model(m).u, ar.model(m).y{end}))>0) %R2013a compatible
            error('%s already defined in INPUTS', ar.model(m).y{end});
        end
        if(sum(ismember(ar.model(m).z, ar.model(m).y{end}))>0) %R2013a compatible
            error('%s already defined in DERIVED', ar.model(m).y{end});
        end
        if(sum(ismember(ar.model(m).p, ar.model(m).y{end}))>0) %R2013a compatible
            error('%s already defined as parameter', ar.model(m).y{end});
        end
    end
    
    
    
    % observation parameters
    varlist = cellfun(@symvar, ar.model(m).fy, 'UniformOutput', false);
    ar.model(m).py = setdiff(setdiff(vertcat(varlist{:}), union(union(union(ar.model(m).x, ar.model(m).u), ar.model(m).z), ar.model(m).z)), {ar.model(m).t, ''}); %R2013a compatible
    
    % ERRORS
    ar.model(m).fystd = cell(size(ar.model(m).fy));
    C = textscan(fid, '%s %q\n',1, 'CommentStyle', ar.config.comment_string);
    while(~strcmp(C{1},'CONDITIONS'))
        qy = ismember(ar.model(m).y, C{1}); %R2013a compatible
        if(sum(qy)~=1)
            error('unknown observable %s', cell2mat(C{1}));
        end
        ar.model(m).fystd(qy) = C{2};
%         qy1 = ismember(ar.model(m).y, [cell2mat(C{1}),doubleSuffix1]); %R2013a compatible
%         qy2 = ismember(ar.model(m).y, [cell2mat(C{1}),doubleSuffix2]); %R2013a compatible
%         if(sum(qy1)~=1 && sum(qy2)~=1)
%             error('unknown observable %s', cell2mat(C{1}));
%         elseif sum(qy1)==1
%             ar.model(m).fystd(qy1) = doubleOld2New(C{2},[],1);
%         elseif sum(qy2)==1
%             ar.model(m).fystd(qy2) = doubleOld2New(C{2},[],2);
%         else
%             error('should not occur.')
%         end
        C = textscan(fid, '%s %q\n',1, 'CommentStyle', ar.config.comment_string);
    end
    
    if(length(ar.model(m).fystd)<length(ar.model(m).fy) || sum(cellfun(@isempty, ar.model(m).fystd))>0)
        error('some observables do not have an error model defined');
    end
    
    % error parameters
    varlist = cellfun(@symvar, ar.model(m).fystd, 'UniformOutput', false);
    ar.model(m).pystd = setdiff(vertcat(varlist{:}), union(union(union(union(union(ar.model(m).x, ar.model(m).u), ar.model(m).z), ... %R2013a compatible
        ar.model(m).z), ar.model(m).y), ar.model(m).t));
    
    % add to parameters needed for model
    ar.model(m).p = union(union(ar.model(m).p, ar.model(m).py), ar.model(m).pystd);
end
if isfield(ar.model(m),'py')
    ar = doubleUpdateMap(ar,m,'py');
end
if isfield(ar.model(m),'pystd')
    ar = doubleUpdateMap(ar,m,'pystd');
end
ar = doubleUpdateMap(ar,m,'p');
ar = doubleObservables(ar,m);

% CONDITIONS
matVer = ver('MATLAB');
if(str2double(matVer.Version)>=8.4)
    C = textscan(fid, '%s %q\n',1, 'CommentStyle', ar.config.comment_string);
else
    C = textscan(fid, '%s %q\n',1, 'CommentStyle', ar.config.comment_string, 'BufSize', 2^16);
end
ar.model(m).fp = transpose(ar.model(m).p);

while(~isempty(C{1}) && ~strcmp(C{1},'PARAMETERS'))
    qcondpara = ismember(ar.model(m).p, [cell2mat(C{1}),doubleSuffix1]); %R2013a compatible
    qcondpara2 = ismember(ar.model(m).p, [cell2mat(C{1}),doubleSuffix2]); %R2013a compatible
    notfound = true;
    if sum(qcondpara)>1 || sum(qcondpara2)>1
        error('sum(qcondpara)>1 || sum(qcondpara2)>1: This case should not occur.')
    end    
    
    if(sum(qcondpara)>0)
%         ar.model(m).fp{qcondpara} = ['(' cell2mat(C{2}) ')'];
        ar.model(m).fp{qcondpara} = ['(' doubleOld2New(cell2mat(C{2}),[],1) ')'];
        notfound = false;
    end
    if(sum(qcondpara2)>0)
        ar.model(m).fp{qcondpara2} = ['(' doubleOld2New(cell2mat(C{2}),[],2) ')']; %{'px','pu','pv','px0','pcond'}
        notfound = false;
    end
    if notfound
        warning('unknown parameter in conditions: %s', cell2mat(C{1})); %#ok<WNTAG>
    end
    if(str2double(matVer.Version)>=8.4)
        C = textscan(fid, '%s %q\n',1, 'CommentStyle', ar.config.comment_string);
    else
        C = textscan(fid, '%s %q\n',1, 'CommentStyle', ar.config.comment_string, 'BufSize', 2^16-1);
    end
end



% extra conditional parameters
varlist = cellfun(@symvar, ar.model(m).fp, 'UniformOutput', false);
ar.model(m).pcond = setdiff(setdiff(setdiff(vertcat(varlist{:}), ar.model(m).p), ar.model(m).x), ar.model(m).u); %R2013a compatible

ar = doubleConditions(ar,m);

% PARAMETERS
if(~isfield(ar, 'pExternLabels'))
    ar.pExternLabels = {};
    ar.pExtern = [];
    ar.qFitExtern = [];
    ar.qLog10Extern = [];
    ar.lbExtern = [];
    ar.ubExtern = [];
end
C = textscan(fid, '%s %f %n %n %f %f\n',1, 'CommentStyle', ar.config.comment_string);
while(~isempty(C{1}))
    ar.pExternLabels(end+1) = C{1};
    ar.pExtern(end+1) = C{2};
    ar.qFitExtern(end+1) = C{3};
    ar.qLog10Extern(end+1) = C{4};
    ar.lbExtern(end+1) = C{5};
    ar.ubExtern(end+1) = C{6};
    C = textscan(fid, '%s %f %n %n %f %f\n',1, 'CommentStyle', ar.config.comment_string);
end

ar = doubleExtern(ar);

fclose(fid);
