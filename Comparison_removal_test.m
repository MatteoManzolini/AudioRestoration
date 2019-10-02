clc
close all
clear all

Global_variables_init
plots_bool = 0;


%% First Part (generation of clicks + detection)

Click_model_sig

AR_clickDetection

sample_i = 1;
sw = zeros(length(sig),1);
while sample_i<=length(sig)
    if(abs(click_sig(sample_i))>0.001)
        sw(sample_i:sample_i+20)=1;
        sample_i = sample_i+20;
    else
        sw(sample_i)=0;
        sample_i = sample_i+1;
    end
end

% disp("choice = ");
% disp("1 - AR model based click detection");
% disp("2 - Double Threshold based click detection");
% disp("3 - Template Matching click detection");
% choice = input('Choose the detection algorithm: ');
% 
% switch choice
%    case 1
%         AR_clickDetection
%         
%    case 2
%        DoubleThreshold_clickDetection
%         
%    case 3
%        TemplateMatching_Detection
%        
% end

GapsGenerator

%% Comparison

clc

disp("Adaptive Median Filter")
disp("-----------------------------------")

sig_original = sig;
signalTo48000Hz %Out is: sig(44100), sig_48(48000)
audiowrite('Audio/orig.wav',sig_48,fs);
AdaptiveMedianFilter
signalTo48000Hz
audiowrite('Audio/restored.wav',sig_48,fs);
Removal_Metrics

figure
subplot(3,3,1)
plot(t,sig_original)
title("Adaptive Median Filter")
xlabel("Time [s]")
ylabel("Source Signal")

subplot(3,3,4)
plot(t,sig)
xlabel("Time [s]")
ylabel("Output Signal")

subplot(3,3,7)
plot(t,sig_original-sig,'LineWidth',4)
hold on
plot(t,click_sig,'g')
xlabel("Time [s]")
ylabel("Difference (Source-Output)")
%legend("Difference", "Original Clicks")

disp(" ")
disp(" ")
disp("Weighted Neighbour")
disp("-----------------------------------")

sig = sig_original;
signalTo48000Hz
audiowrite('Audio/orig.wav',sig_48,fs);
WeightedNeighbour
signalTo48000Hz
audiowrite('Audio/restored.wav',sig_48,fs);
Removal_Metrics

subplot(3,3,2)
plot(t,sig_original)
title("Weighted Neighbour")
xlabel("Time [s]")
ylabel("Source Signal")

subplot(3,3,5)
plot(t,sig)
xlabel("Time [s]")
ylabel("Output Signal")

subplot(3,3,8)
plot(t,sig_original-sig,'LineWidth',4)
hold on
plot(t,click_sig,'g')
xlabel("Time [s]")
ylabel("Difference (Source-Output)")
%legend("Difference", "Original Clicks")

disp(" ")
disp(" ")
disp("LSAR")
disp("-----------------------------------")

sig = sig_original;
signalTo48000Hz
audiowrite('Audio/orig.wav',sig_48,fs);
LSAR
signalTo48000Hz
audiowrite('Audio/restored.wav',sig_48,fs);
Removal_Metrics

subplot(3,3,3)
plot(t,sig_original)
title("LSAR")
xlabel("Time [s]")
ylabel("Source Signal")

subplot(3,3,6)
plot(t,sig)
xlabel("Time [s]")
ylabel("Output Signal")

subplot(3,3,9)
plot(t,sig_original-sig,'LineWidth',4)
hold on
plot(t,click_sig,'g')
xlabel("Time [s]")
ylabel("Difference (Source-Output)")
%legend("Difference", "Original Clicks")

linkaxes