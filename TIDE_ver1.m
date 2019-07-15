% Generate TIDE Spectra from a homonuclear FID data.
% Reads fid file generated using NMRPipe (see the example attached)
% For Bruker data use "varian      = 0"

% 08/20/2018; Manu V Subrahmanian 
% University Of Minnesota, BMBB

clear all 
Set_Currect_Utils_Path

fid_File            = 'InputData\NAVL_Darr\2deg_10ms\test.fid';
 
X_order = [1 0 ]; Y_order = [0 1 ];

PH0                 = -95;  %170
PH1                 = 0.00;
T2                  = 0.8;
FromTo_ppm          = [18 41];%[10 75];
TimeAxis_Width      = 0.1;   %% 0 to 1

TimeAxis_Loc_Array	= 0.0; 
Contour_From        = 8;

Contour_To          = 66;

Level_Multiplier    = 200;
plot_1DSpectrum     = 0; 
FID_TRIM_1  = '1:end'; FID_TRIM_2 = '1:1024';
cmap_1DMin_Max      = [0.55 0.8];
TimeAxisLimits_ms   = [0.5 3];


PhaseAveraging_width_Deg    = 0;
PhaseAveraging_Points       = 1;

FilterFtn       = 'disk'; % options :  'average'  'disk' 'motion'  'gaussian' 
FilterSigma     = 8; 
varian          = 0;     
ZeroFillTo      = 1024*8;


%  %%%%%%%DO NOT change the remaining ; %%%%%%%%%%%


CovPower            = 1;
exp_ContourLevels   = 1;
SaveFigureType      = 'png';
Contours_Nos        = 33;

[filepath,name,ext] = fileparts(fid_File);
Save_FolderName   	=  filepath;

if varian
    GenFIDMatrix 
else
    GenFIDMatrix_Bruk
end

eval( ['FIDMatrix = FIDMatrix(' FID_TRIM_2 ', ' FID_TRIM_1 ');'] );
PlotFirst1D 

%% gen fid_xy 1real(t1)-2imag(t1)-3real(t1)-4imag(t1)-......
for k = 1:(size(FIDMatrix,2)/lo)
    fid_xy(:,k) = FIDMatrix(:,(k-1)*lo+find(X_order))+ 1i*FIDMatrix(:,(k-1)*lo+find(Y_order));
end
size(fid_xy)

%%    
for k = 1:(size(fid_xy,2)/2)
    fid_x(:,k) = fid_xy(:,(k-1)*2+1);
    fid_x(:,k) = fid_xy(:,2*k);
    fid_x(:,k) =fid_xy(:,(k-1)*2+1) + fid_xy(:,2*k) ;
end
fid_x =  (fid_xy);
%%


%%  create save folder 
if exist('Save_FolderName', 'var') 
    OutFolder = [pwd filesep 'SpectralOutput' filesep Save_FolderName];
    if ~exist(OutFolder, 'dir'); mkdir(OutFolder); end
end

%% get display region index 
xaxis       = interp1_mvs(xaxis, ZeroFillTo);
FromTo_ppm  = sort(FromTo_ppm);
[~, loc1]   = min(abs(xaxis-FromTo_ppm(1)));[~, loc2] = min(abs(xaxis-FromTo_ppm(2)));
txaxis      = xaxis(loc1:loc2);
if ~exist('DisplayRegion', 'var')
    DisplayRegion = [FromTo_ppm FromTo_ppm];
end
[~, idx1] = min( abs(txaxis - DisplayRegion(1)) );
[~, idx2] = min( abs(txaxis - DisplayRegion(2)) );
[~, idx3] = min( abs(txaxis - DisplayRegion(3)) );
[~, idx4] = min( abs(txaxis - DisplayRegion(4)) );
DispIdx_y = (min([idx1 idx2])):(max([idx1 idx2])); 
DispIdx_x = (min([idx3 idx4])):(max([idx3 idx4]));

%%
if ~exist('CovPower', 'var')
    CovPower = 1; 
end
%%
clear cov1
DateTime_string = datestr(now,'yymmdd_HHMMSS');
for k_loc = 1:length(TimeAxis_Loc_Array)
    TimeAxis_Loc = TimeAxis_Loc_Array(k_loc);
    EXP_ZF_FFT_SEL_COV_5_1 
    
    cov1 = cov1/max(MAX_FirstCov(:));
    figure
    Cov2Plot = Level_Multiplier*cov1(DispIdx_x, DispIdx_y); 
    XX = XX(DispIdx_x, DispIdx_y); YY = YY(DispIdx_x, DispIdx_y);
    if exist('FilterFtn', 'var')
        switch FilterFtn
            case 'gaussian'
                Cov2Plot = imgaussfilt(Cov2Plot,FilterSigma);
            otherwise
                Filter_h = fspecial(FilterFtn, FilterSigma);
                Cov2Plot = imfilter(Cov2Plot, Filter_h);
        end 
    end
    
    
    %%  ContourLevels 
    Generate_ContourLevels
    
    Cov2Plot = Cov2Plot.^CovPower;
    contour(XX, YY, Cov2Plot, ContourLevels);
 
    set(gca,'xdir','reverse','ydir','reverse');
    title(sprintf('Time: %0.2f; Width: %0.2f ', TimeAxis_Loc, TimeAxis_Width))
    % surf(cov1,'linestyle','none')
    colormap('winter')
    set(gcf,'color','w');
    
    %% ASPECT Ratio
    xy_axis_len = [abs(diff(DisplayRegion(1:2)))  abs(diff(DisplayRegion(3:4)))];
    xy_axis_len = xy_axis_len/min(xy_axis_len);
    pbaspect([xy_axis_len 1])
    %%
    if exist('Save_FolderName', 'var') 
        OutFileName = [ DateTime_string '_'  num2str(k_loc)];
        if length(TimeAxis_Loc_Array) == 1 
            title(Save_FolderName, 'interpreter', 'none');
            SaveFig_mvs(gcf, [OutFolder filesep OutFileName], [5 4] );
        else 
            SaveFig_mvs(gcf, [OutFolder filesep OutFileName], [5 4],  SaveFigureType);
            pause(0.5)
            close all
        end
            
    end  
    
end
 
%%
% 
% % surf(real(Cov2Plot),'linestyle','none')

% %% plot 1D projecton
% figure
% position_ChemShift = 58.4;
% % position_ChemShift = 66.7;
% position_ChemShift = 14.6;
% % position_ChemShift = 66.7;
% % position_ChemShift = 66.7;
% % position_ChemShift = 66.7;
% 
% position_ChemShift = 67.45;
% % position_ChemShift = 31.72;
% % position_ChemShift = 28.28;
% 
% 
% [~, Loc_1D] = min(abs(XX(1,:) - position_ChemShift));
% plot(XX(Loc_1D,:),  (real(Cov2Plot(Loc_1D,:))).^1); hold on
% % ylim([-2 12]);
% set(gca,'xdir', 'reverse');
% 
% % for Id__ = 788
% %     plot(XX(Id__,:),  real(Cov2Plot(Id__,:))); hold on
% % % end
% % 
% % xlim([min(XX(Id__,:)), max(XX(Id__,:))]);
% %     
% % set(gcf, 'position', [450.6000  349.4000  560.0000  238.0000]);
% % SaveFig_mvs(gcf, [OutFolder filesep '1D_' OutFileName]);


