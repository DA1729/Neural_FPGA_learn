module neuron #(
    data_bits = 16,             // the data width, in this case 16 bits
    num_weights = 784,          // number of weights (i have a doubt in this one for now but let's just go with this one now)
    weight_file = "pretrained_weights.mif",

    layer_no = 0,               // layer number
    neuron_no = 0,              // neuron number

) (
    input logic clk,
    input logic reset,
    input logic weight_valid,                               // tells us if the weight is valid or not
    input logic [31:0] weight_value,                        // value of the weight (but why is it different from the data width)
    input logic [31:0] config_layer_no,
    input logic [31:0] config_neuron_no
);

parameter address_bits = $clog2(num_weights);       // the address width for the weight memory


always @(posedge clk)
begin
    if (weight_valid & (config_layer_no == layer_no) & (config_neuron_no == neuron_no))
    begin
        
    end
end
    // stopping writing here for now, as I decided to make another module for weight memory control
    // this module will only integrate all the solid and control modules
    //////////////////////////////////////////////////////////////////
endmodule