module music_player(
    input clk,
    input rst,
    output[23:0] led,
    output buzzer
);

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

parameter NO_VOICE = 12'd0;

parameter slice = 200;

parameter sect_count = 8'd17;

wire ms_clk;
clk_div #(100_000) ms_clk_inst(clk, rst, ms_clk);

reg[11:0] cnt;
wire ms_edge;
edge_gen ms_edge_inst(clk, ms_clk, ms_edge);

reg play_end;
reg[11:0] slices;

assign led[11:0] = slices;

always @(posedge clk) begin
    if(rst) begin
        cnt <= 0;
        slices <= 0;
        play_end <= 0;
    end
    else begin
        if(play_end == 0) begin
            if(ms_edge) begin

                if(cnt == slice) begin
                    cnt <= 0;

                    if(slices == {sect_count, 4'b0000}) begin
                        play_end <= 1;
                    end
                    else begin
                        slices <= slices + 1;
                    end
                end
                else begin
                    cnt <= cnt + 1;
                end

            end
        end
    end
end

reg[11:0] hz;
reg[11:0] next_hz;

buzzer_player player(clk, hz, buzzer);

always @(*) begin
    if(rst == 0 && play_end == 0) begin
        case(slices)
            12'h010: next_hz = _4D;
            12'h012: next_hz = _4A;
            12'h013: next_hz = _4G;
            12'h014: next_hz = _4A;
            12'h016: next_hz = _5C;
            12'h018: next_hz = _5D;
            12'h01C: next_hz = NO_VOICE;

            12'h020: next_hz = _4D;
            12'h022: next_hz = _4A;
            12'h023: next_hz = _4G;
            12'h024: next_hz = _4A;
            12'h026: next_hz = _5C;
            12'h028: next_hz = _5D;
            12'h02C: next_hz = NO_VOICE;

            12'h030: next_hz = _4D;
            12'h032: next_hz = _4A;
            12'h033: next_hz = _4G;
            12'h034: next_hz = _4A;
            12'h036: next_hz = _5C;
            12'h038: next_hz = _5D;
            12'h03C: next_hz = _4A;
            12'h03E: next_hz = _5E;
            12'h040: next_hz = _5F;
            12'h042: next_hz = _4A;
            12'h044: next_hz = _5E;
            12'h046: next_hz = _4G;
            12'h048: next_hz = _5D;
            12'h04C: next_hz = NO_VOICE;

            12'h050: next_hz = _4D;
            12'h052: next_hz = _4A;
            12'h053: next_hz = _4G;
            12'h054: next_hz = _4A;
            12'h056: next_hz = _5C;
            12'h058: next_hz = _5D;
            12'h05C: next_hz = NO_VOICE;

            12'h060: next_hz = _4D;
            12'h062: next_hz = _4A;
            12'h063: next_hz = _4G;
            12'h064: next_hz = _4A;
            12'h066: next_hz = _5C;
            12'h068: next_hz = _5D;
            12'h06C: next_hz = NO_VOICE;

            12'h070: next_hz = _4D;
            12'h072: next_hz = _4A;
            12'h073: next_hz = _4G;
            12'h074: next_hz = _4A;
            12'h076: next_hz = _5C;
            12'h078: next_hz = _5D;
            12'h080: next_hz = NO_VOICE;

            12'h08C: next_hz = _4D;
            12'h08E: next_hz = _4F;
            12'h090: next_hz = _4G;
            12'h094: next_hz = _4A;
            12'h098: next_hz = _4D;
            12'h09B: next_hz = NO_VOICE;
            12'h09C: next_hz = _4D;
            12'h09E: next_hz = _4F;
            12'h0A0: next_hz = _4G;
            12'h0A4: next_hz = _4A;
            12'h0A8: next_hz = _4D;
            12'h0AB: next_hz = NO_VOICE;
            12'h0AC: next_hz = _4D;
            12'h0AE: next_hz = _4F;
            12'h0B0: next_hz = _4G;
            12'h0B4: next_hz = _4A;
            12'h0B8: next_hz = _5C;
            12'h0BA: next_hz = _4A;
            12'h0BC: next_hz = _4G;
            12'h0BE: next_hz = _4A;
            12'h0C0: next_hz = _4G;
            12'h0C2: next_hz = _4A;
            12'h0C4: next_hz = _4G;
            12'h0C6: next_hz = _4A;
            12'h0C8: next_hz = _4D;
            12'h0CB: next_hz = NO_VOICE;

            12'h0CC: next_hz = _4D;
            12'h0CE: next_hz = _4F;
            12'h0D0: next_hz = _4G;
            12'h0D4: next_hz = _4A;
            12'h0D8: next_hz = _4D;
            12'h0DB: next_hz = NO_VOICE;
            12'h0DC: next_hz = _4D;
            12'h0DE: next_hz = _4F;
            12'h0E0: next_hz = _4G;
            12'h0E4: next_hz = _4A;
            12'h0E8: next_hz = _4E;
            12'h0EC: next_hz = _4F;
            12'h0EE: next_hz = _4C;
            12'h0F0: next_hz = _4D;
            12'h0F8: next_hz = NO_VOICE;

            default: next_hz = hz;
        endcase
    end else begin
        next_hz = NO_VOICE;
    end
end

always @(posedge clk) begin
    if(rst) begin
        hz <= 12'b0;
    end else begin
        hz <= next_hz;
    end
end

endmodule