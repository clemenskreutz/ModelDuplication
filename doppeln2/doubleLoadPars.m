%   Like arLoadPars but loads to the primary parameters in the duplicated
%   model.
% 
% This function load ar from the workspace, appends doubleSuffix1 to
% ar.pLabel, saves to a temporary workspace and then calles arLoadPars with
% applied to this temporary workspace.
% 
% Examples:
%   doubleLoadPars
% 
%   doubleLoadPars(1)


function doubleLoadPars(filename, fixAssigned, pars_only, pfad, varargin)

if(~exist('fixAssigned','var') || isempty(fixAssigned))
    fixAssigned = [];
end
if(~exist('pars_only','var') || isempty(pars_only))
    pars_only = [];
end
if(~exist('pfad','var') || isempty(pfad))
    pfad = './Results';
end


if(~exist('filename','var') || isempty(filename))
    [~, filename] = fileChooser(pfad, 1, true);
elseif(isnumeric(filename)) % filename is the file-number
    [~, ~, file_list] = fileChooser(pfad, 1, -1);    
    filename = file_list{filename};
elseif(strcmp(filename,'end'))
    filelist = fileList(pfad);
    filename = filelist{end};
elseif(strcmp(filename,'all'))
    filename = fileList(pfad);
elseif ischar(filename)
    [~,filename]=fileparts(filename);    % remove path
end

pfadfile1 = [pfad,'/',filename,'/workspace_pars_only.mat'];
pfadfile2 = [pfad,'/',filename,'/workspace.mat'];

if exist(pfadfile1,'file')
    pfadfile = pfadfile1;
else
    pfadfile = pfadfile2;
end

tmp = load(pfadfile);
tmp.ar.pLabel = strcat(tmp.ar.pLabel,doubleSuffix1);

ar = tmp.ar;

mkdir('Results/doubleLoad_tmp/');

copyfile(pfadfile,'Results/doubleLoad_tmp/workspace_pars_only.mat');
save('Results/doubleLoad_tmp/workspace_pars_only.mat','ar','-append');

arLoadPars('doubleLoad_tmp',fixAssigned, pars_only,'Results',varargin{:})

