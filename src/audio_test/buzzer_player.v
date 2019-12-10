module buzzer_player(
    input clk,
    input[11:0] hz,
    output reg buzzer
);

reg[31:0] cnt;
reg[15:0] last_hz;

reg[31:0] reach;

always @(posedge clk) begin

    last_hz <= hz;

    if(hz != 0)
        reach <= 32'd100_000_000 / hz;
    else
        reach <= 32'hFFFFFFFF;

    if(hz != 0) begin
        if(cnt == (reach >> 1) - 1) begin
            cnt <= 0;
            buzzer <= ~buzzer;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
    else if(hz == 0 || last_hz != hz) begin
        cnt <= 0;
    end

end

endmodule