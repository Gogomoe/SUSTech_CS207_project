module music_player_test(
    input clk,
    input rst,
    output[23:0] led,
    output buzzer
);

music_player music_inst(clk, rst, led, buzzer);

endmodule