module bias_memory_control #(
    parameter data_bits = 16,
    parameter bias_file = "pretrained_bias.mif",
    parameter layer_no = 0,
    parameter neuron_no = 0
)(
    input logic clk,
    input logic reset,

    // Writing parameters
    input logic bias_valid,                 // for the validity of the bias input
    input logic [31:0] bias_value,          // the value of the bias
    input logic [31:0] config_layer_no,     
    input logic [31:0] config_neuron_no,

    // Reading parameters
    input logic neuron_in_valid,            // the neuron input valid switch 
    input logic output_valid,               // the neuron output valid switch

    output logic [data_bits-1:0] bias_out
);

    // Internal control signals
    logic write_en;                         // enables the memory write
    logic read_en;                          // enables reading from the memory
    logic [data_bits-1:0] bias_in;          // the input bias (16-bit) verion

    // be carefull that we are still padding the bias values for uniformity within the neuron
    // the useful data is only 16 bits long

    `ifndef pretrained
        always_ff @(posedge clk) begin
            if (reset) begin
                write_en <= 0;
            end
            else if (bias_valid && config_layer_no == layer_no && config_neuron_no == neuron_no) begin
                bias_in <= bias_value[data_bits-1:0];
                write_en <= 1;
            end
            else begin
                write_en <= 0;
            end
        end
    `else
        always_ff @(posedge clk) begin
            write_en <= 0;
        end
    `endif

    // Read enable toggles only when neuron input is valid
    assign read_en = neuron_in_valid;

    // Instantiating bias_memory
    bias_memory #(
        .data_bits(data_bits),
        .bias_file(bias_file)
    ) bm_inst (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .bias_in(bias_in),
        .bias_out(bias_out)
    );

endmodule
