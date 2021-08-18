function [out_cm_1,out_cm_2]=CM(k,deep_size,x1,x2)
     DP=2*(deep_size);
     state=DP/2;
     out_cm_1=x1;
     out_cm_2=x2;
         for i=1:k
             if x1(i)==1 && x2(i)==0 && (0<state) && (state<=DP/2)
                 out_cm_1(i,1)=0;
                 state=state-1;     
             elseif  x1(i)==0 && x2(i)==1 && (DP/2<=state) && (state<DP)
                 out_cm_2(i,1)=0;
                 state=state+1;
             elseif x1(i)==0 && x2(i)==1 && (0<=state) && (state<DP/2)
                 out_cm_1(i,1)=1;
                 state=state+1;
             elseif x1(i)==1 && x2(i)==0 && (DP/2<state) && (state<=DP)
                 out_cm_2(i,1)=1;
                 state=state-1;         

             end
         end     

end