`default_nettype none

  interface my_mem_if(
    logic clk, write, read;
    logic [7:0] data_in;
    logic [15:0] address;
    logic [8:0] data_out;
    )

    function logic parity(data_in);
      return(^data_in);
    endfunction
  endinterface


  module my_mem(
		input my_mem_if my_if
);

   // Declare a 9-bit associative array using the logic data type
   //<Put your declaration here>
    logic [8:0] mem_array [int];  
    logic parity_reg; //register to store parity
     
  

   always @(posedge my_if.clk) begin
      if (my_if.write)
        mem_array[my_if.address] = {my_if.parity(^my_if.data_in), my_if.data_in};
       end else if (my_if.read)
        my_if.data_out =  mem_array[my_if.address];
        parity_reg = mem_array [my_if.address];
      end
    end    
  endmodule



