module setting_control(
	input clk,
    input rst,
    input[23:0] sw,
    input[4:0] bt,
    input view,

    output reg[2:0] player_count,
    output reg[3:0] question_count,
    output reg[6:0] answer_time,
    output reg[6:0] win_socre,
    output reg[3:0] success_score,
    output reg[3:0] fail_score,
    output reg[2:0] state
);

always @(rst, view, state, sw) begin
    if(rst) begin
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
            if((state == 0) & sw[21]) begin
                state = 2;
                question_count = sw[7:0];
            end
            if((state == 0) & sw[20]) begin
                state = 3;
                answer_time = sw[7:0];
            end
            if((state == 0) & sw[19]) begin
                state = 4;
                win_socre = sw[7:0];
            end
            if((state == 0) & sw[18]) begin
                state = 5;
                success_score = sw[7:0];
            end
            if((state == 0) & sw[17]) begin
                state = 6;
                fail_score = sw[7:0];
            end
            else if(~sw[22] & ~sw[21] & ~sw[20] & ~sw[19] & ~sw[18] & ~sw[17]) begin
                state = 0;
            end

        end
    end
end

endmodule