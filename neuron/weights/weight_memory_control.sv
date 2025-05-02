module weight_memory_control #(
    data_bits = 16,             // the data width, in this case 16 bits
    num_weights = 784,            // number of weights (i have a doubt in this one for now but let's just go with this one now)
    weight_file = "pretrained_weights.mif",

    layer_no = 0,
    neuron_no = 0

    

) (
    input logic clk, 
    input logic reset, 

    // input parameters for writing weight values
    input logic weight_valid,           //  checks if the weight is valid or not
    input logic [31:0] weight_value,  
    input logic [31:0] config_layer_no,      
    input logic [31:0] config_neuron_no, 

    // input parameters for reading weight values
    input logic neuron_in_valid,        // validity of the neuron's input
    input logic output_valid,           // validity of the neuron's output

    output logic [data_bits-1:0] weight_out
);

        parameter address_bits = $clog2(num_weights);         // the address width

        logic write_en;                             // intermediate value for write enable
        
        logic [address_bits-1:0] write_add;         // the write address

        logic [data_bits - 1:0] weight_in_16bit;    // this is very critical, the actual weight value is 16 bits long only, but weight_value above is 32 bits
                                                    // because all the weights are padded up to become 32 bits long

        logic read_en;                              // intermediate value for read enable
        
        logic [address_bits-1:0] read_add;


        `ifndef pretrained                          // calling out the ptretrained parameter here helps the unecessary toggling of the write enable
            always @(posedge clk)
            begin
                if (reset) begin
                    write_add <= {address_bits{1'b1}};
                    write_en <= 0;
                end

                else if(weight_valid & (config_layer_no == layer_no) & (config_neuron_no == neuron_no))
                begin
                    weight_in_16bit <= weight_value[data_bits-1:0];
                    write_add <= write_add + 1;
                    write_en <= 1;
                end

                else
                    write_en <= 0;

                
            end

    `else                                         // avoiding toggling in the case of pretrained model
        always @(posedge clk)
        begin
            write_en <= 0;
            write_add <= {address_bits{1'b1}};
        end
    `endif



    assign read_en = neuron_in_valid;           // giving a valid input is a good enough toggle

    always @(posedge clk)
        begin
            if (reset|output_valid) begin       // resets the read address in both cases when the reset is toggled or the output is valid
                read_add <= 0;
            end

            else if (neuron_in_valid) begin
                read_add <= read_add +1;        // increments the read address when the input is valid
            end
        end


    // instantiating the weight memory module

    weight_memory #(.data_bits(data_bits), .num_weights(num_weights), .address_bits(address_bits), .weight_file(weight_file))
                                         weight_mem_inst (.clk(clk), .reset(reset), .write_en(write_en), .read_en(read_en), .write_add(write_add), .read_add(read_add),
                                          .weight_in(weight_in_16bit), .weight_out(weight_out));


endmodule