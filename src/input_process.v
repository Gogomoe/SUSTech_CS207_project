module input_process(
    input clk, rst,
	input[23:0] sw,
    input[4:0] bt,
    input[3:0] row,
    output[3:0] col,
    output[23:0] sw_press,
    output[23:0] sw_edge,
    output[4:0] bt_press,
    output[4:0] bt_edge,
    output[15:0] key_press,
    output[15:0] key_edge
);

button_edge sw_0(clk, sw[0], sw_press[0], sw_edge[0]);
button_edge sw_1(clk, sw[1], sw_press[1], sw_edge[1]);
button_edge sw_2(clk, sw[2], sw_press[2], sw_edge[2]);
button_edge sw_3(clk, sw[3], sw_press[3], sw_edge[3]);
button_edge sw_4(clk, sw[4], sw_press[4], sw_edge[4]);
button_edge sw_5(clk, sw[5], sw_press[5], sw_edge[5]);
button_edge sw_6(clk, sw[6], sw_press[6], sw_edge[6]);
button_edge sw_7(clk, sw[7], sw_press[7], sw_edge[7]);
button_edge sw_8(clk, sw[8], sw_press[8], sw_edge[8]);
button_edge sw_9(clk, sw[9], sw_press[9], sw_edge[9]);
button_edge sw_10(clk, sw[10], sw_press[10], sw_edge[10]);
button_edge sw_11(clk, sw[11], sw_press[11], sw_edge[11]);
button_edge sw_12(clk, sw[12], sw_press[12], sw_edge[12]);
button_edge sw_13(clk, sw[13], sw_press[13], sw_edge[13]);
button_edge sw_14(clk, sw[14], sw_press[14], sw_edge[14]);
button_edge sw_15(clk, sw[15], sw_press[15], sw_edge[15]);
button_edge sw_16(clk, sw[16], sw_press[16], sw_edge[16]);
button_edge sw_17(clk, sw[17], sw_press[17], sw_edge[17]);
button_edge sw_18(clk, sw[18], sw_press[18], sw_edge[18]);
button_edge sw_19(clk, sw[19], sw_press[19], sw_edge[19]);
button_edge sw_20(clk, sw[20], sw_press[20], sw_edge[20]);
button_edge sw_21(clk, sw[21], sw_press[21], sw_edge[21]);
button_edge sw_22(clk, sw[22], sw_press[22], sw_edge[22]);
button_edge sw_23(clk, sw[23], sw_press[23], sw_edge[23]);

button_edge bt_0(clk, bt[0], bt_press[0], bt_edge[0]);
button_edge bt_1(clk, bt[1], bt_press[1], bt_edge[1]);
button_edge bt_2(clk, bt[2], bt_press[2], bt_edge[2]);
button_edge bt_3(clk, bt[3], bt_press[3], bt_edge[3]);
button_edge bt_4(clk, bt[4], bt_press[4], bt_edge[4]);

wire[15:0] key;
key_scanner key_scanner_0(clk, rst, row, col, key);

button_edge key_0(clk, key[0], key_press[0], key_edge[0]);
button_edge key_1(clk, key[1], key_press[1], key_edge[1]);
button_edge key_2(clk, key[2], key_press[2], key_edge[2]);
button_edge key_3(clk, key[3], key_press[3], key_edge[3]);
button_edge key_4(clk, key[4], key_press[4], key_edge[4]);
button_edge key_5(clk, key[5], key_press[5], key_edge[5]);
button_edge key_6(clk, key[6], key_press[6], key_edge[6]);
button_edge key_7(clk, key[7], key_press[7], key_edge[7]);
button_edge key_8(clk, key[8], key_press[8], key_edge[8]);
button_edge key_9(clk, key[9], key_press[9], key_edge[9]);
button_edge key_10(clk, key[10], key_press[10], key_edge[10]);
button_edge key_11(clk, key[11], key_press[11], key_edge[11]);
button_edge key_12(clk, key[12], key_press[12], key_edge[12]);
button_edge key_13(clk, key[13], key_press[13], key_edge[13]);
button_edge key_14(clk, key[14], key_press[14], key_edge[14]);
button_edge key_15(clk, key[15], key_press[15], key_edge[15]);

endmodule