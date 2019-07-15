fileID = fopen(fid_File, 'r');
fiddata_full = fread(fileID ,[1 inf],'float');
fclose(fileID); 



[FileAt,~,~] = fileparts(fid_File);
% B0 = Find_From_procpar(FileAt, 'H1reffrq'); B0 = B0(1); 
B0 = Find_From_specpar_bruk(FileAt, 'SFO8');
bwx_hz = fiddata_full(101);  bwy_hz =  fiddata_full(230);
sw1_ppm = bwx_hz/(0.2515*B0); 
% sw1_ppm = bwx_hz/(1*B0); 

o1p = fiddata_full(67); o2p = fiddata_full(68); 
td2 = fiddata_full(96); 
%%
fiddata_full = fiddata_full(1,513:end);
FIDMatrix = reshape(fiddata_full, [ td2, (length(fiddata_full))/td2]);

% % % % % %% for 1H  ; comment otherwise
% % % % % sw1_ppm = bwx_hz/(1*B0); 
% % % % % FIDMatrix = reshape(fiddata_full, [ 2*td2, (length(fiddata_full))/(2*td2)]);
% % % % % FIDMatrix =FIDMatrix(67:end,:);
%%
AqTime = td2/bwx_hz;
DwellTime_ms = AqTime/td2*1e3;
