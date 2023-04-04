module tb();

reg clk, write, read;
reg [7:0] data_in_tb;
reg [15:0] address_tb;
wire [8:0] data_out_tb;
reg [8:0] data_temp;


typedef struct{
	reg [7:0] data_in_tb; // data to write 
	reg [15:0] address_tb; //address to read/write
	reg [8:0] data_expected; //expected data read 
	reg [8:0] data_read; // Actual Data to read 
} transactions;


my_mem dl (.clk(clk),
				.write(write),
				.read(read),
				.data_in(data_in_tb),
				.address(address_tb),
				.data_out(data_out_tb)
				);

transactions transaction_array [6];
transactions transaction;
transactions queue[$];


//logic [8:0] expected_array [int], index =1;

always #5 clk = ~clk;

int i,Error_count;

initial begin
//transaction_array = new[6];
	clk = 0;
	read=0;
	write =0;
	$vcdpluson;
	$dumpfile("dump.vcd");
	$dumpvars;

	@(posedge clk);

//Generate random addresses and data 
	for (i=0; i<6; i= i+1) begin
		transaction_array[i].address_tb = $random();
		transaction_array[i].data_in_tb = $random();
		transaction_array[i].data_expected = {^transaction_array[i].data_in_tb, transaction_array[i].data_in_tb};

	end

	#5;
	$display ("TransactionArray: %p\n",transaction_array);



//Shuffle

	for (i=0; i<6; i=i+1) begin
		transaction =transaction_array[i];
		$display("Transaction: %d \t %p",i,transaction);
		queue.push_back(transaction);
	end
	$display("Queue before shuffle: %p\n",queue);
	queue.shuffle();
	$display("Queue after shuffle: %p\n",queue);

	#5;


//Write
	@(posedge clk);
	write <= 1;
	for(i=0; i < 6; i++) begin
		address_tb <= queue[i].address_tb;
		data_in_tb <= queue[i].data_in_tb;

		@(posedge clk);
		$display("Write Address: %h \t Data to write: %h\n", address_tb, data_in_tb);
	end
#5;
//Read 
	
read <= 1;
write <= 0;
//@(posedge clk);

i = 0;
do begin
    @(negedge clk);

    address_tb <= queue[i].address_tb; 
    data_temp <= data_out_tb[queue[i].address_tb];
    @(negedge clk); 
    checkoutput(data_out_tb, queue[i].data_expected);
    $display("Read Address: %h \t Data to read: %h\n", address_tb, data_out_tb);

    i = i + 1;
end while (i < 6);

#5;
$finish;
end

task checkoutput (input logic [8:0] data_out_tb, data_expected);
	begin
		if (data_out_tb == data_expected) begin
			$display ("success"); end
			else begin
				$display ("Error");
				Error_count = Error_count +1;
			end
		end
$display("Error_count: ",Error_count);
endtask



endmodule