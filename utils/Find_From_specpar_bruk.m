function param = Find_From_specpar_bruk(FileAt, ParName)

% clear all
% FileAt = 'C:\Users\manu\Google Drive\M18\proj\TimeResolvedProcessing\scripts\InputData\R14DEL_PLN_K\6ms';

fid = fopen([FileAt filesep 'specpar']);
s = textscan(fid, '%s', 'delimiter', '\n'); 
fclose(fid);
% ParName = 'SFO8';

for k = 1:length(s{1})
    if ~isempty(regexp(s{1}{k},ParName, 'once'))
        Loc = k;
        break;
    end 
end 

StringWithVariable  = s{1}{Loc};

eval([StringWithVariable((strfind(StringWithVariable, ParName)):end) ';']);
eval(['param = ' ParName ';']);


