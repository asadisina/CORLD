
clear;
%_______________________Control parameters____________________
n=6;
k=2^(n);
input_mode=0;   %if 0, the bit-streams are FSM-based, elsif 1 it is sobol-based, otherwise LFSR-based
fix_size=3;     %fix_size determines the size of correlator
out_base_selector= 2; %output format=> 1=FSM 2=SObol 3=Unary 

Sobol_nums=100;
p=sobolset(Sobol_nums,'skip',0,'Leap',0);
SDS = net(p,k);
SDS_input1=3;   %if input is Sobol or FSM based, these are sobol numbers that inputs are generated based on them
SDS_input2=7;
SDS1_fix=SDS(:,1);  %if output format is either FSM or Sobol based, these params determines the type based on chosen sobol numbers
SDS2_fix=SDS(:,1);

cm_depth=2;     % depth of correlation manipulation (cm) technique
cm_after=0;     % if 1=> cm after proposed CORLD is activated
%________________________End of control unit___________________


r1=rand(k,1);
r2=rand(k,1);
if n==8
	lfsr_out1=LFSR([0 0 0 0 0 0 0 1], [8 6 5 4], n);
	lfsr_out2=LFSR([0 0 0 0 0 0 0 1], [8 6 5 2], n);
elseif n==7
	lfsr_out1=LFSR([0 0 0 0 0 0 1], [7 3 2 1], n);
	lfsr_out2=LFSR([0 0 0 0 0 0 1], [7 5 3 1], n);
elseif n==6
	lfsr_out1=LFSR([0 0 0 0 0 1], [6 5 4 1], n);
	lfsr_out2=LFSR([0 0 0 0 0 1], [6 4 3 1], n);
end

if input_mode==2        
        SDS1=lfsr_out1; 
        SDS2=lfsr_out2;     
else
    SDS1=SDS(:,SDS_input1);
    SDS2=SDS(:,SDS_input2);
end

% basic output for proposed FSM
for bs=0:2^fix_size-1
            for i=1:fix_size
               base(i)= floor(mod(bs,2^i)/(2^(i-1)));
            end
            
            for i=1:2^fix_size 
                
                    step=0;
                    for j=1:fix_size
                        step = step + (2^(fix_size-j))/(2^fix_size);

                        if SDS1_fix(i)< step 
                            out_base_fsm(bs+1,i)=base(fix_size-j+1);                        
                            break;
                        end

                        if SDS1_fix(i) == ((2^fix_size)-1)/(2^fix_size)
                            out_base_fsm(bs+1,i)=0;                      
                        end
                    end                
            end

end   
% basic output 2 for proposed FSM
for bs=0:2^fix_size-1
            for i=1:fix_size
               base(i)= floor(mod(bs,2^i)/(2^(i-1)));
            end
            
            for i=1:2^fix_size 
                
                    step=0;
                    for j=1:fix_size
                        step = step + (2^(fix_size-j))/(2^fix_size);

                        if SDS2_fix(i)< step 
                            out_base_fsm2(bs+1,i)=base(fix_size-j+1);                        
                            break;
                        end

                        if SDS2_fix(i) == ((2^fix_size)-1)/(2^fix_size)
                            out_base_fsm2(bs+1,i)=0;                      
                        end
                    end                
            end

end   



% basic output format for Sobol
for bs=0:2^fix_size-1
           for j=1:2^fix_size
                out_base_sobol(bs+1,j) = bs/2^fix_size > SDS1_fix(j);  
           end

end 

% basic output2 format for Sobol
for bs=0:2^fix_size-1
           for j=1:2^fix_size
                out_base_sobol2(bs+1,j) = bs/2^fix_size > SDS2_fix(j);  
           end

end

% basic output format for Unary
for bs=0:2^fix_size-1
           for j=1:2^fix_size
                out_base_unary(bs+1,j) = bs > j-1;  
           end

end 

if out_base_selector==1
    out_base = out_base_fsm;
    out_base2 = out_base_fsm;
elseif out_base_selector==2
    out_base = out_base_sobol;
    out_base2 = out_base_sobol2;
elseif out_base_selector==3
    out_base = out_base_unary;
    out_base2 = out_base_unary;
