interface write_interface (
	input logic clk); 
	logic write;
	logic [15:0] address,
	logic [7:0] data_in



module write_DUT (
	write_interface write_if
	);
	
	always @(posedge write_if.clk) begin
		if(write_if write)
			for(i=0; i < 6; i++) begin
				my_if.address <= queue[i].address_tb;
				my_if.data_in <= queue[i].data_in_tb;
				$display("Write Address: %h \t Data to write: %h\n", my_if.address, my_if.data_in);
			end
			
		end
	end
endmodule


