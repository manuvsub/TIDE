 
lo = length(X_order);
xaxis = linspace(o1p-(sw1_ppm/2), o1p+(sw1_ppm/2), size(FIDMatrix,1));
if plot_1DSpectrum
    FirstFid = FIDMatrix(:,(plot_1DSpectrum-1)*lo+find(X_order))+ 1i*FIDMatrix(:,(plot_1DSpectrum-1)*lo+find(Y_order));
    FirstFid = FirstFid*expm(-1i*pi/180*PH0);
    FirstFid = FirstFid.*repmat(  exp(-linspace(0,1,size(FirstFid,1)) / (T2+1e-199))', 1, size(FirstFid,2));
    FirstSpec = fftshift(fft(FirstFid));
%     figure
    subplot(2,1,2)
    plot(xaxis, real(FirstSpec)); 
    set(gca, 'xlim', [min(xaxis) max(xaxis) ]); hold on
    set(gca,'xdir','reverse')
    
    subplot(2,1,1)
    plot(xaxis, real(FirstSpec));  hold on
    set(gca,'xdir','reverse')
    set(gca, 'xlim', FromTo_ppm)
end



%% split the 1D to the selected region

if plot_1DSpectrum && exist('PH1', 'var')  

        [~, x_loc1] = min(  abs(xaxis - FromTo_ppm(1))  );
        [~, x_loc2] = min(  abs(xaxis - FromTo_ppm(2))  );
        if x_loc1 > x_loc2
            temp_loc = x_loc2;
            x_loc2 = x_loc1;
            x_loc1 = temp_loc; 
        end
        SelectedRegion_Indices = x_loc1:x_loc2;
        xaxis_sel       = xaxis(SelectedRegion_Indices);
        FirstSpec_sel   = FirstSpec(SelectedRegion_Indices);
        subplot(2,1,1)

        PH1_array = PH1*linspace(-diff(FromTo_ppm)/2, diff(FromTo_ppm)/2, length(FirstSpec_sel));
        FirstSpec_sel = FirstSpec_sel.*exp(-1i*PH1_array)';

%         plot(xaxis_sel, real(FirstSpec_sel),'r');
        plot(xaxis_sel, real(FirstSpec_sel)); 
        % set(gca, 'xlim', FromTo_ppm)
end

