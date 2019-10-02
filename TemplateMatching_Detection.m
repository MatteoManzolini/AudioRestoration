%% CLICK DETECTION (AR MODEL-BASED)
%  -------------------------------------------------------------------------------------


%% time axis
% ..........

t = 0:1/fs:(length(sig)-1)/fs;


%% Computation of a parameter of AR model
% .......................................

nfft = 2^ceil(log2(length(sig)));

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

%% Click detection algorithm
% ..........................


%1- Filtering of the click waveform
for n=1:length(h)
    sum = 0;
    for i=1:p
        if n>i
            sum = sum + a(i)'*h(n-i);
        end
    end
    hf(n) = h(n)-sum;
end

N = length(sig);
err = zeros(N,1);
sw = zeros(N,1);
l = 3;
K = length(hf);


while n<=N
    
    if abs(e(n))>k*sigmaE
        t0 = n-l;
        
        %2 - Similarity Score
        for tau=1:l %Da 1(uno) a l(elle)
            sumo=0;
            for kappa=1:K
                sumo = sumo+(h(kappa)*e(t0+tau+kappa));
            end
            g(tau) = sumo;
        end
        tau_max = find(g==max(g));
        shift = tau_max-l;
        
        %3 - Generation of the switching process
        if(abs(g(tau_max))>0.0275) %If the waveform is similar to the detected impulse event
            sw(n+shift:n+shift+length(hf)-1)=1;
        end
        
        %disp("g(tau_max) = "+g(tau_max))
        
        
        n = n+length(hf);
    else
        sw(n)=0;
        n = n+1;
    end
    
end
