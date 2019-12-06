module button_process_test(
	input clk,
	input[7:0] bt,
	output reg[23:0] led
);

wire[15:0] button;

button_process buttonps(bt, button);

always @(button) begin
    led[15:0] = button;
end

always @(posedge button[1]) begin
    led[23] <= ~led[23];
end

endmodule