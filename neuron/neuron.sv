`include "./../definitions.sv"                          // importing the definitions module
`include "./../weight_memory/weight_memory.sv"          // the weight memory module
`include "./../weight_memory/weight_memory_control.sv"  // the weight memory control


module neuron #(
    data_bits = 16,             // the data width, in this case 16 bits
    num_weights = 784,          // number of weights (i have a doubt in this one for now but let's just go with this one now)
    address_bits = 10,          // no way to address with 9 bits lol
    layer_no = 0,
    neuron_no = 0

) (
    ports
);
    
endmodule