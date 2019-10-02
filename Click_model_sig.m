
Global_variables_init


%% Generation of the click signal

fs=44100;
amp_min = 0.5;
amp_max = 1;

clicks = zeros(fs*L_sec,1);
clicks_pos = zeros(numberOfClicks,1); %Position of the clicks

for i=1:numberOfClicks
    clicks_pos(i) = randi(length(clicks)-boundaries_threshold*2,1,1)+boundaries_threshold; %Save position of the clicks in a vector
    
    polarity = [-1,1]; %Random choose of the click sign
    sign_ = randi(length(polarity),1);
    click_sign = polarity(sign_);
    clicks(clicks_pos(i)) = (amp_min + (amp_max-amp_min).*rand)*click_sign;
end

clicks_pos = sort(clicks_pos);


t = 0:1/fs:(length(clicks)-1)/fs;


if plots_bool==1
    figure(1)
    subplot(3,1,1)
    stem(t,clicks)
    hold on;
    stem(clicks_pos,ones(length(clicks_pos)));
    xlim([0,L_sec])
end


%Click Shape function
fnx = @(t,f) sin(2*pi*f*t).*exp(-3*f*abs(t));
h =fnx(t,5000);


t = 0:1/fs:(length(h)-1)/fs;

if plots_bool==1
    subplot(3,1,2)
    plot(t,h)
    xlim([-0.004,0.005]);
    ylim([-0.2,0.6]);
end


%Generation of the click signal
click_sig = filter(h,1,clicks);

t = 0:1/fs:(length(click_sig)-1)/fs;

if plots_bool==1
    subplot(3,1,3)
    plot(t, click_sig)
    xlim([0,L_sec])
end


if plots_bool==1
    figure(3)
    subplot(2,1,1)
    stem(t,clicks)
    hold on;
    stem(clicks_pos,ones(length(clicks_pos)));
    xlim([0,L_sec])
end



h = h(1:20); %Needed for TemplateMatching_Detection

%% Additive: white noise/music + clicks

[music,fs] = audioread(music_name);
sig = music((3*fs)+1:5*fs,1);

%sig = wgn(1,length(click_sig),-30);

sig = sig' + click_sig';

% figure(2)
% t = 0:1/fs:(length(sig)-1)/fs;
% plot(t,sig);

sig = sig'; %Make signal from row vector to column vector


%% Substitutive: white noise/music with substitution of clicks

%sig = wgn(1,length(click_sig),-30);
% 
% [music,fs] = audioread('../Audio_sources/test2_GT_muss_l.wav');
% sig = music((3*fs)+1:5*fs);
% 
% for pos=1:length(clicks_pos)
%     sig(clicks_pos(pos):clicks_pos(pos)+18) = click_sig(clicks_pos(pos):clicks_pos(pos)+18);
% end
% 
% subplot(2,1,2);
% t = 0:1/fs:(length(sig)-1)/fs;
% plot(t,sig);

