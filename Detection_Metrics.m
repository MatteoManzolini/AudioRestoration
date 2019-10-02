%% Metrics

% MDR: Missing Detection Rate
% FDR: False Detection Rate


%Find True Positives
rclick_positions = clicks_pos+1;
TP = 0;
tp_index = 1;
for gap_index=1:length(gaps)
    for rclick_index=1:length(rclick_positions)
        if rclick_positions(rclick_index)>=gaps(gap_index,1) && rclick_positions(rclick_index)<=gaps(gap_index,2) %If the gap contain a real click
            TP(tp_index,1)= rclick_positions(rclick_index);
            TP(tp_index,2)= gap_index;
            tp_index = tp_index+1;
        end
    end    
end

%Find False Negatives
FN = setdiff(rclick_positions,TP(:,1));

%Find False Positives
gaps_FP = gaps;
gaps_FP(TP(:,2),:) = []; %Remove True Positives
FP = gaps_FP(:,1);


% MDR
%....................
MDR = length(FN)/length(rclick_positions)*100; %numero di quelli mancati sul totale dei click effettivi (veri)
if metrics_bool == 1
    disp("MDR: "+MDR+"%");
end 

%FDR
%....................
FDR = length(FP)/length(gaps)*100; % numero di quelli in più (trovati ma non c'erano) rispetto al totale dei click trovati (gaps)
if metrics_bool == 1
    disp("FDR: "+FDR+"%");
end

