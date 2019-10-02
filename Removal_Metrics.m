%% Metrics

%Means
orig_mean=mean(sig_original);
sig_mean=mean(sig);


%Vars
orig_var=var(sig_original);
sig_var=var(sig);


%Root mean squared error
rmse = mean((sig_original-sig).^2);

%MAD - Median Absolute Deviation
mad = max(abs(sig-median(sig)));

%Mean Difference with click signal
click_diff = mean(abs((sig_original-sig)-click_sig));


%PEAQ (Perceptual Evaluation of Audio Quality)

StartS = 48000+1;
EndS   = 21*48000;

ODG   = PQevalAudio ('Audio/orig.wav', 'Audio/restored.wav', StartS, EndS);
%Commented fprintf s in Misc/PQwavFilePar.m
%Commented line 46,119,145,146 in PQevalAudio.m
evaluation = "BOOH";
if ODG>=-1
    evaluation="Imperceptible";
elseif ODG>=-2 && ODG<-1
    evaluation="Almost imperceptible";
elseif ODG>=-3 && ODG<-2
    evaluation="Slightly perceptible";
elseif ODG>=-4 && ODG<-3
    evaluation="Perceptible";
else
    evaluation="Very perceptible";
end



if metrics_bool == 1
%     disp("Signals' mean values: ");
%     disp("    Original: " +orig_mean);
%     disp("    Restored: " +sig_mean);
%     disp("Signals' variances: ");
%     disp("    Original: " +orig_var);
%     disp("    Restored: " +sig_var);
%    disp(" ");
    disp("RMSE: "+rmse);
%     disp("MAD: "+mad);
    disp(" ");
    disp("Mean diff with real clicks (Difference-click signal): "+click_diff);
    disp(" ");
    disp("ODG (Objective Difference Grade) [PEAQ]: "+ODG + " ["+evaluation+" difference]");
end 