
module pl_m (
  input wire        i_clk0,
  input wire        i_clk1,
  input wire        i_clk2,
  input wire        i_clk3,
  input wire        i_rst,
  input wire        i_ic_rst,
  output wire [7:0] o_led
);

  assign o_led = 8'h55;

endmodule

