% Verdoppelt die Spalte mit den conditions aus dem Datenfile

function [header,data,dataCell] = doubleDataFile(header,data,dataCell)

data = [data,data];
dataCell = [dataCell,dataCell];
header = [header,strcat(header,'_')];
dataCell(isnan(data)) = strcat(dataCell(isnan(data)),'_');

