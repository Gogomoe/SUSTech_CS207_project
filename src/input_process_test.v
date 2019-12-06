module input_process_test(
	input clk,
	input power,
	input[23:0] sw,
	input[7:0] bt,
	output reg[23:0] led
);

wire[23:0] switch;
wire[15:0] button;
input_process inpro(clk, power, sw, bt, switch, button);

always @(switch) begin
	led = switch;
end


endmodule