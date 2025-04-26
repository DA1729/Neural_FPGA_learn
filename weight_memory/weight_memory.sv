`include "./../definitions.sv"


module weight_memory #(
    data_bits = 16,             // the data width, in this case 16 bits
    num_weights = 3,            // number of weights (i have a doubt in this one for now but let's just go with this one now)
    address_bits = 10,          // no way to address with 9 bits lol
    weight_file = "pretrained_weights.mif"
) (
    input logic clk,                             // ofc the clock  
    input logic reset,
    input logic write_en,                        // to write the data
    input logic read_en,                         // to read the data
    input logic [address_bits-1:0] write_add,    // address to write in 
    input logic [address_bits-1:0] read_add,     // address to read from 
    input logic [data_bits-1:0] weight_in,       // input value of the weight
    output logic [data_bits-1:0] weight_out      // output value of the weight from the memory

);

        reg [data_bits - 1:0] memory[num_weights-1:0];      // the main block of the module, the register file

        // the following block reads from the memory initialization file with values of the weights if we have a pretrained model and already have the necessary weight values
        // works as a ROM in the first case
        `ifdef pretrained
            initial begin
                $readmemb(weight_file, mem); 
            end
        `else       // else read the weight input and write in the given address, basically function as a RAM 


            always @(posedge clk)
                // check for reset switch, if reset is on, initialize all the weight values to 0
                if (reset)
                begin
                    integer i;
                    for (i = 0; i < num_weights; i = i + 1) begin
                        memory[i] <= '0;
                    end

            begin
                if (write_en) begin
                    memory[write_add] <= weight_in;
                end

                end
            end

        `endif 


        // reading scheme
        always @(posedge clk)
        begin
            if (read_en)
            begin
                weight_out <= memory[read_add];
            end

            else
            begin
                weight_out <= 16'b0;        // assigns 0 if read is not enabled
            end 
        end
        
    
endmodule