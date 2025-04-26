`timescale 1ns / 1ps

module tb_viscosity_system();

// Parameters
parameter CLK_PERIOD = 10;  // 100 MHz clock (10 ns period)

// Signals
reg clk;
reg resetn;
reg [15:0] sensor_data;
wire [15:0] pump_ctrl;

// Instantiate DUT (viscosity_dsp module)
viscosity_dsp dut (
    .clk(clk),
    .sensor_data(sensor_data),
    .pump_ctrl(pump_ctrl)
);

// Clock generation
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

// Reset and stimulus
initial begin
    // Initialize
    resetn = 0;
    sensor_data = 16'h0000;
    
    // Release reset
    #100 resetn = 1;
    
    // Test Case 1: Normal viscosity (mid-range)
    sensor_data = 16'h4000;
    #200;
    
    // Test Case 2: High viscosity
    sensor_data = 16'hC000;
    #200;
    
    // Test Case 3: Low viscosity
    sensor_data = 16'h1000;
    #200;
    
    // Test Case 4: Step response
    for (integer i=0; i<16; i=i+1) begin
        sensor_data = i << 12;
        #50;
    end
    
    // End simulation
    #100;
    $finish;
end

// Monitor results
initial begin
    $timeformat(-9, 2, " ns", 10);
    $monitor("At time %t: Sensor=0x%h Pump_Ctrl=0x%h", 
             $time, sensor_data, pump_ctrl);
end

endmodule
