module competition_control(
	input clk,
    input rst,
    input[23:0] sw,
    input[4:0] bt,
    input view,

    output reg[3:0] state

);

always @(rst, view, state, sw) begin

end

endmodule