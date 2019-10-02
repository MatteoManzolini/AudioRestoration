clc
clear all
close all

iii=0;
for iii=1:10
    disp(iii)
    
    Global_variables_init

    Click_model_sig

    
    
    plots_bool = 0;

    AR_clickDetection
    GapsGenerator

    metrics_bool = 0;
    Detection_Metrics
    
    MDR_vect(iii,1)=MDR;
    FDR_vect(iii,1)=FDR;
    
    
    
    plots_bool=0;

    DoubleThreshold_clickDetection
    GapsGenerator

    metrics_bool = 0;
    Detection_Metrics
    
    MDR_vect(iii,2)=MDR;
    FDR_vect(iii,2)=FDR;
    
    
    
    plots_bool=0;

    TemplateMatching_Detection
    GapsGenerator

    metrics_bool = 0;
    Detection_Metrics
    
    MDR_vect(iii,3)=MDR;
    FDR_vect(iii,3)=FDR;
    
    
    
    linkaxes
end

disp(" ")
disp("AR model based - click detection")
disp("-----------------------------------")
disp("MDR: "+mean(MDR_vect(:,1))+"%");
disp("FDR: "+mean(FDR_vect(:,1))+"%");

disp(" ")
disp("AR double threshold click detection")
disp("-----------------------------------")
disp("MDR: "+mean(MDR_vect(:,2))+"%");
disp("FDR: "+mean(FDR_vect(:,2))+"%");

disp(" ")
disp("Template Matching click detection")
disp("-----------------------------------")
disp("MDR: "+mean(MDR_vect(:,3))+"%");
disp("FDR: "+mean(FDR_vect(:,3))+"%");