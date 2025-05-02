`include "./../definitions.sv"

module bias_memory #(
    parameter data_bits = 16,
    parameter bias_file = "pretrained_bias.mif"
)(
    input logic clk,
    input logic reset,
    input logic write_en,
    input logic read_en,
    input logic [data_bits-1:0] bias_in,
    output logic [data_bits-1:0] bias_out
);

    // Only one bias value stored
    reg [data_bits-1:0] bias_memory;

    // Pretrained mode: load bias from file
    `ifdef pretrained
        initial begin
            $readmemb(bias_file, bias_memory); // Assumes file has just 1 line
        end
    `else
        always @(posedge clk) begin
            if (reset) begin
                bias_memory <= '0;
            end else if (write_en) begin
                bias_memory <= bias_in;
            end
        end
    `endif

    always @(posedge clk) begin
        if (read_en) begin
            bias_out <= bias_memory;
        end
    end

endmodule
