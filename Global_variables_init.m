p = 12; %Order of the AR parameters model

boundaries_threshold = 70; %Gaps at the boundaries

k = 3; %Detection threshold with sigma (3-sigma rule)

plots_bool = 0; %Plots

init_blockLength = 70; %LSAR

maxPossibleGapLength = 50; %Maximum admitted click length in samples

metrics_bool = 1; %disp of metrics

L_sec = 2; %s

numberOfClicks = 20;

music_name = 'Audio/Morandi.mp3';

%Available sources
% Hot_fives.wav <<-- Jazz
% Muss.wav <<-- Orchestral
% Morandi.mp3 <<-- with beats

%Others
% Dipper.wav