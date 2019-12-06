module competition_view(
	input clk,
    input rst,
    input [2:0] view,
    input [3:0] state,

	output[7:0] seg_out,
	output[7:0] seg_en,
	output reg[23:0] led,
	output reg buzzer
);

reg[7:0] i0, i1, i2, i3, i4, i5, i6, i7;
seg_tube seg_inst(clk, i0, i1, i2, i3, i4, i5, i6, i7, seg_out, seg_en);

reg[3:0] bcd1_i;
wire[7:0] bcd1_o;
bcd_seg bcd_1(bcd1_i, bcd1_o);

parameter NOSHOW = 8'b11111111;

always @(
    view, state
    ) begin

    if(view == 1) begin

        i0 = 8'b11000110;

        bcd1_i = state;
        i1 = bcd1_o;

        i2 = NOSHOW;
        i3 = NOSHOW;
        i4 = NOSHOW;
        i5 = NOSHOW;
        i6 = NOSHOW;
        i7 = NOSHOW;

    end
end

endmodule