module button_process(
	input[7:0] bt,
	output[15:0] button
);

assign button[0] = ~(bt[3] | bt[5]);
assign button[1] = ~(bt[0] | bt[4]);
assign button[2] = ~(bt[0] | bt[5]);
assign button[3] = ~(bt[0] | bt[6]);
assign button[4] = ~(bt[1] | bt[4]);
assign button[5] = ~(bt[1] | bt[5]);
assign button[6] = ~(bt[1] | bt[6]);
assign button[7] = ~(bt[2] | bt[4]);
assign button[8] = ~(bt[2] | bt[5]);
assign button[9] = ~(bt[2] | bt[6]);
assign button[10] = ~(bt[0] | bt[7]);
assign button[11] = ~(bt[1] | bt[7]);
assign button[12] = ~(bt[2] | bt[7]);
assign button[13] = ~(bt[3] | bt[7]);
assign button[14] = ~(bt[3] | bt[4]);
assign button[15] = ~(bt[3] | bt[6]);

endmodule