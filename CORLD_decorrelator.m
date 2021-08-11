
clear;

%_______________________Control parameters____________________
n=7;
k=2^(n);
input_mode=2;   %if 0, the bit-streams are FSM-based, elsif 1 it is sobol-based, otherwise LFSR-based
fix_size1=3;
fix_size2=3;     %fix_size (1 and 2) determines the size of decorrelator
out_base_selector= 2; %output format=> 1=FSM 2=SObol 3=Unary 

Sobol_nums=1111;
p=sobolset(Sobol_nums,'skip',0,'Leap',0);
SDS = net(p,k);
SDS1_fix=SDS(:,1);  %if output format is either FSM or Sobol based, these params determines the type based on chosen sobol numbers
SDS2_fix=SDS(:,1);

%________________________End of control unit___________________

%LFSR outputs
r1=rand(k,1);
r2=rand(k,1);
if n==8
	lfsr_out1=LFSR([0 0 0 0 0 0 0 1], [8 6 5 4], n);	
elseif n==7
	lfsr_out1=LFSR([0 0 0 0 0 0 1], [7 3 2 1], n);	
elseif n==6
	lfsr_out1=LFSR([0 0 0 0 0 1], [6 5 4 1], n);	
end


out_base_fsm=zeros(2^fix_size1,2^fix_size1);
out_base_fsm2=zeros(2^fix_size1,2^fix_size1);
% basic output for proposed FSM
for bs=0:2^fix_size1-1
    for i=1:fix_size1
        base(i)= floor(mod(bs,2^i)/(2^(i-1)));
    end
    
    for i=1:2^fix_size1
        
        step=0;
        for j=1:fix_size1
            step = step + (2^(fix_size1-j))/(2^fix_size1);
            
            if SDS1_fix(i)< step
                out_base_fsm(bs+1,i)=base(fix_size1-j+1);
                break;
            end
            
            if SDS1_fix(i) == ((2^fix_size1)-1)/(2^fix_size1)
                out_base_fsm(bs+1,i)=0;
            end
        end
    end
    
end
% basic output 2 for proposed FSM
for bs=0:2^fix_size2-1
    
    for i=1:fix_size2
        base(i)= floor(mod(bs,2^i)/(2^(i-1)));
    end
    for shift_index=0:k/2^fix_size2
        SDS2_fix_shifted=circshift(SDS2_fix,shift_index);
        
        for i=1:2^fix_size2
            
            step=0;
            for j=1:fix_size2
                step = step + (2^(fix_size2-j))/(2^fix_size2);
                
                if SDS2_fix_shifted(i)< step
                    out_base_fsm2(bs+1,i,shift_index+1)=base(fix_size2-j+1);
                    break;
                end
                
                if SDS2_fix_shifted(i) == ((2^fix_size2)-1)/(2^fix_size2)
                    out_base_fsm2(bs+1,i,shift_index+1)=0;
                end
            end
        end
    end
end



% basic output format for Sobol
for bs=0:2^fix_size1-1
    for j=1:2^fix_size1
        out_base_sobol(bs+1,j) = bs/2^fix_size1 > SDS1_fix(j);
    end
    
end


% basic output2 format for Sobol
for bs=0:2^fix_size2-1
    for shift_index=0:k/2^fix_size2
        SDS2_fix_shifted=circshift(SDS2_fix,shift_index);
        for j=1:2^fix_size2
            out_base_sobol2(bs+1,j,shift_index+1) = bs/2^fix_size2 > SDS2_fix_shifted(j);
        end
    end
end

% basic output format for Unary
for bs=0:2^fix_size2-1
    for j=1:2^fix_size2
        out_base_unary(bs+1,j) = bs > j-1;
    end
    
end

if out_base_selector==1
    out_base = out_base_fsm;
    out_base2 = out_base_fsm2;
elseif out_base_selector==2
    out_base = out_base_sobol;
    out_base2 = out_base_sobol2;
elseif out_base_selector==3
    out_base = out_base_unary;
    out_base2 = out_base_unary;
end

%SDS_num=3;
 for SDS_num=1:1    
    if input_mode==2
        SDS1=lfsr_out1;
        SDS2=lfsr_out1;
    else
        SDS1=SDS(:,SDS_num); %if input is Sobol or FSM based, these are sobol numbers that inputs are generated based on them
        SDS2=SDS(:,SDS_num);
    end


    
    
   for aa=0:2^n-1
      for bb=0:2^n-1
