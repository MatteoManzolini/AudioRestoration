%% Adaptive Median Filter
%  ------------------------------------------------------------------------------------

sig_old = sig;
range_default = 2; %Basic range for the window win at each side
cart = 0;

%Loop on all the gaps found
for currGap=1:size(gaps,1)
    
   gapLength = gaps(currGap,2)-gaps(currGap,1)+1;
   cart_length = (gapLength*2)+1;

   
   %% "Classic" adaptive median filter (just change length of the cart depending on the gap length)
   % ..............................................................................................
   
   if gapLength<=3
       range = gapLength-1+range_default;
       win = sig((gaps(currGap,1)-range):(gaps(currGap,2)+range))';
       win_w = win;
       
       for j=1:length(win)
           cart_temp = 0;
           
           if j<=gapLength
              cart_temp(1:gapLength+1-j)=win(1);
              cart = [cart_temp,win(1:j+gapLength)];
           else
               if j+gapLength>length(win)
                  cart_temp(1:j-length(win)+gapLength)=win(end);
                  cart = [win(j-gapLength:end),cart_temp];
               else
                  cart = win(j-gapLength:j+gapLength);
               end
           end
           
           win_w(j) = median(cart);
       end
       
       sig((gaps(currGap,1)-range):(gaps(currGap,2)+range)) = win_w';
   end
   
   
   %% "Alternative" adaptive median filter (choose a different median when the gap is too high)
   % ..........................................................................................
   
   if gapLength>3 && gapLength<30
       
       %Initialize and take the partitions of sig and sw
       range = gapLength-1+range_default;
       win = sig((gaps(currGap,1)-range):(gaps(currGap,2)+range))';
       sw_win = sw((gaps(currGap,1)-range):(gaps(currGap,2)+range))';
       win_w = win;
       %cart_length = 7;
       
       %Cart length change dependently on the maximum exploitable
%        if mod(gapLength,2)==0
%            cart_length = gapLength+7;
%        else
%            cart_length = gapLength+6;
%        end
       
       
       for j=1:length(win)
           
           %Create the cart
           cart_temp = 0;
           if j<=(cart_length-1)/2
              cart_temp(1:(cart_length-1)/2+1-j)=win(1);
              sw_cart_temp(1:(cart_length-1)/2+1-j)=sw_win(1);
              cart = [cart_temp,win(1:j+(cart_length-1)/2)];
              sw_cart = [sw_cart_temp,sw_win(1:j+(cart_length-1)/2)];
           else
               if j+(cart_length-1)/2>length(win)
                  cart_temp(1:j-length(win)+(cart_length-1)/2)=win(end);
                  sw_cart_temp(1:j-length(sw_win)+(cart_length-1)/2)=sw_win(end);
                  cart = [win(j-(cart_length-1)/2:end),cart_temp];
                  sw_cart = [sw_win(j-(cart_length-1)/2:end),sw_cart_temp];
               else
                  cart = win(j-(cart_length-1)/2:j+(cart_length-1)/2);
                  sw_cart = sw_win(j-(cart_length-1)/2:j+(cart_length-1)/2);
               end
           end
           
           %Compute the median
           m = median(cart); 
           median_index = find(cart==m); %Find the index of the median in the original cart
           if sw_cart(median_index)==1 %If the median is a click, find the first value less than the median that is not a click
               i=((cart_length+1)/2)+1; %Start always from the median+1 (the cart is sorted, no need to start from beginning)
               found=0;
               new_m = 0;
               cart_sort = sort(cart,'descend');
               while i<=cart_length && found==0
                   new_m = cart_sort(i);  %if every sample is a click in the window new_m will be the smallest sample of the cart
                   found=0;                   
                   if sw_cart(find(cart==new_m))==0 %Check on the sw if ALL the values ==new_m are not clicks, just in that case the value is found
                       found=1;
                   end
                   i = i+1;
               end
               win_w(j) = new_m;
           else
               win_w(j) = m; %As before: write median in win_w and then write on the signal
           end
           
       end
       sig((gaps(currGap,1)-range):(gaps(currGap,2)+range)) = win_w';
   end
end