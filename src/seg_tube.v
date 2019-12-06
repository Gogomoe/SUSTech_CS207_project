`timescale 1ns / 1ps

module seg_tube(
    input clk,
    input[7:0] i0, i1, i2, i3, i4, i5, i6, i7,
    output reg[7:0] seg, seg_en
);

wire clock;
counter c_inst(clk, 1'b0, 16'd2, clock);

reg[7:0] visiable;

always @(posedge clock)
begin
    if(visiable != 8'b00000000) begin
        visiable <= visiable >> 1;
    end
    else begin
        visiable <= 8'b10000000;
    end
    seg_en <= ~visiable;
        
    case(visiable)
        8'b10000000: seg <= i0;
        8'b01000000: seg <= i1;
        8'b00100000: seg <= i2;
        8'b00010000: seg <= i3;
        8'b00001000: seg <= i4;
        8'b00000100: seg <= i5;
        8'b00000010: seg <= i6;
        8'b00000001: seg <= i7;
        8'b00000000: seg <= 8'b11111111;
    endcase
end

endmodule
