%% LSAR interpolator
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
        xK = [xKL; xKR];

        %Computation of the rearrangement matrices
        U = zeros(length(xU)+length(xK),length(xU));
        for c1=m+1:m+length(xU)
            U(c1,c1-m)=1;
        end
        K = zeros(length(xU)+length(xK),length(xK));
        for c2=1:m
            K(c2,c2)=1;
        end
        for c3=m+length(xU)+1:length(xU)+length(xK)
            K(c3,c3-length(xU))=1;
        end

        %x = U*xU+K*xK; %recontruction of the signal

        %Computation of the A matrix a_mat
        a_mat = zeros(blockLength-p, blockLength);
        for row=1:blockLength-p
            for column=row:p+row-1
                a_mat(row,column)=-1*a(end-(column-row));
            end

            for column=p+row:blockLength
                if column==p+row
                    a_mat(row,column)= 1;
                else
                    a_mat(row,column)= 0;
                end
            end

            for column=1:row-1
            a_mat(row,column)=0;
            end
        end

        a_matU = a_mat*U;
        a_matK = a_mat*K;

        %Computation of the unknown data
        xU_min = -1*((a_matU'*a_matU)\(a_matU'*a_matK*xK));

        %Substitution of the computed data in the signal (Reconstruction)
        sig(gapFirstSample:gapLastSample) = xU_min;
    end    
end