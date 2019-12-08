`timescale 1ns / 1ps

// this module make press button edge

module button_edge(
    input clk,
    input but_in,
    output but_edge
);

wire but_press;
button_jitter jitter(clk, but_in, but_press);

reg [1:0] record = 2'b00;

always @(posedge clk)
    record <= {record[0], but_press};

assign but_edge = record[0] & ~record[1];

endmodule