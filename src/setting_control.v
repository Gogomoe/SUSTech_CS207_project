module setting_control(
	input clk,
    input rst,
    input[23:0] sw,
    input[4:0] bt,

    output reg[2:0] player_count,
    output reg[3:0] question_count,
    output reg[6:0] answer_time,
    output reg[6:0] win_socre,
    output reg[3:0] success_score,
    output reg[3:0] fail_score,
    output reg[2:0] view,
    output reg[2:0] state
);

always @(rst, view, state, sw) begin
    if(rst) begin
        view = 0;
        state = 0;
        player_count = 2;
        question_count = 5;
        answer_time = 10;
        win_socre = 3;
        success_score = 1;
        fail_score = 1;
    end else begin
        if(view == 0) begin
            if((state == 0) & sw[22]) begin
                state = 1;
                player_count = sw[7:0];
            end
            else if(~sw[22] & ~sw[21] & ~sw[20] & ~sw[19] & ~sw[18]) begin
                state = 0;
            end

        end else if(view == 1) begin

        end
    end
end

endmodule