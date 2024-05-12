##### TEST MODE

create_clock -name s_clk -period 100 -waveform {0 50} [get_ports scan_clk]

set_dont_touch_network [get_clocks s_clk]

#set_clock_groups -asynchronous  -name g2    -group [get_clocks s_clk] 
