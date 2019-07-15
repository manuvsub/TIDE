%% exponential multiplication
pfid_x = fid_x;
pfid_x = pfid_x.*repmat(  exp(-linspace(0,1,size(pfid_x,1)) / (T2+1e-199))', 1, size(pfid_x,2));

%%  ZERO Filling
if ZeroFillTo > size(pfid_x,1)
    pfid_x = [pfid_x; zeros(ZeroFillTo-size(pfid_x,1), size(pfid_x,2))];
end

%%

if ~exist('PhaseAveraging_width_Deg', 'var')
    PhaseAveraging_width_Deg = 60;
end

if PhaseAveraging_Points == 1
    PH0_a = PH0;
else
    PH0_a = linspace(PH0-PhaseAveraging_width_Deg/2,PH0+PhaseAveraging_width_Deg/2,PhaseAveraging_Points);
end
cov_mean_ph_array = zeros(length(txaxis));

for k_ph0 = 1:length(PH0_a)
    fprintf('%3d/%d ; %3d/%d\n',k_loc, length(TimeAxis_Loc_Array), k_ph0, length(PH0_a))
    PH0_temp = PH0_a(k_ph0);
    %% FFT 
    spe_x = expm(-1i*pi/180*PH0_temp)*(fft(pfid_x)); spe_x = fftshift(spe_x, 1); 
    

    spe_rx = real(spe_x);
%     spe_rx = abs(spe_x);    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% 

    spe_trx = spe_rx(loc1:loc2,:);

    %%  
    if exist('PH1', 'var') 
        PH1_array = PH1*linspace(-diff(FromTo_ppm)/2, diff(FromTo_ppm)/2, size(spe_trx,1));
        PH1_array = (repmat(PH1_array, size(spe_trx,2), 1));
        spe_trx = spe_trx.*exp(-1i*PH1_array)';
    end 

    %%
    [XX, YY] = meshgrid(txaxis, txaxis);
    TCF_StartIndices = 1:round(size(spe_rx,2)/2);

    lts = length(TCF_StartIndices);
    if TimeAxis_Width == 0
        Weights = zeros(1,lts); Weights(round(TimeAxis_Loc*lts) + 1) = 1;
    else
        Weights = (normpdf(linspace(0,1,lts), TimeAxis_Loc, TimeAxis_Width ));
        Weights(isnan(Weights)) = 0;
        Weights = Weights/max(Weights(:));
    end



    % T_width 
    %% 
    cov1_temp = zeros(size(spe_trx,1));
    Weights_Sum = 0;
    parfor k_i = 1:TCF_StartIndices(end)
        if Weights(k_i) > 0.1
%             disp(k_i)
            Curr_spe_trx = spe_trx(:,k_i:end);
            temp1 = cov(Curr_spe_trx');
            temp1 = real(sqrt(temp1)) - real(sqrt(-temp1));
            cov1_temp = cov1_temp + Weights(k_i)*temp1; 
            Weights_Sum = Weights_Sum + Weights(k_i);
        end
    end
    cov1_temp = cov1_temp/Weights_Sum;
    
    cov_mean_ph_array = cov_mean_ph_array + cov1_temp;
    
    MAX_FirstCov = cov(spe_trx');
    MAX_FirstCov = real(sqrt(MAX_FirstCov)) - real(sqrt(-MAX_FirstCov));
    
end
cov1 = cov_mean_ph_array/length(PH0_a);
