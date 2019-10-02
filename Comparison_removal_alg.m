clc
clear all
close all

iii=0;
for iii=1:10
    disp(iii)
    
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

    GapsGenerator

    %% Comparison

    %Adaptive Median Filter
    sig_original = sig;
    signalTo48000Hz
    audiowrite('Audio/orig.wav',sig_48,fs);
    AdaptiveMedianFilter
    signalTo48000Hz
    audiowrite('Audio/restored.wav',sig_48,fs);
    
    metrics_bool = 0;
    Removal_Metrics
    
    orig_mean_mat(iii,1) = orig_mean;
    sig_mean_mat(iii,1) = sig_mean;
    orig_var_mat(iii,1) = orig_var;
    sig_var_mat(iii,1) = sig_var;
    
    rmse_mat(iii,1) = rmse;
    click_diff_mat(iii,1) = click_diff;
    
    ODG_mat(iii,1) = ODG;
    
    eval_mat(iii,1) = evaluation;
    
    
    %Weighted Neighbour
    sig = sig_original;
    signalTo48000Hz
    audiowrite('Audio/orig.wav',sig_48,fs);
    WeightedNeighbour
    signalTo48000Hz
    audiowrite('Audio/restored.wav',sig_48,fs);
    
    metrics_bool = 0;
    Removal_Metrics
    
    orig_mean_mat(iii,2) = orig_mean;
    sig_mean_mat(iii,2) = sig_mean;
    orig_var_mat(iii,2) = orig_var;
    sig_var_mat(iii,2) = sig_var;
    
    rmse_mat(iii,2) = rmse;
    click_diff_mat(iii,2) = click_diff;
    
    ODG_mat(iii,2) = ODG;
    
    eval_mat(iii,2) = evaluation;
    
    
    %LSAR
    sig = sig_original;
    signalTo48000Hz
    audiowrite('Audio/orig.wav',sig_48,fs);
    LSAR
    signalTo48000Hz
    audiowrite('Audio/restored.wav',sig_48,fs);
    
    metrics_bool = 0;
    Removal_Metrics
    
    orig_mean_mat(iii,3) = orig_mean;
    sig_mean_mat(iii,3) = sig_mean;
    orig_var_mat(iii,3) = orig_var;
    sig_var_mat(iii,3) = sig_var;
    
    rmse_mat(iii,3) = rmse;
    click_diff_mat(iii,3) = click_diff;
    
    ODG_mat(iii,3) = ODG;
    
    eval_mat(iii,3) = evaluation;

    linkaxes
end

clc
disp("Adaptive Median Filter")
disp("-----------------------------------")
disp("RMSE: "+mean(rmse_mat(:,1)));
disp("Mean diff with real clicks (Difference-click signal): "+mean(click_diff_mat(:,1)));
disp(" ");
disp("ODG (Objective Difference Grade) [PEAQ]: "+mean(ODG_mat(:,1))+ " ["+eval_mat(iii,1)+" difference]");

disp(" ")
disp(" ")
disp("Weighted Neighbour")
disp("-----------------------------------")
disp("RMSE: "+mean(rmse_mat(:,2)));
disp("Mean diff with real clicks (Difference-click signal): "+mean(click_diff_mat(:,2)));
disp(" ");
disp("ODG (Objective Difference Grade) [PEAQ]: "+mean(ODG_mat(:,2))+ " ["+eval_mat(iii,2)+" difference]");

disp(" ")
disp(" ")
disp("LSAR")
disp("-----------------------------------")
disp("RMSE: "+mean(rmse_mat(:,3)));
disp("Mean diff with real clicks (Difference-click signal): "+mean(click_diff_mat(:,3)));
disp(" ");
disp("ODG (Objective Difference Grade) [PEAQ]: "+mean(ODG_mat(:,3))+ " ["+eval_mat(iii,3)+" difference]");


