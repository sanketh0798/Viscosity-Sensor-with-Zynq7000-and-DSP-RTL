`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2025 01:47:27
// Design Name: 
// Module Name: viscosity
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module viscosity_dsp(
    input wire clk,
    input wire [15:0] sensor_data,  // 16-bit ADC input
    output reg [15:0] pump_ctrl     // Processed output
);
    // DSP48E1 Configuration: P = A*B + C
    wire [29:0] dsp_out;
    
    DSP48E1 #(
        .USE_MULT("MULTIPLY"),
        .USE_SIMD("ONE48")
    ) dsp_inst (
        .CLK(clk),
        .A({14'b0, sensor_data}),  // 30-bit input (zero-padded)
        .B(30'h0000_2000),         // Fixed coefficient (adjust for scaling)
        .C(30'd0),
        .P(dsp_out)
    );
    
    // Post-processing with pipeline registers
    always @(posedge clk) begin
        pump_ctrl <= dsp_out[25:10];  // Scale to 16 bits
    end
endmodule