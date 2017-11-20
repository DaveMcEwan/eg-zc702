# LED GPIO pins

# LSB on RHS(DS19), MSB on LHS(DS15)
# Table 1-23, page 46 in ug850-zc702-eval-bd.pdf
set_property PACKAGE_PIN E15 [get_ports {LED8b_tri_o[0]}]
set_property PACKAGE_PIN D15 [get_ports {LED8b_tri_o[1]}]
set_property PACKAGE_PIN W17 [get_ports {LED8b_tri_o[2]}]
set_property PACKAGE_PIN W5  [get_ports {LED8b_tri_o[3]}]
set_property PACKAGE_PIN V7  [get_ports {LED8b_tri_o[4]}]
set_property PACKAGE_PIN W10 [get_ports {LED8b_tri_o[5]}]
set_property PACKAGE_PIN P18 [get_ports {LED8b_tri_o[6]}]
set_property PACKAGE_PIN P17 [get_ports {LED8b_tri_o[7]}]

set_property IOSTANDARD LVCMOS25 [get_ports {LED8b_tri_o[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8b_tri_o[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8b_tri_o[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8b_tri_o[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8b_tri_o[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8b_tri_o[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8b_tri_o[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {LED8b_tri_o[7]}]

