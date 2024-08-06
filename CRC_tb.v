//time scale and presicion
`timescale 1ns/1ps

module CRC_tb ();

//loop variable
integer i ;

//paramteres
parameter lfsr_width_tb = 8;
parameter test_case = 10 ;
parameter clk_period = 100;

// 2D memory
reg [lfsr_width_tb-1:0]      in_data_tb 	 [test_case-1 :0];
reg [lfsr_width_tb-1:0]     expected_data_tb [test_case-1 :0];

//internal signals 
//stimulus signals
reg  data_tb, active_tb, clk_tb, rst_tb ;
//monitor signals
wire crc_tb,valid_tb ;

//clock generator
always #(clk_period/2)   clk_tb =~ clk_tb;

//instantiation
CRC #( .lfsr_width(lfsr_width_tb) ) DUT (
.data(data_tb),
.active(active_tb),
.clk(clk_tb),
.rst(rst_tb),
.crc(crc_tb),
.valid(valid_tb)
);

initial 
	begin
		//save waveform
		$dumpfile("crc.vcd");
		$dumpvars();
		
		//read data from files and store it in memeory
		$readmemh("DATA_h.txt",in_data_tb);
		$readmemh("Expec_Out_h.txt",expected_data_tb);
		
		initialization() ;
		for ( i=0 ;i<test_case ; i=i+1)
			begin
				do_operation ( in_data_tb[i] );
				check (expected_data_tb[i],i);
			end
		#(10*clk_period)
		$stop;

end


task initialization ;
	begin
		clk_tb    = 1'b0 ;
		data_tb   = 1'b0 ;
		active_tb = 1'b0 ;
		rst_tb    = 1'b0 ;
	end
endtask

task reset ;
	begin
		rst_tb = 1'b1;
		#clk_period
		rst_tb = 1'b0;
		#clk_period
		rst_tb = 1'b1;
	end

endtask

task do_operation ;
	input [lfsr_width_tb-1 : 0] data_in ;
	begin
		reset ();
		active_tb = 1'b1 ;		
		//without for loop
		data_tb = data_in[0];
		#clk_period
		data_tb = data_in[1];
		#clk_period
		data_tb = data_in[2];
		#clk_period
		data_tb = data_in[3];
		#clk_period
		data_tb = data_in[4];
		#clk_period
		data_tb = data_in[5];
		#clk_period
		data_tb = data_in[6];
		#clk_period
		data_tb = data_in[7];
		#clk_period
		active_tb = 1'b0 ;
		/*
		//with for loop
		for (i=0 ; i<lfsr_width_tb ; i=i+1)
		begin
			data_tb = data_in[i];
			#clk_period			
		end
		*/	
	end
endtask

task check ;
	input [lfsr_width_tb-1 : 0] expected_value ;
	input integer 				test_num ;
	
	reg  [lfsr_width_tb-1:0]    actual_value;
	begin
		@(posedge valid_tb )
		#clk_period
		actual_value[0]= crc_tb ;
		#clk_period
		actual_value[1]= crc_tb ;
		#clk_period
		actual_value[2]= crc_tb ;
		#clk_period
		actual_value[3]= crc_tb ;
		#clk_period
		actual_value[4]= crc_tb ;
		#clk_period
		actual_value[5]= crc_tb ;
		#clk_period
		actual_value[6]= crc_tb ;
		#clk_period
		actual_value[7]= crc_tb ;
		#clk_period
		
		if(actual_value == expected_value)
			begin
			$display ("test case %d is passed actual value is %h and expected value is %h",test_num,actual_value,expected_value);
			end
		else
			begin
		$display ("test case %d is passed actual value is %h and expected value is %h",test_num,actual_value,expected_value);
			end
	
	end

endtask


endmodule















