%% CLICK DETECTION (AR MODEL-BASED)
%  -------------------------------------------------------------------------------------


%% time axis
% ..........

t = 0:1/fs:(length(sig)-1)/fs;


%% Optional->plot spectrum of the signal in dB
% ............................................

nfft = 2^ceil(log2(length(sig)));
faxes = (0:nfft/2-1)/nfft*fs;
SIG = fft(sig,nfft);

if plots_bool==1
    spectrum_fig = figure(4);
    clf
    semilogx(faxes,db(abs(SIG(1:end/2))));
    xlabel('f [Hz]');
    ylabel('Magnitude [dB]');
    xlim([0,fs/2]);
    grid on;
    title("Computation of AR parameters - Spectra")
end


%% Computation of a parameter of AR model
% .......................................

% [r,rlags] = xcorr(sig,sig,'coeff'); % compute autocorrelation
% rpos = r(rlags >=0); % consider correlation only for positive lags
% p = 12; %Order of the AR model
% R = toeplitz(rpos(1:p)); %coefficients from 0 to p-1
%a = R\rpos(2:p+1); %rpos(2:p+1) : coefficients from 1 to p

a = arburg(sig,p);
a(1) = [];
a=-a';

A = fft([1 ;-a],nfft);

%% Computation of sigmaE
% ......................

e=zeros(length(sig),1);

%Computation of the estimation error
for n=1:length(sig)
    sum = 0;
    for i=1:p
        if n>i
            sum = sum + a(i)'*sig(n-i);
        end
    end
    e(n) = sig(n)-sum;
end

sigmaE = sqrt(var(e));

E = fft(e,nfft);

if plots_bool==1
    figure(spectrum_fig);
    hold on;
    err_plot = plot(faxes,db(abs(E(1:end/2))),'y');
    err_plot.Color(4)=0.15;
    
    figure(spectrum_fig);
    hold on;
    plot(faxes,db(abs(1./A(1:end/2))),'r','LineWidth',2);
    legend("Signal spectrum", "E (Error spectrum)", "1/A (Shaping filter spectrum)");
end


%% Click detection algorithm
% ..........................

N = length(sig);
err = zeros(N,1);
sw = zeros(N,1);

for n=1:N
    %Generation of the switching process
    if abs(e(n))>k*sigmaE
        sw(n)=1;
    else
        sw(n)=0;
    end
    
end


if plots_bool==1
    figure(3)
    subplot(2,1,2)
    plot(t, sig);
    hold on
    stem(t,sw*1);
    xlabel("Time [s]")
    title("Click detection - Detected Clicks")
    legend("Signal", "sw (clicks)")
end