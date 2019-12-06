`timescale 1ns / 1ps

module input_process_tb();

reg clk, power;
reg[23:0] sw;
reg[7:0] bt;
wire[23:0] switch;
wire[15:0] button;
input_process inst(clk, power, sw, bt, switch, button);

initial fork
    clk <= 0;
    power <= 0;
    sw <= 24'h0;
    bt <= 8'h0;

    #5 power <= 1;
    #100000 sw <= 24'h100000;

    #12000000 sw <= 24'h0;
    #13000000 $finish;

    forever #1 clk = ~ clk;

join

endmodule