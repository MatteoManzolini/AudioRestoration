%% Weighted Neighbour interpolator
%  -------------------------------------------------------------------------------------

for currGap=1:length(gaps)
    
    blockLength = init_blockLength;
    %Set first and last sample of the considered gap
    gapFirstSample = gaps(currGap,1);
    gapLastSample = gaps(currGap,2);
    
    if blockLength>=(gapLastSample-gapFirstSample+1)
                
        m = round((blockLength-(gapLastSample-gapFirstSample+1))/2); %Samples to the left-right of the gap
        blockLength = 2*m +(gapLastSample-gapFirstSample+1); %Needed for even length gaps

        %Partition of the datablock (computed as 2m+length of the gap)
        xU = sig(gapFirstSample:gapLastSample); %Unknown part
        xKL = sig(gapFirstSample-m:gapFirstSample-1); %Known part to the left
        xKR = sig(gapLastSample+1:gapLastSample+m); %Known part to the right

        %1 - Computation of the AR parameters of xKL and xKR
        aKL = arburg(xKL,p);
        aKL(1) = [];
        aKL=-aKL';
        
        aKR = arburg(xKR,p);
        aKR(1) = [];
        aKR=-aKR';
        
        %2 - Estimation of the unknown part from the left/from the right
        xU_est_L = zeros(length(xU),1);
        for n=1:length(xU)
            sum = 0;
            for i=1:p
                sum = sum + aKL(i)*sig(gapFirstSample-m+n-i-1);
%                 if n>=i
%                     sum = sum + aKL(i)*xU(n-i+1);
%                 end
            end
            xU_est_L(n) = sum;
        end
        
        xU_est_R = zeros(length(xU),1);
        for n=1:length(xU)
            sum = 0;
            for i=1:p
                sum = sum + aKL(i)*sig(gapLastSample+n+i-1);
%                 if n+i-1<=length(xU)
%                     sum = sum + aKR(i)*xU(n+i-1);
%                 end
            end
            xU_est_R(n) = sum;
        end
        
        a_par = 1;
        w_func = zeros(length(xU),1);
        xU_min = zeros(length(xU),1);
        
        for n=1:length(xU)
            u_par = (n-1)/(length(xU)-1);
            
            if u_par<=1/2
                w_func(n) = 1-((1/2)*(2*u_par)^a_par);
            else
                w_func(n) = (1/2)*(2-2*u_par)^a_par;
            end
        
            xU_min(n) = (w_func(n)*xU_est_L(n)) + ((1-w_func(n))*xU_est_R(n));
        end
                

        %Substitution of the computed data in the signal (Reconstruction)
        sig(gapFirstSample:gapLastSample) = xU_min;
    end    
end