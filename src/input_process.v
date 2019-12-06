module input_process(
	input clk,
	input power,
	input[23:0] sw,
	input[7:0] bt,
	output reg[23:0] switch,
	output reg[15:0] button
);

wire clock;
reg lock, counter_rst;

counter c1(clk, counter_rst, 16'd50, clock);

always @(posedge clk,negedge power, posedge clock) begin
    if(~power) begin
        lock <= 0;
        counter_rst <= 1;
        switch <= 24'b0;
    end
    if(lock) begin
        if(clock) begin
            lock <= 0;
            counter_rst <= 1;
        end
    end
    else begin
        if(switch != sw) begin
            switch <= sw;
            counter_rst <= 0;
            lock <= 1;
        end
    end
end

endmodule