%             aa=31;
%             bb=51;

                for i=1:n
                   A(i)= floor(mod(aa,2^i)/(2^(i-1)));
                end

                for i=1:n
                   B(i)= floor(mod(bb,2^i)/(2^(i-1)));
                end


                out1=zeros(k,1);
                out1al=zeros(k,1);
                out2=zeros(k,1);

                Mulres=zeros(k,1);


                outs1=zeros(k,1);
                outs2=zeros(k,1);

                SobolMulres=zeros(k,1);



                if input_mode~=0
                    out1=(aa/(2^n))>SDS1;
                    out2=(bb/(2^n))>SDS2; 
                    out_my1=out1;
                    out_my2=out2;
                else

                        for i=1:k 

                            step=0;
                            for j=1:n

                                step = step + (2^(n-j))/(2^n);

                                if SDS1(i)< step 
                                    out1(i)=A(n-j+1);
                                    out1al(i) = n-j+1;
                                    break;
                                end

                                if SDS1(i) == ((2^n)-1)/(2^n)
                                    out1(i)=0;
                                    out1al(i) = n;
                                end
                            end

                        end





                        for i=1:k 

                            step=0;
                            for j=1:n

                                step = step + (2^(n-j))/(2^n);

                                if SDS2(i)< step 
                                    out2(i)=B(n-j+1);
                                    break;
                                end

                                if SDS2(i) == ((2^n)-1)/(2^n)
                                    out2(i)=0;
                                end
                            end

                        end
                end

                % Original SCC
                a=0;
                b=0;
                c=0;
                d=0;

                for i=1:k
                    if out1(i)==1 && out2(i)==1
                        a=a+1;
                    elseif out1(i)==1 && out2(i)==0
                        b=b+1;
                    elseif out1(i)==0 && out2(i)==1
                        c=c+1;
                    elseif out1(i)==0 && out2(i)==0
                        d=d+1;
                    end
                end

                if a*d > b*c
                    SCC_original(aa+1,bb+1)= (a*d-b*c)/(k*min(a+b,a+c) - (a+b)*(a+c));
                else
                    SCC_original(aa+1,bb+1)= (a*d-b*c)/((a+b)*(a+c) - k*max(a-d,0));
                end
                if isnan(SCC_original(aa+1,bb+1))
                    SCC_original(aa+1,bb+1)=0;
                end



                % Correlation manipulation techique
                flag=0;            
                out_cm_2=out2;
                for i=1:k                
                    if out1(i)==1 && out2(i)==0 && flag==0
                        out_cm_1(i,1)=0;
                        flag=1;
                    elseif  out1(i)==0 && out2(i)==1 && flag==1
                        out_cm_1(i,1)=1;
                        flag=0;
                    else
                        out_cm_1(i,1)=out1(i);
                    end


                end


                %pack
                flag=0;
                if fix_size1 ~= 0
                    for pack_index=1:k/2^fix_size1           
                        sum_index=sum(out1((pack_index-1)*(2^fix_size1)+1:pack_index*(2^fix_size1)))+1;
                        flag=0;
                            if sum_index>2^fix_size1
                                flag=1;                            
                            end

                        if flag==1
                                flag=0;
                        else
                            for fixer_index=1:2^fix_size1                                                                                                 
                                out1((pack_index-1)*(2^fix_size1)+fixer_index) = out_base(sum_index,fixer_index); 
                            end
                        end
                    end
                end

                flag=0;
                if fix_size2 ~= 0
                    for pack_index=1:k/2^fix_size2           
                        sum_index=sum(out2((pack_index-1)*(2^fix_size2)+1:pack_index*(2^fix_size2)))+1;
                        flag=0;
                            if sum_index>2^fix_size2
                                flag=1;                            
                            end

                        if flag==1
                                flag=0;
                        else
                            for fixer_index=1:2^fix_size2                                                                                                 
                                out2((pack_index-1)*(2^fix_size2)+fixer_index) = out_base2(sum_index,fixer_index,pack_index); 
                            end
                        end
                    end
                end


                Mulres=out1 & out2;
                result(aa+1,bb+1)=sum(Mulres)/k;



                outs1=(aa/(2^n))>SDS1;
                outs2=(bb/(2^n))>SDS2;

                %Mulres_sobol
                %sum(Mulres_sobol)
                flag=0;
                if fix_size1 ~= 0
                    for pack_index=1:k/2^fix_size1
                        mul_sum_index=sum(outs1((pack_index-1)*(2^fix_size1)+1:pack_index*(2^fix_size1)))+1;
                        flag=0;
                        if mul_sum_index>2^fix_size1
                            flag=1;
                        end

                        if flag==1
                            flag=0;
                        else
                            for fixer_index=1:2^fix_size1
                                outs1((pack_index-1)*(2^fix_size1)+fixer_index) = out_base(mul_sum_index,fixer_index);
                            end
                        end
                    end
                end

                flag=0;
                if fix_size2 ~= 0
                    for pack_index=1:k/2^fix_size2
                        mul_sum_index=sum(outs2((pack_index-1)*(2^fix_size2)+1:pack_index*(2^fix_size2)))+1;
                        flag=0;
                        if mul_sum_index>2^fix_size2
                            flag=1;
                        end

                        if flag==1
                            flag=0;
                        else
                            for fixer_index=1:2^fix_size2
                                outs2((pack_index-1)*(2^fix_size2)+fixer_index) = out_base2(mul_sum_index,fixer_index,pack_index);
                            end
                        end
                    end
                end

                 Mulres_sobol = outs1 & outs2;



                resultsobol(aa+1,bb+1)=sum(outs1&outs2)/k;
                resultoriginal_mp(aa+1,bb+1)=(aa*bb)/(2^(2*n));


                if aa < bb
                    resultoriginal(aa+1,bb+1)=aa/k;
                else
                    resultoriginal(aa+1,bb+1)=bb/k;
                end

                %SCC calculation for my proposed method

                a=0;
                b=0;
                c=0;
                d=0;

                for i=1:k
                    if out1(i)==1 && out2(i)==1
                        a=a+1;
                    elseif out1(i)==1 && out2(i)==0
                        b=b+1;
                    elseif out1(i)==0 && out2(i)==1
                        c=c+1;
                    elseif out1(i)==0 && out2(i)==0
                        d=d+1;
                    end
                end

                if a*d > b*c
                    SCC(aa+1,bb+1)= (a*d-b*c)/(k*min(a+b,a+c) - (a+b)*(a+c));
                else
                    SCC(aa+1,bb+1)= (a*d-b*c)/((a+b)*(a+c) - k*max(a-d,0));
                end
                if isnan(SCC(aa+1,bb+1))
                    SCC(aa+1,bb+1)=0;
                end
                %SCC calculation for correlation manipulation
                a=0;
                b=0;
                c=0;
                d=0;

                for i=1:k
                    if out_cm_1(i)==1 && out_cm_2(i)==1
                        a=a+1;
                    elseif out_cm_1(i)==1 && out_cm_2(i)==0
                        b=b+1;
                    elseif out_cm_1(i)==0 && out_cm_2(i)==1
                        c=c+1;
                    elseif out_cm_1(i)==0 && out_cm_2(i)==0
                        d=d+1;
                    end
                end

                if a*d > b*c
                    SCC_cm(aa+1,bb+1)= (a*d-b*c)/(k*min(a+b,a+c) - (a+b)*(a+c));
                else
                    SCC_cm(aa+1,bb+1)= (a*d-b*c)/((a+b)*(a+c) - k*max(a-d,0));
                end
                if isnan(SCC_cm(aa+1,bb+1))
                    SCC_cm(aa+1,bb+1)=0;
                end
       end
    end

    % SCC_cm(2,2)=0;
    SCC_avg=mean(mean(SCC(2:2^n,2:2^n)));
    %SCC_avg_cm=mean(mean(SCC_cm(2:k,2:k)));
    SCC_avg_original=mean(mean(SCC_original(2:2^n,2:2^n)));
    %  
    errorsobol_min_mean=mean(mean(abs(resultoriginal-resultsobol)));
    errorsobol_mp_mean=mean(mean(abs(resultoriginal_mp-resultsobol)));
    errorsobol_mp_max=max(max(abs(resultoriginal_mp-resultsobol)));

    error_min_mean=mean(mean(abs(resultoriginal-result)));
    error_min_max=max(max(abs(resultoriginal-result)));
    error_mp_mean=mean(mean(abs(resultoriginal_mp-result)));
    error_mp_max=max(max(abs(resultoriginal_mp-result)));
    
    
    SCC_final(SDS_num)=SCC_avg;
    error_final(SDS_num)=error_mp_mean;
 end

SCC_final_min=min(SCC_final);
error_final_min=min(error_final);
SCC_final_avg=mean(SCC_final);
error_final_avg=mean(error_final);