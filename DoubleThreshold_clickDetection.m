%% CLICK DETECTION (AR MODEL-BASED)
%  -------------------------------------------------------------------------------------

%% time axis
% ..........

t = 0:1/fs:(length(sig)-1)/fs;


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


%% Click detection algorithm
% ..........................

N = length(sig);
sw = zeros(N,1);

lambdaD = k*sigmaE;
b = 0.5;
lambdaL = b*lambdaD;

n=1;
while n<=N
    if abs(e(n))>lambdaD %Start from the first that go beyond the threshold
        e_part = e(n:n+20); %Take a partition
        
        %1 - select sample with the highest magnitude over lambdaD in e
        max_e_part_pos = find(e_part==max(e_part));
        click_samples_pos = max_e_part_pos; %Initialization of position of click samples
        
        %2 - select the set of contiguous samples greater than lambdaL
        stopLow = 0;
        stopHigh = 0;
        
        if max_e_part_pos == 1
            stopLow=1;
        end
        if max_e_part_pos == length(e_part)
            stopHigh=1;
        end
        
        for ii=1:length(e_part)
            if stopHigh==0 && e_part(max_e_part_pos+ii)>lambdaL
                click_samples_pos = [click_samples_pos find(e_part(max_e_part_pos+ii))];
                if max_e_part_pos+ii==length(e_part) %If we are at the end
                    stopHigh = 1;
                end
            else
                stopHigh = 1;
            end
            
            if stopLow==0 && e_part(max_e_part_pos-ii)>lambdaL
                click_samples_pos = [click_samples_pos find(e_part(max_e_part_pos-ii))];
                if max_e_part_pos-ii==1 %If we are at the beginning
                    stopLow = 1;
                end
            else
                stopLow = 1;
            end
        end
        
        click_samples_pos = sort(click_samples_pos);
        
        
        sw(n+click_samples_pos(1)-1:n+click_samples_pos(end)-1) = 1;
        
        n = n+length(click_samples_pos);
    else
        n = n+1;
    end
    
end

% for j=1:length(sw)
%     if sw(j)==1
%         if sw(j+3)==1
%             sw(j:j+3)=1;
%         end
%         if sw(j+2)==1
%             sw(j:j+2)=1;
%         end
%         if sw(j+1)==1
%             sw(j:j+1)=1;
%         end
%     end
% end

for j=1:length(sw)
    if sw(j)==1 && sw(j+1)==0
        for k=4:-1:1
            if sw(j+k)==1
                sw(j:j+k)=1;
            end
        end
    end
end

% if plots_bool==1
%     figure(3)
%     subplot(2,1,2)
%     plot(t, sig);
%     hold on
%     stem(t,sw*1);
%     xlabel("Time [s]")
%     title("Click detection - Detected Clicks")
%     legend("Signal", "sw (clicks)")
% end