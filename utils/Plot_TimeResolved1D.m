function Plot_TimeResolved1D(fid1,xaxis, DwellTime_ms, FromTo_ppm_1D, clr)
xlimV = [0.50 9]; ylimV = FromTo_ppm_1D; 
BlockSize = 20;
abs_real = 'real';

clear SpectralArray
N = length(fid1);
Nslices = floor(N/2)-1;  Tau_fromTo_ms  = [0 Nslices*DwellTime_ms];
for k = 1:Nslices
    temp1 = fid1(k+(1:floor(N/2)));
    temp1 = fid1(k:end);
    SpectralArray(:,k) = fftshift(fft(temp1, floor(N/2)));
end
xaxis_ = interp1_mvs(xaxis, size(SpectralArray,1));
subplot(1,10,1);
Spec1D2plot = real(SpectralArray(:,1))';Spec1D2plot = Spec1D2plot/max(Spec1D2plot(:));
plot(-Spec1D2plot, xaxis_ );
ylim(ylimV); xlim([ -max(Spec1D2plot)  0.3]);
axis off
% plot(real(SpectralArray'))
%%
% SpectralArray = abs(SpectralArray);
eval(['SpectralArray = ' abs_real '(SpectralArray);']);

for k = 1:size(SpectralArray, 1)
    nB = floor(size(SpectralArray, 2)/BlockSize);
    for kb = 1:nB
        temp_idx = ((kb-1)*BlockSize+1):(kb*BlockSize);
        [mxval(kb), mxid] = min(  SpectralArray( k,temp_idx )  );
        temp_x =  xaxis_((temp_idx));
        Mxaxis(kb) = temp_x(mxid);
    end 
%     plot(Mxaxis, mxval)
    SpectralArray_(:,k) = interp1(Mxaxis, mxval, xaxis_);
end
SpectralArray_ = SpectralArray_'; 
%%
% figure
Ns = 1024; 
SpectralArray_ = imresize(SpectralArray_,  [Ns Ns]);

%% smoothening 
% clear temp1
% for k = 1:size(SpectralArray_,1)
%     temp1(:,k) = smooth(SpectralArray_(:,k),2); 
% end
% SpectralArray_ = temp1;


%%
DecayTime = linspace(Tau_fromTo_ms(1), Tau_fromTo_ms(2), Ns);
Fqcy_     = interp1_mvs(  xaxis_, Ns);
% clr.cmap = 'hot';
% clr.color_MinMax = [0.1 1];
[xx, yy] = meshgrid(DecayTime, Fqcy_);
SpectralArray_ = abs(SpectralArray_); SpectralArray_ = SpectralArray_/max(SpectralArray_(:));
subplot(1,10,2:10)
surf(xx, yy, SpectralArray_, 'linestyle', 'none'); view(2); colormap(clr.cmap);caxis(clr.color_MinMax)
xlim(xlimV); ylim(ylimV);
xlabel('time (ms)'); ylabel('13C chemical shift (ppm)', 'Rotation',-90);
ylabh = get(gca,'ylabel'); set(ylabh,'Units','normalized');
get(ylabh,'position');
% set(ylabh,'position', [-0.0815    0.5000         0]);
set(ylabh,'position', get(ylabh,'position') + [1.2 0 0]);
  
set(gca, 'YAxisLocation','right'); ytickangle(-90)
% set(gca,'YTickLabel',[]);
%%
% figure
% plot(nanmean(SpectralArray(:,51:150 )'))

% figure
% surf( real(cov((fft(SpectralArray')))), 'linestyle', 'none'); view(2); colormap(clr.cmap);caxis(clr.color_MinMax)
% colormap('jet'); caxis([0, 1e12])
 