end
% for run=1:50
%      SDS1=rand(k,1); 
%         SDS2=rand(k,1); 
for aa=0:2^n-1
   for bb=0:2^n-1
         
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
            [out_cm_1,out_cm_2]=CM(k,cm_depth,out1,out2);                        
            result_cm(aa+1,bb+1)=sum(out_cm_1 & out_cm_2)/k;
            result_cm_xor(aa+1,bb+1)=sum(xor(out_cm_1,out_cm_2))/k;
            result_cm_max(aa+1,bb+1)=sum(out_cm_1 | out_cm_2)/k;
            %out1=out_cm_1;
            %out2=out_cm_2;
            %pack
            %out_temp=out1;
            flag=0;
            if fix_size ~= 0
                for pack_index=1:k/2^fix_size           
                    sum_index=sum(out1((pack_index-1)*(2^fix_size)+1:pack_index*(2^fix_size)))+1;
                    flag=0;
                        if sum_index>2^fix_size
                            flag=1;                            
                        end

                    if flag==1
                            flag=0;
                    else
                        for fixer_index=1:2^fix_size                                                                                                 
                            out1((pack_index-1)*(2^fix_size)+fixer_index) = out_base(sum_index,fixer_index); 
                        end
                    end
                end
            end
            
            flag=0;
            if fix_size ~= 0
                for pack_index=1:k/2^fix_size           
                    sum_index=sum(out2((pack_index-1)*(2^fix_size)+1:pack_index*(2^fix_size)))+1;
                    flag=0;
                        if sum_index>2^fix_size
                            flag=1;                            
                        end

                    if flag==1
                            flag=0;
                    else
                        for fixer_index=1:2^fix_size                                                                                                 
                            out2((pack_index-1)*(2^fix_size)+fixer_index) = out_base2(sum_index,fixer_index); 
                        end
                    end
                end
            end
             % Correlation manipulation techique
             if cm_after==1
                   [out_cm_1,out_cm_2]=CM(k,cm_depth,out1,out2);
                    out1=out_cm_1;
                    out2=out_cm_2;
             end
            
            Mulres=out1 & out2;
            
            
            Mulresult((aa)*k+bb+1,1:k)=Mulres;            
            MulresultIndex((aa)*k+bb+1,1) = aa;
            MulresultIndex((aa)*k+bb+1,2) = bb;
            
   
            
            
            result(aa+1,bb+1)=sum(Mulres)/k;
            result_xor(aa+1,bb+1)=sum(xor(out1,out2))/k;
            result_max(aa+1,bb+1)=sum(out1 | out2)/k;
            
           
            
            outs1=(aa/(2^n))>SDS1;
            outs2=(bb/(2^n))>SDS2;
            
            %Mulres_sobol
            %sum(Mulres_sobol)
            flag=0;
            if fix_size ~= 0
                for pack_index=1:k/2^fix_size
                    mul_sum_index=sum(outs1((pack_index-1)*(2^fix_size)+1:pack_index*(2^fix_size)))+1;
                    flag=0;
                    if mul_sum_index>2^fix_size
                        flag=1;
                    end
                    
                    if flag==1
                        flag=0;
                    else
                        for fixer_index=1:2^fix_size
                            outs1((pack_index-1)*(2^fix_size)+fixer_index) = out_base(mul_sum_index,fixer_index);
                        end
                    end
                end
            end
            flag=0;
            if fix_size ~= 0
                for pack_index=1:k/2^fix_size
                    mul_sum_index=sum(outs2((pack_index-1)*(2^fix_size)+1:pack_index*(2^fix_size)))+1;
                    flag=0;
                    if mul_sum_index>2^fix_size
                        flag=1;
                    end
                    
                    if flag==1
                        flag=0;
                    else
                        for fixer_index=1:2^fix_size
                            outs2((pack_index-1)*(2^fix_size)+fixer_index) = out_base2(mul_sum_index,fixer_index);
                        end
                    end
                end
            end
            
             % Correlation manipulation techique
             if cm_after==1
                   [out_cm_1,out_cm_2]=CM(k,cm_depth,out1,out2); 
                    outs1=out_cm_1;
                    outs2=out_cm_2;
             end
            Mulres_sobol = outs1 & outs2;
            
                        
            resultsobol(aa+1,bb+1)=sum(Mulres_sobol)/k;
            resultsobol_xor(aa+1,bb+1)=sum(xor(outs1,outs2))/k;
            resultsobol_max(aa+1,bb+1)=sum(outs1 | outs2)/k;

            resultoriginal_mp(aa+1,bb+1)=(aa*bb)/(2^(2*n));
            resultoriginal_xor(aa+1,bb+1)=abs(aa-bb)/(2^n);
           
            if aa < bb
                resultoriginal(aa+1,bb+1)=aa/k;
            else
                resultoriginal(aa+1,bb+1)=bb/k;
            end

            if aa > bb
                resultoriginal_max(aa+1,bb+1)=aa/k;
            else
                resultoriginal_max(aa+1,bb+1)=bb/k;
            end
            
            %SCC calculation for my proposed method on FSM
            
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
            
            %SCC calculation my proposed method on Sobol
            
            a=0;
            b=0;
            c=0;
            d=0;
            
            for i=1:k
                if outs1(i)==1 && outs2(i)==1
                    a=a+1;
                elseif outs1(i)==1 && outs2(i)==0
                    b=b+1;
                elseif outs1(i)==0 && outs2(i)==1
                    c=c+1;
                elseif outs1(i)==0 && outs2(i)==0
                    d=d+1;
                end
            end
            
            if a*d > b*c
                SCC_sobol(aa+1,bb+1)= (a*d-b*c)/(k*min(a+b,a+c) - (a+b)*(a+c));
            else
                SCC_sobol(aa+1,bb+1)= (a*d-b*c)/((a+b)*(a+c) - k*max(a-d,0));
            end
            if isnan(SCC_sobol(aa+1,bb+1))
                SCC_sobol(aa+1,bb+1)=0;
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

