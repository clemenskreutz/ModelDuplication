% Verdoppelt die Spalte mit den conditions aus dem Datenfile

function [header,data,dataCell] = doubleDataCondis(header,data,dataCell,pcond)
iscond = find(ismember(header,pcond));
header(iscond) = strcat(header(iscond),doubleSuffix1);

data = [data,data(:,iscond)];
dataCell = [dataCell,dataCell(:,iscond)];
header = [header,strcat(header(iscond),doubleSuffix2)];
