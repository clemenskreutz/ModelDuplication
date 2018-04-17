% Verdoppelt die Spalte mit den conditions aus dem Datenfile

function [header,data,dataCell] = doubleDataCondis(header,data,dataCell,pcond)
iscond = find(ismember(header,pcond));
data = [data,data(:,iscond)];
dataCell = [dataCell,dataCell(:,iscond)];
header = [header,strcat(header(iscond),'_')];
