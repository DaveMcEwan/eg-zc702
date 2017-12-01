
module pl_m (
  // clkrst
  input  wire       i_clk0,
  input  wire       i_rst,
  input  wire       i_ic_rst,

  // {{{ AXI from PS7 GP0
  // Signals ordered according to the document:
  // AMBA AXI and ACE Proctocol Specification
  // ARM IHI 0022D (ID102711)

  // Global signals.
  // ACLK = i_clk0
  // ARESETn = i_rst

  // Write address channel signals.
  input  wire [11:0]   i_M_AXI_GP0_AWID,
  input  wire [31:0]   i_M_AXI_GP0_AWADDR,
  input  wire [3:0]    i_M_AXI_GP0_AWLEN,
  input  wire [2:0]    i_M_AXI_GP0_AWSIZE,
  input  wire [1:0]    i_M_AXI_GP0_AWBURST,
  input  wire [1:0]    i_M_AXI_GP0_AWLOCK,
  input  wire [3:0]    i_M_AXI_GP0_AWCACHE,
  input  wire [2:0]    i_M_AXI_GP0_AWPROT,
  input  wire [3:0]    i_M_AXI_GP0_AWQOS,
  //                               AWREGION only in AXI4
  //                               AWUSER only in AXI4
  input  wire          i_M_AXI_GP0_AWVALID,
  output wire          o_M_AXI_GP0_AWREADY,

  // Write data channel signals.
  input  wire [11:0]   i_M_AXI_GP0_WID,
  input  wire [31:0]   i_M_AXI_GP0_WDATA,
  input  wire [3:0]    i_M_AXI_GP0_WSTRB,
  input  wire          i_M_AXI_GP0_WLAST,
  //                               WUSER only in AXI4
  input  wire          i_M_AXI_GP0_WVALID,
  output wire          o_M_AXI_GP0_WREADY,

  // Write response channel signals.
  output wire [11:0]   o_M_AXI_GP0_BID,
  output wire [1:0]    o_M_AXI_GP0_BRESP,
  //                               BUSER only in AXI4
  output wire          o_M_AXI_GP0_BVALID,
  input  wire          i_M_AXI_GP0_BREADY,

  // Read address channel signals.
  input  wire [11:0]   i_M_AXI_GP0_ARID,
  input  wire [31:0]   i_M_AXI_GP0_ARADDR,
  input  wire [3:0]    i_M_AXI_GP0_ARLEN,
  input  wire [2:0]    i_M_AXI_GP0_ARSIZE,
  input  wire [1:0]    i_M_AXI_GP0_ARBURST,
  input  wire [1:0]    i_M_AXI_GP0_ARLOCK,
  input  wire [3:0]    i_M_AXI_GP0_ARCACHE,
  input  wire [2:0]    i_M_AXI_GP0_ARPROT,
  input  wire [3:0]    i_M_AXI_GP0_ARQOS,
  //                               ARREGION only in AXI4
  //                               ARUSER only in AXI4
  input  wire          i_M_AXI_GP0_ARVALID,
  output wire          o_M_AXI_GP0_ARREADY,

  // Read data channel signals
  output wire [11:0]   o_M_AXI_GP0_RID,
  output wire [31:0]   o_M_AXI_GP0_RDATA,
  output wire [1:0]    o_M_AXI_GP0_RRESP,
  output wire          o_M_AXI_GP0_RLAST,
  //                               RUSER only in AXI4
  output wire          o_M_AXI_GP0_RVALID,
  input  wire          i_M_AXI_GP0_RREADY,

  // Low-power interface signals, not implemented
  // }}} AXI from PS7 GP0

  // {{{ AXI from PS7 GP1
  // Signals ordered according to the document:
  // AMBA AXI and ACE Proctocol Specification
  // ARM IHI 0022D (ID102711)

  // Global signals.
  // ACLK = i_clk0
  // ARESETn = i_rst

  // Write address channel signals.
  input  wire [11:0]   i_M_AXI_GP1_AWID,
  input  wire [31:0]   i_M_AXI_GP1_AWADDR,
  input  wire [3:0]    i_M_AXI_GP1_AWLEN,
  input  wire [2:0]    i_M_AXI_GP1_AWSIZE,
  input  wire [1:0]    i_M_AXI_GP1_AWBURST,
  input  wire [1:0]    i_M_AXI_GP1_AWLOCK,
  input  wire [3:0]    i_M_AXI_GP1_AWCACHE,
  input  wire [2:0]    i_M_AXI_GP1_AWPROT,
  input  wire [3:0]    i_M_AXI_GP1_AWQOS,
  //                               AWREGION only in AXI4
  //                               AWUSER only in AXI4
  input  wire          i_M_AXI_GP1_AWVALID,
  output wire          o_M_AXI_GP1_AWREADY,

  // Write data channel signals.
  input  wire [11:0]   i_M_AXI_GP1_WID,
  input  wire [31:0]   i_M_AXI_GP1_WDATA,
  input  wire [3:0]    i_M_AXI_GP1_WSTRB,
  input  wire          i_M_AXI_GP1_WLAST,
  //                               WUSER only in AXI4
  input  wire          i_M_AXI_GP1_WVALID,
  output wire          o_M_AXI_GP1_WREADY,

  // Write response channel signals.
  output wire [11:0]   o_M_AXI_GP1_BID,
  output wire [1:0]    o_M_AXI_GP1_BRESP,
  //                               BUSER only in AXI4
  output wire          o_M_AXI_GP1_BVALID,
  input  wire          i_M_AXI_GP1_BREADY,

  // Read address channel signals.
  input  wire [11:0]   i_M_AXI_GP1_ARID,
  input  wire [31:0]   i_M_AXI_GP1_ARADDR,
  input  wire [3:0]    i_M_AXI_GP1_ARLEN,
  input  wire [2:0]    i_M_AXI_GP1_ARSIZE,
  input  wire [1:0]    i_M_AXI_GP1_ARBURST,
  input  wire [1:0]    i_M_AXI_GP1_ARLOCK,
  input  wire [3:0]    i_M_AXI_GP1_ARCACHE,
  input  wire [2:0]    i_M_AXI_GP1_ARPROT,
  input  wire [3:0]    i_M_AXI_GP1_ARQOS,
  //                               ARREGION only in AXI4
  //                               ARUSER only in AXI4
  input  wire          i_M_AXI_GP1_ARVALID,
  output wire          o_M_AXI_GP1_ARREADY,

  // Read data channel signals
  output wire [11:0]   o_M_AXI_GP1_RID,
  output wire [31:0]   o_M_AXI_GP1_RDATA,
  output wire [1:0]    o_M_AXI_GP1_RRESP,
  output wire          o_M_AXI_GP1_RLAST,
  //                               RUSER only in AXI4
  output wire          o_M_AXI_GP1_RVALID,
  input  wire          i_M_AXI_GP1_RREADY,

  // Low-power interface signals, not implemented
  // }}} AXI from PS7 GP1

  output wire [7:0] o_led
);

endmodule

