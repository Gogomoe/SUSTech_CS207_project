module key_scan_test(
    input clk, rst,
    input[3:0] row,
    output[3:0] col,
    output[23:0] led
);

wire[15:0] keys;
key_scanner key_scan_inst(clk, rst, row, col, keys);

wire key_edge;
button_edge key_edge_inst(clk, keys[1], key_edge);

assign led = {key_edge, 7'b0, keys};

endmodule