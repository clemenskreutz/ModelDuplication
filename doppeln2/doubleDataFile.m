% Verdoppelt die Spalte mit den conditions aus dem Datenfile
% 
%   Columns for random effects parameter replacements should not be
%   doubled.
% 
%   ignore  columns which are completely left as in the input
% 
%   ignore_val  columns which are double and header suffix is appended, but
%               the values are left as in the input

function [header,data,dataCell] = doubleDataFile(header,data,dataCell,ignore,ignoreval)
if ~exist('ignore','var') || isempty(ignore)
    ignore = cell(0);
end
if ~exist('ignoreval','var') || isempty(ignoreval)
    ignoreval = cell(0);
end

[~,irand] = intersect(header,ignore);
[~,iignoreval] = intersect(header,ignoreval);
header1 = strcat(header,doubleSuffix1);
% header1(irand) = header(irand);
header2 = strcat(header,doubleSuffix2);
% header2(irand) = header(irand);

[~,irand1] = intersect(header1,ignore);
[~,irand2] = intersect(header2,ignore);

header1(irand) = header(irand);
header2(irand) = [];

header = [header1,header2];


dataCell1 = dataCell;
dataCell1 = strcat(dataCell1,doubleSuffix1);
dataCell1(:,irand) = dataCell(:,irand);  % overwrite colums for random effects
dataCell1(:,iignoreval) = dataCell(:,iignoreval);  % overwrite colums for random effects

dataCell2 = dataCell;
dataCell2 = strcat(dataCell2,doubleSuffix2);
dataCell2(:,iignoreval) = dataCell(:,iignoreval);  % overwrite colums for random effects
dataCell2(:,irand) = [];
% dataCell2(:,irand2) = dataCell(:,irand2);% overwrite colums for random effects

dataCell = [dataCell1,dataCell2];

data2 = data;
data2(:,irand) = [];
data = [data,data2];


