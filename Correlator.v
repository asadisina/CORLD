//-----------------------------------------------------
// Design Name :Correlator block
// Function    : 
// Coder       : Sina
//-----------------------------------------------------

module Correlator  #(parameter width=5)  (clk, rst, Input1, out1);
	
    input clk,rst;
	input Input1;
	output reg out1;
	
	reg[width:0]  counter;
	reg[width:0]  register1;
	reg[width-1:0]  counter_sob;
	reg enable;
	
	
	wire [width-1:0] rev_counter_sob;
	genvar i;
	generate
		for (i=0; i<width; i=i+1) begin: somename
			assign 	rev_counter_sob[i]=counter_sob[width-1-i];
		end
	endgenerate
	
always @(posedge clk, posedge rst) begin 
   if (rst) begin       
	  counter = 0; 
	  counter_sob = 0;
	  enable=0;	  
	  register1=0;
   end 
   else begin  
		
     	if(Input1==1 & counter_sob!=0 )
			counter=counter+1;						
		else if (counter_sob==0) begin
			register1=counter;
			enable=1;
			counter_sob=0;
			if (Input1==0)
				counter=0;
			else
				counter=1;
		end
		if(enable) begin
			
			if (rev_counter_sob< register1)
				out1=1;
			else
				out1=0;
		end
		counter_sob=counter_sob+1;
		
		
	
  end
end
		
endmodule