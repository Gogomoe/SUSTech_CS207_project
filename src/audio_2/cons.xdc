set_property PACKAGE_PIN Y18 [get_ports clk]
set_property PACKAGE_PIN A19 [get_ports speaker]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports speaker]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {clk_IBUF}]
