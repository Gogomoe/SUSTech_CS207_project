module alert_player(
    input clk, rst, set,
    output buzzer
);

parameter hz = 12'd440;
parameter length = 12'd400;

wire ms_clk, ms_edge;
clk_div #(100_000) ms_clk_inst(clk, rst, ms_clk);
edge_gen ms_edge_gen_inst(clk, ms_clk, ms_edge);

reg[11:0] cnt;
reg[11:0] play_hz;
reg playing;

buzzer_player player_inst(clk, play_hz, buzzer);

always @(posedge clk) begin
    if(rst) begin
        cnt <= 0;
        play_hz <= 0;
        playing <= 0;
    end
    else if(set) begin
        cnt <= 0;
        play_hz <= hz;
        playing <= 1;
    end
    else if(playing && ms_edge) begin
        if(cnt == length) begin
            cnt <= 0;
            play_hz <= 0;
            playing <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule