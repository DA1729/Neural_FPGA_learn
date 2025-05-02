`include "./../weights/weight_memory_control.sv"
`include "./../definitions.sv"

module weight_multiplication #(
    parameter data_bits = 16,             // the data width (e.g., 16 bits)
    parameter num_weights = 784,          // number of weights (adjust as needed)
    parameter weight_file = "pretrained_weights.mif",
    parameter layer_no = 0,
    parameter neuron_no = 0
) (
    input  logic clk,
    input  logic reset,

    input  logic [data_bits-1:0] neuron_input,
    input  logic neuron_in_valid,         // Should be tied to the input valid signal
    input  logic output_valid,            // Signals when a neuron finishes computation

    output logic [data_bits*2 - 1:0] mul_out // Output of multiplication
);

    logic [data_bits-1:0] weight_out;

    // Instantiate the weight memory controller
    weight_memory_control #(
        .data_bits(data_bits),
        .num_weights(num_weights),
        .weight_file(weight_file),
        .layer_no(layer_no),
        .neuron_no(neuron_no)
    ) weight_ctrl_inst (
        .clk(clk),
        .reset(reset),
        .weight_valid(1'b0),              // Not writing in this module
        .weight_value(32'd0),
        .config_layer_no(32'd0),
        .config_neuron_no(32'd0),
        .neuron_in_valid(neuron_in_valid),
        .output_valid(output_valid),
        .weight_out(weight_out)
    );

    logic [data_bits-1:0] neuron_input_reg;

    always @(posedge clk or posedge reset) begin
        if (reset)
            neuron_input_reg <= '0;
        else if (neuron_in_valid)
            neuron_input_reg <= neuron_input;
    end

    always @(posedge clk) begin
        mul_out <= $signed(neuron_input_reg) * $signed(weight_out);
    end

endmodule