SCC_cm(2,2)=0;
SCC_avg_fsm=mean(mean(SCC(2:2^n,2:2^n)));
SCC_avg_sobol=mean(mean(SCC_sobol(2:2^n,2:2^n)));
SCC_avg_cm=mean(mean(SCC_cm(2:2^n,2:2^n)));
SCC_avg_original=mean(mean(SCC_original(2:2^n,2:2^n)));
 


errorsobol_min_mean=mean(mean(abs(resultoriginal-resultsobol)));
errorsobol_max_mean=mean(mean(abs(resultoriginal_max-resultsobol_max)));
errorsobol_mp_mean=mean(mean(abs(resultoriginal_mp-resultsobol)));
errorsobol_mp_max=max(max(abs(resultoriginal_mp-resultsobol)));
errorsobol_xor_mean=mean(mean(abs(resultoriginal_xor-resultsobol_xor)));

errorfsm_min_mean=mean(mean(abs(resultoriginal-result)));
errorfsm_max_mean=mean(mean(abs(resultoriginal_max-result_max)));
errorfsm_min_max=max(max(abs(resultoriginal-result)));
errorfsm_mp_mean=mean(mean(abs(resultoriginal_mp-result)));
errorfsm_mp_max=max(max(abs(resultoriginal_mp-result)));
errorfsm_xor_mean=mean(mean(abs(resultoriginal_xor-result_xor)));

error_cm_min_mean=mean(mean(abs(resultoriginal-result_cm)));
error_cm_max_mean=mean(mean(abs(resultoriginal_max-result_cm_max)));
error_cm_min_max=max(max(abs(resultoriginal-result_cm)));
error_cm_xor_mean=mean(mean(abs(resultoriginal_xor-result_cm_xor)));

% SCC_run(run)=SCC_avg_original;
% SCC_sobol_run(run)=SCC_avg_sobol;
% SCC_cm_run(run)=SCC_avg_cm;
% 
% error_cm_min(run)=error_cm_min_mean;
% error_cm_max(run)=error_cm_max_mean;
% 
% error_sobol_min(run)=errorsobol_min_mean;
% error_sobol_max(run)=errorsobol_max_mean;
% 
% 
% 
% end
% 
% final_error_cm_min=mean(error_cm_min);
% final_error_cm_max=mean(error_cm_max);
% 
% final_error_sobol_min=mean(error_sobol_min);
% final_error_sobol_max=mean(error_sobol_max);
% 
% final_SCC=mean(SCC_run);
% final_SCC_sobol=mean(SCC_sobol_run);
% final_SCC_cm=mean(SCC_cm_run);
