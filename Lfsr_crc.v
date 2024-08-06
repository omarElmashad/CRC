module CRC #(parameter lfsr_width=8 )(
  //input signals
  input wire  data,
  input wire  active,
  input wire  clk,
  input wire  rst,
  //output signals
  output reg  crc,
  output reg  valid
  );

//parameter
parameter [lfsr_width-1 :0] seeds= 'b1101_1000 ;
parameter [lfsr_width-1 :0] taps = 'b0100_0100 ;

//internal signals
reg [3 : 0] 			counter ;
wire 					counter_flag;
reg [lfsr_width-1 :0] 	lfsr;
wire 					fb;

//feed back signal
assign fb= data ^ lfsr[0] ; 
assign counter_flag = | counter ;
// loop variable
integer i ;

always @(posedge clk or negedge rst)
	begin
		//if rst is high assign seeds into flip flops
		if(!rst)
			begin
				lfsr  		 <= seeds ;
				crc   		 <= 1'b0;
				valid 		 <= 1'b0;
				counter 	 <= 4'd8;
			end
			
		//if active is high do operation (data transmission) 
		else if (active)
			begin
			//with for loop 
				lfsr[7] <= fb ;
				for(i=lfsr_width-2 ; i >=0 ; i=i-1 )
					begin
						if (taps[i] )
							begin
								lfsr[i] <= fb ^ lfsr[i+1] ;
							end
						else
							begin
								lfsr[i] <= lfsr[i+1];
							end
					end
			
			/*
			//without for loop
				lfsr[7] <= fb ;
				lfsr[6] <= fb ^ lfsr[7] ;
				lfsr[5] <= lfsr[6];
				lfsr[4] <= lfsr[5];
				lfsr[3] <= lfsr[4];
				lfsr[2] <= fb ^ lfsr[3];
				lfsr[1] <= lfsr[2];
				lfsr[0] <= lfsr[1];
			*/	
			end
		
		else
			begin
				if( counter_flag )
					begin
				valid <= 1'b1 ;	
				counter <= counter -1 ;		
				//third way 
				{ lfsr[lfsr_width-2:0] , crc } <= lfsr ;
					end
				else
					begin
						valid <= 1'b0 ;
					end
				
				
				
				/*
				//with for loop
				crc <= lfsr[0];
				for ( i=0 ; i<lfsr_width-1 ; i=i+1 )
					begin
						lfsr[i] <= lfsr[i+1] ;
					
					end
				//without for loop
				crc  	<= lfsr[0] ;
				lfsr[0] <= lfsr[1] ;
				lfsr[1] <= lfsr[2] ;
				lfsr[2] <= lfsr[3] ;
				lfsr[3] <= lfsr[4] ;
				lfsr[4] <= lfsr[5] ;
				lfsr[5] <= lfsr[6] ;
				lfsr[6] <= lfsr[7] ;
				*/
			
			
			
			
			
			end
	
		
	end

endmodule
