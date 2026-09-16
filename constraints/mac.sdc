# Virtual clock for timing analysis
create_clock -name virtual_clk -period 10

# Input timing
set_input_delay 0 -clock virtual_clk [get_ports {a b acc}]

# Output timing
set_output_delay 0 -clock virtual_clk [get_ports {result}]