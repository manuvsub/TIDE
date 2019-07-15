function param = Find_From_procpar(FileAt, ParName)

% clear all
% FileAt = 'C:\Users\manu\Google Drive\M18\proj\TimeResolvedProcessing\scripts\InputData\darr_tobsy_memb_fromGopi_Feb2018\GP2-PH7\darr100ms-nca-2c';
% ParName = 'dpwr2';

% FileAt = 'C:\Users\manu\Google Drive\M18\proj\TimeResolvedProcessing\scripts\InputData\WTPLN_Penta_darr200ms_010710.fid';
% ParName = 'dfrq';



fid = fopen([FileAt '\procpar']);
s = textscan(fid, '%s', 'delimiter', '\n');
 

for k = 1:length(s{1})
%     if ~isempty(regexp(s{1}{k},ParName, 'once'))
    if length(s{1}{k}) > length(ParName)
        if strcmp(s{1}{k}(1:length(ParName)), ParName)  && strcmp(s{1}{k}(1+length(ParName)), ' ' )  
            Loc = k;
            break;
        end 
    end
end 

param = str2num(s{1}{Loc+1});
param = param(2:end);
