%% Generation of the gaps vector
%  -------------------------------------------------------------------------------------

Global_variables_init

%% Generation of gaps
% ...................

i=1;
gaps = 0;
index = 1;
while i<=length(sw)
    if sw(i)==1
        j=0;
        while i+j<=length(sw) && sw(i+j)==1
            firstSample = i;
            j = j+1;
        end
        lastSample = i+j-1;
        gaps(index,1)= firstSample;
        gaps(index,2)= lastSample;
        index = index+1;
        i=lastSample;
    end
    i = i+1;
end


%% Remove errors at the boundaries of the signal && Remove too high gaps
% ......................................................................

currGap = 1;
while currGap<=size(gaps,1)
    %
    if (gaps(currGap,1)<boundaries_threshold || gaps(currGap,2)>length(sig)-boundaries_threshold) || (gaps(currGap,2)-gaps(currGap,1)>maxPossibleGapLength) 
        sw(gaps(currGap,1):gaps(currGap,2))=0; %reset sw (needed for median filter)
        gaps(currGap,:) = []; %Remove gap
    else
        currGap = currGap+1;
    end
end


%% 


%% Final plot of clicks that will be removed

if plots_bool==1
    figure(6);
    clf
    plot(t, sig);
    hold on
    stem(t,sw*1);
    xlabel("Time [s]")
    title("Click detection - Clicks to be removed")
    legend("Signal", "sw (clicks)")
end


%% Gaps parameters
% ................

gapLengths = gaps(:,2)-gaps(:,1);
meanGapLength = mean(gapLengths);
maxGapLength = max(gapLengths);
maxGapIndex = find(gaps(:,2)-gaps(:,1)==maxGapLength);
maxGap = gaps(maxGapIndex,:);
maxGapSeconds = maxGap/fs;

% singleSampleGaps =  <<<<<<<<---- add this feature for analysis

