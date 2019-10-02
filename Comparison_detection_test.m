clc
close all
clear all

Global_variables_init

plots_bool = 0;
Click_model_sig


%% 
plots_bool = 0;

disp("AR click detection")
disp("-----------------------------------")

AR_clickDetection
GapsGenerator

Detection_Metrics

figure
subplot(3,1,1)
plot(t,sig)
hold on
stem(t,sw)
title("AR model based - click detection")
xlabel("Time [s]")


%% 

plots_bool=0;

disp(" ")
disp("AR double threshold click detection")
disp("-----------------------------------")

DoubleThreshold_clickDetection
GapsGenerator

Detection_Metrics

subplot(3,1,2)
plot(t,sig)
hold on
stem(t,sw)
title("AR Double Threshold - click detection")
xlabel("Time [s]")



%% 

plots_bool=0;

disp(" ")
disp("Template matching click detection")
disp("-----------------------------------")

TemplateMatching_Detection
GapsGenerator

Detection_Metrics

subplot(3,1,3)
plot(t,sig)
hold on
stem(t,sw)
title("Template matching - click detection")
xlabel("Time [s]")

linkaxes





