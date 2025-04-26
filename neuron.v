`timescale 1ns/1ps

`include "include.v"

module neuron #(
    parameter
    layerNo = 0, neuronNo = 0, numWeight = 784, dataWidth = 16, sigmoidSize = 5, weightIntWidth = 1, actType = "relu", biasFile = "", weightFile = "")
) (
    input                   clk, 
    input                   rst,
    input [dataWidth-1:0]   myinput,
    input                   myinputValid,
    input                   weightValid,
    input                   biasValid,
    input [31:0]            weightValue,
    input [31:0]            biasValue,
    input [31:0]            config_layer_num,
    input [31:0]            config_neuron_num,
    output[dataWidth-1:0]   out,
    output reg              outvalid   
);



    
endmodule