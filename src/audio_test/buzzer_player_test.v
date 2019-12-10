module buzzer_player_test(
    input clk,
    input[23:0] sw,
    output buzzer
);

wire[23:0] sw_press;
wire[23:0] sw_edge;

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

parameter _4C  = 12'd262;
parameter _4CP = 12'd277;
parameter _4D  = 12'd294;
parameter _4DP = 12'd311;
parameter _4E  = 12'd330;
parameter _4F  = 12'd349;
parameter _4FP = 12'd370;
parameter _4G  = 12'd392;
parameter _4GP = 12'd415;
parameter _4A  = 12'd440;
parameter _4AP = 12'd466;
parameter _4B  = 12'd494;

parameter _5C  = 12'd523;
parameter _5CP = 12'd554;
parameter _5D  = 12'd587;
parameter _5DP = 12'd622;
parameter _5E  = 12'd659;
parameter _5F  = 12'd698;
parameter _5FP = 12'd740;
parameter _5G  = 12'd784;
parameter _5GP = 12'd831;
parameter _5A  = 12'd880;
parameter _5AP = 12'd932;
parameter _5B  = 12'd988;

reg[11:0] hz;
reg[11:0] next_hz;

buzzer_player player(clk, hz, buzzer);

always @(sw_press) begin
    case(sw_press)
        0: next_hz = 0;
        1: next_hz = _4C;
        2: next_hz = _4D;
        4: next_hz = _4E;
        8: next_hz = _4F;
        16: next_hz = _4G;
        32: next_hz = _4A;
        64: next_hz = _4B;
        128: next_hz = _5C;
        256: next_hz = _5D;
        512: next_hz = _5E;
        1024: next_hz = _5F;
        default: next_hz = hz;
    endcase
end

always @(posedge clk) begin
    hz <= next_hz;
end

endmodule