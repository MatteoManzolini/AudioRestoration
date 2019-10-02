% SASP Project
% Authors: Federico Simeon, Matteo Manzolini
% Date: 19/08/19

clear all
close all
clc

Global_variables_init

%% 1 - Generation of the signal: clicks added to an audio signal
Click_model_sig

%% 2 - Clicks detection

disp("choice = ");
disp("1 - AR model based click detection");
disp("2 - Double Threshold based click detection");
disp("3 - Template Matching click detection");
choice = input('Choose the detection algorithm: ');

switch choice
   case 1
        AR_clickDetection
        
   case 2
       DoubleThreshold_clickDetection
        
   case 3
       TemplateMatching_Detection
       
end

GapsGenerator

%% 3 - Clicks removal

disp(" ");
disp("choice = ");
disp("1 - Adaptive Median Filter");
disp("2 - Weighted Neighbour");
disp("3 - LSAR");
choice = input('Choose the restoration algorithm: ');

figure
plot(t,sig)
title("Pre-restoration")
ylim([-1,1])

switch choice
   case 1
        AdaptiveMedianFilter
        
   case 2
        WeightedNeighbour
        
   case 3
        LSAR
       
end

figure
plot(t,sig)
title("Post-restoration")
ylim([-1,1])



