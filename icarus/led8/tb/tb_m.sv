`include "ff.svh"

module tb_m ();

  initial begin
    $dumpfile("build/tb_m.vcd");
    $dumpvars;
    #100 $finish;
  end

  // {{{ clkrst drivers

  // Clocks generated by ps7_m are asynchronous.
  reg v_i_clk0;
  reg v_i_clk1;
  reg v_i_clk2;
  reg v_i_clk3;
  initial v_i_clk0 = 0;
  initial v_i_clk1 = 0;
  initial v_i_clk2 = 0;
  initial v_i_clk3 = 0;
  always #7  v_i_clk0 = ~v_i_clk0;
  always #11 v_i_clk1 = ~v_i_clk1;
  always #13 v_i_clk2 = ~v_i_clk2;
  always #17 v_i_clk3 = ~v_i_clk3;

  // Resets generated by ps7_m are asynchronous.
  reg v_i_rst;
  reg v_i_ic_rst;
  initial begin
    v_i_rst = 0;
    #18 v_i_rst = 1;
  end
  initial begin
    v_i_ic_rst = 0;
    #36 v_i_ic_rst = 1;
  end

  // }}} clkrst drivers

  // Wires for LEDs only used for snooping.
  wire [7:0] v_o_led;

  // {{{ AXI drivers

  // {{{ AXI from PS7 GP0
  // Signals ordered according to the document:
  // AMBA AXI and ACE Proctocol Specification
  // ARM IHI 0022D (ID102711)

  // Global signals.
  // ACLK = v_i_clk0
  // ARESETn = v_i_rst

  // Write address channel signals.
  wire [11:0]   v_i_M_AXI_GP0_AWID;
  reg  [31:0]   v_i_M_AXI_GP0_AWADDR;
  reg  [3:0]    v_i_M_AXI_GP0_AWLEN;
  reg  [2:0]    v_i_M_AXI_GP0_AWSIZE;
  reg  [1:0]    v_i_M_AXI_GP0_AWBURST;
  reg  [1:0]    v_i_M_AXI_GP0_AWLOCK;
  reg  [3:0]    v_i_M_AXI_GP0_AWCACHE;
  reg  [2:0]    v_i_M_AXI_GP0_AWPROT;
  reg  [3:0]    v_i_M_AXI_GP0_AWQOS;
  //                               AWREGION only in AXI4
  //                               AWUSER only in AXI4
  reg           v_i_M_AXI_GP0_AWVALID;
  wire          v_o_M_AXI_GP0_AWREADY;

  // Write data channel signals.
  wire [11:0]   v_i_M_AXI_GP0_WID;
  reg  [31:0]   v_i_M_AXI_GP0_WDATA;
  reg  [3:0]    v_i_M_AXI_GP0_WSTRB;
  reg           v_i_M_AXI_GP0_WLAST;
  //                               WUSER only in AXI4
  reg           v_i_M_AXI_GP0_WVALID;
  wire          v_o_M_AXI_GP0_WREADY;

  // Write response channel signals.
  wire [11:0]   v_o_M_AXI_GP0_BID;
  wire [1:0]    v_o_M_AXI_GP0_BRESP;
  //                               BUSER only in AXI4
  wire          v_o_M_AXI_GP0_BVALID;
  wire          v_i_M_AXI_GP0_BREADY;

  // Read address channel signals.
  wire [11:0]   v_i_M_AXI_GP0_ARID;
  reg  [31:0]   v_i_M_AXI_GP0_ARADDR;
  reg  [3:0]    v_i_M_AXI_GP0_ARLEN;
  reg  [2:0]    v_i_M_AXI_GP0_ARSIZE;
  reg  [1:0]    v_i_M_AXI_GP0_ARBURST;
  reg  [1:0]    v_i_M_AXI_GP0_ARLOCK;
  reg  [3:0]    v_i_M_AXI_GP0_ARCACHE;
  reg  [2:0]    v_i_M_AXI_GP0_ARPROT;
  reg  [3:0]    v_i_M_AXI_GP0_ARQOS;
  //                               ARREGION only in AXI4
  //                               ARUSER only in AXI4
  reg           v_i_M_AXI_GP0_ARVALID;
  wire          v_o_M_AXI_GP0_ARREADY;

  // Read data channel signals
  wire [11:0]   v_o_M_AXI_GP0_RID;
  wire [31:0]   v_o_M_AXI_GP0_RDATA;
  wire [1:0]    v_o_M_AXI_GP0_RRESP;
  wire          v_o_M_AXI_GP0_RLAST;
  //                               RUSER only in AXI4
  wire          v_o_M_AXI_GP0_RVALID;
  wire          v_i_M_AXI_GP0_RREADY;

  // Low-power interface signals; not implemented
  // }}} AXI from PS7 GP0

  // {{{ AXI from PS7 GP1
  // Signals ordered according to the document:
  // AMBA AXI and ACE Proctocol Specification
  // ARM IHI 0022D (ID102711)

  // Global signals.
  // ACLK = v_i_clk0
  // ARESETn = v_i_rst

  // Write address channel signals.
  wire [11:0]   v_i_M_AXI_GP1_AWID;
  reg  [31:0]   v_i_M_AXI_GP1_AWADDR;
  reg  [3:0]    v_i_M_AXI_GP1_AWLEN;
  reg  [2:0]    v_i_M_AXI_GP1_AWSIZE;
  reg  [1:0]    v_i_M_AXI_GP1_AWBURST;
  reg  [1:0]    v_i_M_AXI_GP1_AWLOCK;
  reg  [3:0]    v_i_M_AXI_GP1_AWCACHE;
  reg  [2:0]    v_i_M_AXI_GP1_AWPROT;
  reg  [3:0]    v_i_M_AXI_GP1_AWQOS;
  //                               AWREGION only in AXI4
  //                               AWUSER only in AXI4
  reg           v_i_M_AXI_GP1_AWVALID;
  wire          v_o_M_AXI_GP1_AWREADY;

  // Write data channel signals.
  wire [11:0]   v_i_M_AXI_GP1_WID;
  reg  [31:0]   v_i_M_AXI_GP1_WDATA;
  reg  [3:0]    v_i_M_AXI_GP1_WSTRB;
  reg           v_i_M_AXI_GP1_WLAST;
  //                               WUSER only in AXI4
  reg           v_i_M_AXI_GP1_WVALID;
  wire          v_o_M_AXI_GP1_WREADY;

  // Write response channel signals.
  wire [11:0]   v_o_M_AXI_GP1_BID;
  wire [1:0]    v_o_M_AXI_GP1_BRESP;
  //                               BUSER only in AXI4
  wire          v_o_M_AXI_GP1_BVALID;
  wire          v_i_M_AXI_GP1_BREADY;

  // Read address channel signals.
  wire [11:0]   v_i_M_AXI_GP1_ARID;
  reg  [31:0]   v_i_M_AXI_GP1_ARADDR;
  reg  [3:0]    v_i_M_AXI_GP1_ARLEN;
  reg  [2:0]    v_i_M_AXI_GP1_ARSIZE;
  reg  [1:0]    v_i_M_AXI_GP1_ARBURST;
  reg  [1:0]    v_i_M_AXI_GP1_ARLOCK;
  reg  [3:0]    v_i_M_AXI_GP1_ARCACHE;
  reg  [2:0]    v_i_M_AXI_GP1_ARPROT;
  reg  [3:0]    v_i_M_AXI_GP1_ARQOS;
  //                               ARREGION only in AXI4
  //                               ARUSER only in AXI4
  reg           v_i_M_AXI_GP1_ARVALID;
  wire          v_o_M_AXI_GP1_ARREADY;

  // Read data channel signals
  wire [11:0]   v_o_M_AXI_GP1_RID;
  wire [31:0]   v_o_M_AXI_GP1_RDATA;
  wire [1:0]    v_o_M_AXI_GP1_RRESP;
  wire          v_o_M_AXI_GP1_RLAST;
  //                               RUSER only in AXI4
  wire          v_o_M_AXI_GP1_RVALID;
  wire          v_i_M_AXI_GP1_RREADY;

  // Low-power interface signals; not implemented
  // }}} AXI from PS7 GP1

  // Randomly drop master RREADY/BREADY outputs 1/10 cycles.
  `ff_nocg_norst(logic, v_GP0_RREADY_gate, v_i_clk0)
  `ff_nocg_norst(logic, v_GP0_BREADY_gate, v_i_clk0)
  always @ (posedge v_i_clk0) v_GP0_RREADY_gate_d = $urandom_range(0, 10) != 0;
  always @ (posedge v_i_clk0) v_GP0_BREADY_gate_d = $urandom_range(0, 10) != 0;
  assign v_i_M_AXI_GP0_RREADY = v_GP0_RREADY_gate_q;
  assign v_i_M_AXI_GP0_BREADY = v_GP0_BREADY_gate_q;
  `ff_nocg_norst(logic, v_GP1_RREADY_gate, v_i_clk0)
  `ff_nocg_norst(logic, v_GP1_BREADY_gate, v_i_clk0)
  always @ (posedge v_i_clk0) v_GP1_RREADY_gate_d = $urandom_range(0, 10) != 0;
  always @ (posedge v_i_clk0) v_GP1_BREADY_gate_d = $urandom_range(0, 10) != 0;
  assign v_i_M_AXI_GP1_RREADY = v_GP1_RREADY_gate_q;
  assign v_i_M_AXI_GP1_BREADY = v_GP1_BREADY_gate_q;

  // Randomly changes AWID/WID/ARID while not in a transaction.
  `ff_cg_norst(logic, v_GP0_AWID, v_i_clk0, !v_i_M_AXI_GP0_AWVALID)
  always @ (posedge v_i_clk0) v_GP0_AWID_d = $urandom;
  assign v_i_M_AXI_GP0_AWID = v_GP0_AWID_q;
  assign v_i_M_AXI_GP0_WID  = v_GP0_AWID_q;
  `ff_cg_norst(logic, v_GP0_ARID, v_i_clk0, !v_i_M_AXI_GP0_ARVALID)
  always @ (posedge v_i_clk0) v_GP0_ARID_d = $urandom;
  assign v_i_M_AXI_GP0_ARID = v_GP0_ARID_q;
  `ff_cg_norst(logic, v_GP1_AWID, v_i_clk0, !v_i_M_AXI_GP1_AWVALID)
  always @ (posedge v_i_clk0) v_GP1_AWID_d = $urandom;
  assign v_i_M_AXI_GP1_AWID = v_GP1_AWID_q;
  assign v_i_M_AXI_GP1_WID  = v_GP1_AWID_q;
  `ff_cg_norst(logic, v_GP1_ARID, v_i_clk0, !v_i_M_AXI_GP1_ARVALID)
  always @ (posedge v_i_clk0) v_GP1_ARID_d = $urandom;
  assign v_i_M_AXI_GP1_ARID = v_GP1_ARID_q;

  // NOTE: No support for alternative memory types.
  // Tied to "Device Non-bufferable".
  assign v_i_M_AXI_GP0_AWCACHE = 4'b0000;
  assign v_i_M_AXI_GP0_ARCACHE = 4'b0000;
  assign v_i_M_AXI_GP1_AWCACHE = 4'b0000;
  assign v_i_M_AXI_GP1_ARCACHE = 4'b0000;

  // NOTE: No support for any QoS scheme.
  assign v_i_M_AXI_GP0_AWQOS = 4'b0000;
  assign v_i_M_AXI_GP0_ARQOS = 4'b0000;
  assign v_i_M_AXI_GP1_AWQOS = 4'b0000;
  assign v_i_M_AXI_GP1_ARQOS = 4'b0000;

  // AXI4 does not support locked transactions, only for AXI3
  // NOTE: No support for exclusive access.
  assign v_i_M_AXI_GP0_AWLOCK = 2'b00;
  assign v_i_M_AXI_GP0_ARLOCK = 2'b00;
  assign v_i_M_AXI_GP1_AWLOCK = 2'b00;
  assign v_i_M_AXI_GP1_ARLOCK = 2'b00;

  // NOTE: No support for access permissions.
  // Tied to {data, secure, unprivileged}.
  assign v_i_M_AXI_GP0_AWPROT = 3'b000;
  assign v_i_M_AXI_GP0_ARPROT = 3'b000;
  assign v_i_M_AXI_GP1_AWPROT = 3'b000;
  assign v_i_M_AXI_GP1_ARPROT = 3'b000;

  // NOTE: No support for bursting.
  // Tied to 4B (32b), FIXED.
  assign v_i_M_AXI_GP0_AWLEN   = 8'd0;
  assign v_i_M_AXI_GP0_AWSIZE  = 3'b010;
  assign v_i_M_AXI_GP0_AWBURST = 2'b00;

  initial begin
    v_i_M_AXI_GP0_AWVALID = 1'b0;
    v_i_M_AXI_GP0_ARVALID = 1'b0;
    v_i_M_AXI_GP1_AWVALID = 1'b0;
    v_i_M_AXI_GP1_ARVALID = 1'b0;
  end

  reg [31:0] v_ps7axim_read_data; // Returned data is written here.
  task ps7axim_read;
    input port;
    input [31:0] i_addr;
    // TODO
    assign v_ps7axim_read_data = 32'd0;
  endtask

  task ps7axim_write;
    input port;
    input [31:0] i_addr;
    input [31:0] i_data;

    // {{{ AXI3
    // Signals ordered according to the document:
    // AMBA AXI and ACE Proctocol Specification
    // ARM IHI 0022D (ID102711)

    // Global signals.
    // ACLK = v_i_clk0
    // ARESETn = v_i_rst

    // Write address channel signals.
    reg [11:0]    v_i_AWID;   // Randomly set outside transaction.
    reg [31:0]    v_i_AWADDR;
    reg [3:0]     v_i_AWLEN;
    reg [2:0]     v_i_AWSIZE;
    reg [1:0]     v_i_AWBURST;
    reg [1:0]     v_i_AWLOCK;
    reg [3:0]     v_i_AWCACHE;
    reg [2:0]     v_i_AWPROT;
    reg [3:0]     v_i_AWQOS; // AXI4
    //                AWREGION only in AXI4
    //                AWUSER only in AXI4
    reg           v_i_AWVALID;
    reg           v_o_AWREADY;

    // Write data channel signals.
    reg  [11:0]   v_i_WID;    // Must be equal to v_i_AWID.
    reg  [31:0]   v_i_WDATA;
    reg  [3:0]    v_i_WSTRB;
    reg           v_i_WLAST;
    //                WUSER only in AXI4
    reg           v_i_WVALID;
    reg           v_o_WREADY;

    // Write response channel signals.
    reg  [11:0]   v_o_BID;
    reg  [1:0]    v_o_BRESP;
    //                BUSER only in AXI4
    reg           v_o_BVALID;
    reg           v_i_BREADY; // Usually high, randomly drop.

    // Read address channel signals.
    reg  [11:0]   v_i_ARID;   // Randomly set outside transaction.
    reg  [31:0]   v_i_ARADDR;
    reg  [3:0]    v_i_ARLEN;
    reg  [2:0]    v_i_ARSIZE;
    reg  [1:0]    v_i_ARBURST;
    reg  [1:0]    v_i_ARLOCK;
    reg  [3:0]    v_i_ARCACHE;
    reg  [2:0]    v_i_ARPROT;
    reg  [3:0]    v_i_ARQOS;
    //                ARREGION only in AXI4
    //                ARUSER only in AXI4
    reg           v_i_ARVALID;
    reg           v_o_ARREADY;

    // Read data channel signals
    reg  [11:0]   v_o_RID;
    reg  [31:0]   v_o_RDATA;
    reg  [1:0]    v_o_RRESP;
    reg           v_o_RLAST;
    //                RUSER only in AXI4
    reg           v_o_RVALID;
    reg           v_i_RREADY; // Usually high, randomly drop.

    // Low-power interface signals; not implemented

    // }}} AXI3

    begin

      if (port) begin // {{{ port
        assign v_i_M_AXI_GP1_AWADDR   = v_i_AWADDR;
        assign v_i_M_AXI_GP1_AWVALID  = v_i_AWVALID;
        assign v_i_M_AXI_GP1_WDATA    = v_i_WDATA;
        assign v_i_M_AXI_GP1_WSTRB    = v_i_WSTRB;
        assign v_i_M_AXI_GP1_WLAST    = v_i_WLAST;
        assign v_i_M_AXI_GP1_WVALID   = v_i_WVALID;
        assign v_i_M_AXI_GP1_ARADDR   = v_i_ARADDR;
        assign v_i_M_AXI_GP1_ARVALID  = v_i_ARVALID;
        assign v_i_AWLEN    = v_i_M_AXI_GP1_AWLEN;
        assign v_i_AWSIZE   = v_i_M_AXI_GP1_AWSIZE;
        assign v_i_AWBURST  = v_i_M_AXI_GP1_AWBURST;
        assign v_i_ARLEN    = v_i_M_AXI_GP1_ARLEN;
        assign v_i_ARSIZE   = v_i_M_AXI_GP1_ARSIZE;
        assign v_i_ARBURST  = v_i_M_AXI_GP1_ARBURST;
        assign v_i_AWCACHE  = v_i_M_AXI_GP1_AWCACHE;
        assign v_i_ARCACHE  = v_i_M_AXI_GP1_ARCACHE;
        assign v_i_AWPROT   = v_i_M_AXI_GP1_AWPROT;
        assign v_i_ARPROT   = v_i_M_AXI_GP1_ARPROT;
        assign v_i_AWLOCK   = v_i_M_AXI_GP1_AWLOCK;
        assign v_i_ARLOCK   = v_i_M_AXI_GP1_ARLOCK;
        assign v_i_AWQOS    = v_i_M_AXI_GP1_AWQOS;
        assign v_i_ARQOS    = v_i_M_AXI_GP1_ARQOS;
        assign v_i_AWID     = v_i_M_AXI_GP1_AWID;
        assign v_i_WID      = v_i_M_AXI_GP1_WID;
        assign v_i_AWID     = v_i_M_AXI_GP1_ARID;
        assign v_i_RREADY   = v_i_M_AXI_GP1_RREADY;
        assign v_i_BREADY   = v_i_M_AXI_GP1_BREADY;
        assign v_o_AWREADY  = v_o_M_AXI_GP1_AWREADY;
        assign v_o_WREADY   = v_o_M_AXI_GP1_WREADY;
        assign v_o_BID      = v_o_M_AXI_GP1_BID;
        assign v_o_BRESP    = v_o_M_AXI_GP1_BRESP;
        assign v_o_BVALID   = v_o_M_AXI_GP1_BVALID;
        assign v_o_ARREADY  = v_o_M_AXI_GP1_ARREADY;
        assign v_o_RID      = v_o_M_AXI_GP1_RID;
        assign v_o_RDATA    = v_o_M_AXI_GP1_RDATA;
        assign v_o_RRESP    = v_o_M_AXI_GP1_RRESP;
        assign v_o_RLAST    = v_o_M_AXI_GP1_RLAST;
        assign v_o_RVALID   = v_o_M_AXI_GP1_RVALID;
      end
      else begin
        assign v_i_M_AXI_GP0_AWADDR   = v_i_AWADDR;
        assign v_i_M_AXI_GP0_AWVALID  = v_i_AWVALID;
        assign v_i_M_AXI_GP0_WDATA    = v_i_WDATA;
        assign v_i_M_AXI_GP0_WSTRB    = v_i_WSTRB;
        assign v_i_M_AXI_GP0_WLAST    = v_i_WLAST;
        assign v_i_M_AXI_GP0_WVALID   = v_i_WVALID;
        assign v_i_M_AXI_GP0_ARADDR   = v_i_ARADDR;
        assign v_i_M_AXI_GP0_ARVALID  = v_i_ARVALID;
        assign v_i_AWLEN    = v_i_M_AXI_GP0_AWLEN;
        assign v_i_AWSIZE   = v_i_M_AXI_GP0_AWSIZE;
        assign v_i_AWBURST  = v_i_M_AXI_GP0_AWBURST;
        assign v_i_ARLEN    = v_i_M_AXI_GP0_ARLEN;
        assign v_i_ARSIZE   = v_i_M_AXI_GP0_ARSIZE;
        assign v_i_ARBURST  = v_i_M_AXI_GP0_ARBURST;
        assign v_i_AWCACHE  = v_i_M_AXI_GP0_AWCACHE;
        assign v_i_ARCACHE  = v_i_M_AXI_GP0_ARCACHE;
        assign v_i_AWPROT   = v_i_M_AXI_GP0_AWPROT;
        assign v_i_ARPROT   = v_i_M_AXI_GP0_ARPROT;
        assign v_i_AWLOCK   = v_i_M_AXI_GP0_AWLOCK;
        assign v_i_ARLOCK   = v_i_M_AXI_GP0_ARLOCK;
        assign v_i_AWQOS    = v_i_M_AXI_GP0_AWQOS;
        assign v_i_ARQOS    = v_i_M_AXI_GP0_ARQOS;
        assign v_i_AWID     = v_i_M_AXI_GP0_AWID;
        assign v_i_WID      = v_i_M_AXI_GP0_WID;
        assign v_i_AWID     = v_i_M_AXI_GP0_ARID;
        assign v_i_RREADY   = v_i_M_AXI_GP0_RREADY;
        assign v_i_BREADY   = v_i_M_AXI_GP0_BREADY;
        assign v_o_AWREADY  = v_o_M_AXI_GP0_AWREADY;
        assign v_o_WREADY   = v_o_M_AXI_GP0_WREADY;
        assign v_o_BID      = v_o_M_AXI_GP0_BID;
        assign v_o_BRESP    = v_o_M_AXI_GP0_BRESP;
        assign v_o_BVALID   = v_o_M_AXI_GP0_BVALID;
        assign v_o_ARREADY  = v_o_M_AXI_GP0_ARREADY;
        assign v_o_RID      = v_o_M_AXI_GP0_RID;
        assign v_o_RDATA    = v_o_M_AXI_GP0_RDATA;
        assign v_o_RRESP    = v_o_M_AXI_GP0_RRESP;
        assign v_o_RLAST    = v_o_M_AXI_GP0_RLAST;
        assign v_o_RVALID   = v_o_M_AXI_GP0_RVALID;
      end // }}} port

      fork
        begin : axi_aw
          v_i_AWVALID = 1'b0;
          @ (posedge v_i_clk0);
          v_i_AWVALID = 1'b1;
          v_i_AWADDR = i_addr;
          @ (posedge v_i_clk0);
          wait (v_o_AWREADY) v_i_AWVALID = 1'b0;
        end : axi_aw
        begin : axi_w
          v_i_WVALID = 1'b0;
          @ (posedge v_i_clk0);
          v_i_WVALID = 1'b1;
          v_i_WDATA = i_data;
          @ (posedge v_i_clk0);
          wait (v_o_WREADY) v_i_WVALID = 1'b0;
          // TODO
        end : axi_w
      join

    end
  endtask

  // }}} AXI drivers

  pl_m pl_u (
    .i_clk0               (v_i_clk0),
    .i_rst                (v_i_rst),
    .i_ic_rst             (v_i_ic_rst),

    // {{{ AXI from PS7 GP0
    .i_M_AXI_GP0_AWID     (v_i_M_AXI_GP0_AWID),
    .i_M_AXI_GP0_AWADDR   (v_i_M_AXI_GP0_AWADDR),
    .i_M_AXI_GP0_AWLEN    (v_i_M_AXI_GP0_AWLEN),
    .i_M_AXI_GP0_AWSIZE   (v_i_M_AXI_GP0_AWSIZE),
    .i_M_AXI_GP0_AWBURST  (v_i_M_AXI_GP0_AWBURST),
    .i_M_AXI_GP0_AWLOCK   (v_i_M_AXI_GP0_AWLOCK),
    .i_M_AXI_GP0_AWCACHE  (v_i_M_AXI_GP0_AWCACHE),
    .i_M_AXI_GP0_AWPROT   (v_i_M_AXI_GP0_AWPROT),
    .i_M_AXI_GP0_AWQOS    (v_i_M_AXI_GP0_AWQOS),
    .i_M_AXI_GP0_AWVALID  (v_i_M_AXI_GP0_AWVALID),
    .i_M_AXI_GP0_WID      (v_i_M_AXI_GP0_WID),
    .i_M_AXI_GP0_WDATA    (v_i_M_AXI_GP0_WDATA),
    .i_M_AXI_GP0_WSTRB    (v_i_M_AXI_GP0_WSTRB),
    .i_M_AXI_GP0_WLAST    (v_i_M_AXI_GP0_WLAST),
    .i_M_AXI_GP0_WVALID   (v_i_M_AXI_GP0_WVALID),
    .i_M_AXI_GP0_BREADY   (v_i_M_AXI_GP0_BREADY),
    .i_M_AXI_GP0_ARID     (v_i_M_AXI_GP0_ARID),
    .i_M_AXI_GP0_ARADDR   (v_i_M_AXI_GP0_ARADDR),
    .i_M_AXI_GP0_ARLEN    (v_i_M_AXI_GP0_ARLEN),
    .i_M_AXI_GP0_ARSIZE   (v_i_M_AXI_GP0_ARSIZE),
    .i_M_AXI_GP0_ARBURST  (v_i_M_AXI_GP0_ARBURST),
    .i_M_AXI_GP0_ARLOCK   (v_i_M_AXI_GP0_ARLOCK),
    .i_M_AXI_GP0_ARCACHE  (v_i_M_AXI_GP0_ARCACHE),
    .i_M_AXI_GP0_ARPROT   (v_i_M_AXI_GP0_ARPROT),
    .i_M_AXI_GP0_ARQOS    (v_i_M_AXI_GP0_ARQOS),
    .i_M_AXI_GP0_ARVALID  (v_i_M_AXI_GP0_ARVALID),
    .i_M_AXI_GP0_RREADY   (v_i_M_AXI_GP0_RREADY),
    .o_M_AXI_GP0_AWREADY  (v_o_M_AXI_GP0_AWREADY),
    .o_M_AXI_GP0_WREADY   (v_o_M_AXI_GP0_WREADY),
    .o_M_AXI_GP0_BID      (v_o_M_AXI_GP0_BID),
    .o_M_AXI_GP0_BRESP    (v_o_M_AXI_GP0_BRESP),
    .o_M_AXI_GP0_BVALID   (v_o_M_AXI_GP0_BVALID),
    .o_M_AXI_GP0_ARREADY  (v_o_M_AXI_GP0_ARREADY),
    .o_M_AXI_GP0_RID      (v_o_M_AXI_GP0_RID),
    .o_M_AXI_GP0_RDATA    (v_o_M_AXI_GP0_RDATA),
    .o_M_AXI_GP0_RRESP    (v_o_M_AXI_GP0_RRESP),
    .o_M_AXI_GP0_RLAST    (v_o_M_AXI_GP0_RLAST),
    .o_M_AXI_GP0_RVALID   (v_o_M_AXI_GP0_RVALID),
    // }}} AXI from PS7 GP0

    // {{{ AXI from PS7 GP1
    .i_M_AXI_GP1_AWID     (v_i_M_AXI_GP1_AWID),
    .i_M_AXI_GP1_AWADDR   (v_i_M_AXI_GP1_AWADDR),
    .i_M_AXI_GP1_AWLEN    (v_i_M_AXI_GP1_AWLEN),
    .i_M_AXI_GP1_AWSIZE   (v_i_M_AXI_GP1_AWSIZE),
    .i_M_AXI_GP1_AWBURST  (v_i_M_AXI_GP1_AWBURST),
    .i_M_AXI_GP1_AWLOCK   (v_i_M_AXI_GP1_AWLOCK),
    .i_M_AXI_GP1_AWCACHE  (v_i_M_AXI_GP1_AWCACHE),
    .i_M_AXI_GP1_AWPROT   (v_i_M_AXI_GP1_AWPROT),
    .i_M_AXI_GP1_AWQOS    (v_i_M_AXI_GP1_AWQOS),
    .i_M_AXI_GP1_AWVALID  (v_i_M_AXI_GP1_AWVALID),
    .i_M_AXI_GP1_WID      (v_i_M_AXI_GP1_WID),
    .i_M_AXI_GP1_WDATA    (v_i_M_AXI_GP1_WDATA),
    .i_M_AXI_GP1_WSTRB    (v_i_M_AXI_GP1_WSTRB),
    .i_M_AXI_GP1_WLAST    (v_i_M_AXI_GP1_WLAST),
    .i_M_AXI_GP1_WVALID   (v_i_M_AXI_GP1_WVALID),
    .i_M_AXI_GP1_BREADY   (v_i_M_AXI_GP1_BREADY),
    .i_M_AXI_GP1_ARID     (v_i_M_AXI_GP1_ARID),
    .i_M_AXI_GP1_ARADDR   (v_i_M_AXI_GP1_ARADDR),
    .i_M_AXI_GP1_ARLEN    (v_i_M_AXI_GP1_ARLEN),
    .i_M_AXI_GP1_ARSIZE   (v_i_M_AXI_GP1_ARSIZE),
    .i_M_AXI_GP1_ARBURST  (v_i_M_AXI_GP1_ARBURST),
    .i_M_AXI_GP1_ARLOCK   (v_i_M_AXI_GP1_ARLOCK),
    .i_M_AXI_GP1_ARCACHE  (v_i_M_AXI_GP1_ARCACHE),
    .i_M_AXI_GP1_ARPROT   (v_i_M_AXI_GP1_ARPROT),
    .i_M_AXI_GP1_ARQOS    (v_i_M_AXI_GP1_ARQOS),
    .i_M_AXI_GP1_ARVALID  (v_i_M_AXI_GP1_ARVALID),
    .i_M_AXI_GP1_RREADY   (v_i_M_AXI_GP1_RREADY),
    .o_M_AXI_GP1_AWREADY  (v_o_M_AXI_GP1_AWREADY),
    .o_M_AXI_GP1_WREADY   (v_o_M_AXI_GP1_WREADY),
    .o_M_AXI_GP1_BID      (v_o_M_AXI_GP1_BID),
    .o_M_AXI_GP1_BRESP    (v_o_M_AXI_GP1_BRESP),
    .o_M_AXI_GP1_BVALID   (v_o_M_AXI_GP1_BVALID),
    .o_M_AXI_GP1_ARREADY  (v_o_M_AXI_GP1_ARREADY),
    .o_M_AXI_GP1_RID      (v_o_M_AXI_GP1_RID),
    .o_M_AXI_GP1_RDATA    (v_o_M_AXI_GP1_RDATA),
    .o_M_AXI_GP1_RRESP    (v_o_M_AXI_GP1_RRESP),
    .o_M_AXI_GP1_RLAST    (v_o_M_AXI_GP1_RLAST),
    .o_M_AXI_GP1_RVALID   (v_o_M_AXI_GP1_RVALID),
    // }}} AXI from PS7 GP1

    .o_led                (v_o_led)
  );

  initial begin
    #30 ps7axim_write(0, 0, 5);
  end

endmodule