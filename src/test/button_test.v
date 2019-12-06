module button_test(
	input clk,
	input rst,
	input[4:0] bt,
	output reg[23:0] led
);

always @(bt) begin
    led[4:0] = bt;
end

always @(posedge rst, posedge bt[0]) begin
    if(rst)
        led[23] = 24'b0;
    else
        led[23] = ~led[23];
end


endmodule