
`timescale 1 ps / 1 ps

module top_m (
  // ps7 IO, common to almost every Zynq project.
  inout  wire [14:0]    DDR_addr,
  inout  wire [2:0]     DDR_ba,
  inout  wire           DDR_cas_n,
  inout  wire           DDR_ck_n,
  inout  wire           DDR_ck_p,
  inout  wire           DDR_cke,
  inout  wire           DDR_cs_n,
  inout  wire [3:0]     DDR_dm,
  inout  wire [31:0]    DDR_dq,
  inout  wire [3:0]     DDR_dqs_n,
  inout  wire [3:0]     DDR_dqs_p,
  inout  wire           DDR_odt,
  inout  wire           DDR_ras_n,
  inout  wire           DDR_reset_n,
  inout  wire           DDR_we_n,
  inout  wire           FIXED_IO_ddr_vrn,
  inout  wire           FIXED_IO_ddr_vrp,
  inout  wire [53:0]    FIXED_IO_mio,
  inout  wire           FIXED_IO_ps_srstb,
  inout  wire           FIXED_IO_ps_clk,
  inout  wire           FIXED_IO_ps_porb,

  // project-specific IO.
  output wire [7:0]     o_led
);

// ps7 and rst wires and instances, common to almost every Zynq project.

  // {{{ ps7 wires
  wire          ps7_o_M_AXI_GP0_ARVALID;
  wire          ps7_o_M_AXI_GP0_AWVALID;
  wire          ps7_o_M_AXI_GP0_BREADY;
  wire          ps7_o_M_AXI_GP0_RREADY;
  wire          ps7_o_M_AXI_GP0_WLAST;
  wire          ps7_o_M_AXI_GP0_WVALID;
  wire [11:0]   ps7_o_M_AXI_GP0_ARID;
  wire [11:0]   ps7_o_M_AXI_GP0_AWID;
  wire [11:0]   ps7_o_M_AXI_GP0_WID;
  wire [1:0]    ps7_o_M_AXI_GP0_ARBURST;
  wire [1:0]    ps7_o_M_AXI_GP0_ARLOCK;
  wire [2:0]    ps7_o_M_AXI_GP0_ARSIZE;
  wire [1:0]    ps7_o_M_AXI_GP0_AWBURST;
  wire [1:0]    ps7_o_M_AXI_GP0_AWLOCK;
  wire [2:0]    ps7_o_M_AXI_GP0_AWSIZE;
  wire [2:0]    ps7_o_M_AXI_GP0_ARPROT;
  wire [2:0]    ps7_o_M_AXI_GP0_AWPROT;
  wire [31:0]   ps7_o_M_AXI_GP0_ARADDR;
  wire [31:0]   ps7_o_M_AXI_GP0_AWADDR;
  wire [31:0]   ps7_o_M_AXI_GP0_WDATA;
  wire [3:0]    ps7_o_M_AXI_GP0_ARCACHE;
  wire [3:0]    ps7_o_M_AXI_GP0_ARLEN;
  wire [3:0]    ps7_o_M_AXI_GP0_ARQOS;
  wire [3:0]    ps7_o_M_AXI_GP0_AWCACHE;
  wire [3:0]    ps7_o_M_AXI_GP0_AWLEN;
  wire [3:0]    ps7_o_M_AXI_GP0_AWQOS;
  wire [3:0]    ps7_o_M_AXI_GP0_WSTRB;

  wire          ps7_i_M_AXI_GP0_ARREADY;
  wire          ps7_i_M_AXI_GP0_AWREADY;
  wire          ps7_i_M_AXI_GP0_BVALID;
  wire          ps7_i_M_AXI_GP0_RLAST;
  wire          ps7_i_M_AXI_GP0_RVALID;
  wire          ps7_i_M_AXI_GP0_WREADY;
  wire [11:0]   ps7_i_M_AXI_GP0_BID;
  wire [11:0]   ps7_i_M_AXI_GP0_RID;
  wire [1:0]    ps7_i_M_AXI_GP0_BRESP;
  wire [1:0]    ps7_i_M_AXI_GP0_RRESP;
  wire [31:0]   ps7_i_M_AXI_GP0_RDATA;

  wire          ps7_o_M_AXI_GP1_ARVALID;
  wire          ps7_o_M_AXI_GP1_AWVALID;
  wire          ps7_o_M_AXI_GP1_BREADY;
  wire          ps7_o_M_AXI_GP1_RREADY;
  wire          ps7_o_M_AXI_GP1_WLAST;
  wire          ps7_o_M_AXI_GP1_WVALID;
  wire [11:0]   ps7_o_M_AXI_GP1_ARID;
  wire [11:0]   ps7_o_M_AXI_GP1_AWID;
  wire [11:0]   ps7_o_M_AXI_GP1_WID;
  wire [1:0]    ps7_o_M_AXI_GP1_ARBURST;
  wire [1:0]    ps7_o_M_AXI_GP1_ARLOCK;
  wire [2:0]    ps7_o_M_AXI_GP1_ARSIZE;
  wire [1:0]    ps7_o_M_AXI_GP1_AWBURST;
  wire [1:0]    ps7_o_M_AXI_GP1_AWLOCK;
  wire [2:0]    ps7_o_M_AXI_GP1_AWSIZE;
  wire [2:0]    ps7_o_M_AXI_GP1_ARPROT;
  wire [2:0]    ps7_o_M_AXI_GP1_AWPROT;
  wire [31:0]   ps7_o_M_AXI_GP1_ARADDR;
  wire [31:0]   ps7_o_M_AXI_GP1_AWADDR;
  wire [31:0]   ps7_o_M_AXI_GP1_WDATA;
  wire [3:0]    ps7_o_M_AXI_GP1_ARCACHE;
  wire [3:0]    ps7_o_M_AXI_GP1_ARLEN;
  wire [3:0]    ps7_o_M_AXI_GP1_ARQOS;
  wire [3:0]    ps7_o_M_AXI_GP1_AWCACHE;
  wire [3:0]    ps7_o_M_AXI_GP1_AWLEN;
  wire [3:0]    ps7_o_M_AXI_GP1_AWQOS;
  wire [3:0]    ps7_o_M_AXI_GP1_WSTRB;

  wire          ps7_i_M_AXI_GP1_ARREADY;
  wire          ps7_i_M_AXI_GP1_AWREADY;
  wire          ps7_i_M_AXI_GP1_BVALID;
  wire          ps7_i_M_AXI_GP1_RLAST;
  wire          ps7_i_M_AXI_GP1_RVALID;
  wire          ps7_i_M_AXI_GP1_WREADY;
  wire [11:0]   ps7_i_M_AXI_GP1_BID;
  wire [11:0]   ps7_i_M_AXI_GP1_RID;
  wire [1:0]    ps7_i_M_AXI_GP1_BRESP;
  wire [1:0]    ps7_i_M_AXI_GP1_RRESP;
  wire [31:0]   ps7_i_M_AXI_GP1_RDATA;

  wire          ps7_o_TTC0_WAVE0_OUT;
  wire          ps7_o_TTC0_WAVE1_OUT;
  wire          ps7_o_TTC0_WAVE2_OUT;

  wire [1:0]    ps7_o_USB0_PORT_INDCTL;
  wire          ps7_o_USB0_VBUS_PWRSELECT;
  wire          ps7_o_FCLK_CLK0;
  wire          ps7_o_FCLK_RESET0_N;
  // }}} ps7 wires
  ps7_m ps7_u ( // {{{
    .M_AXI_GP0_ARVALID  (ps7_o_M_AXI_GP0_ARVALID),
    .M_AXI_GP0_AWVALID  (ps7_o_M_AXI_GP0_AWVALID),
    .M_AXI_GP0_BREADY   (ps7_o_M_AXI_GP0_BREADY),
    .M_AXI_GP0_RREADY   (ps7_o_M_AXI_GP0_RREADY),
    .M_AXI_GP0_WLAST    (ps7_o_M_AXI_GP0_WLAST),
    .M_AXI_GP0_WVALID   (ps7_o_M_AXI_GP0_WVALID),
    .M_AXI_GP0_ARID     (ps7_o_M_AXI_GP0_ARID),
    .M_AXI_GP0_AWID     (ps7_o_M_AXI_GP0_AWID),
    .M_AXI_GP0_WID      (ps7_o_M_AXI_GP0_WID),
    .M_AXI_GP0_ARBURST  (ps7_o_M_AXI_GP0_ARBURST),
    .M_AXI_GP0_ARLOCK   (ps7_o_M_AXI_GP0_ARLOCK),
    .M_AXI_GP0_ARSIZE   (ps7_o_M_AXI_GP0_ARSIZE),
    .M_AXI_GP0_AWBURST  (ps7_o_M_AXI_GP0_AWBURST),
    .M_AXI_GP0_AWLOCK   (ps7_o_M_AXI_GP0_AWLOCK),
    .M_AXI_GP0_AWSIZE   (ps7_o_M_AXI_GP0_AWSIZE),
    .M_AXI_GP0_ARPROT   (ps7_o_M_AXI_GP0_ARPROT),
    .M_AXI_GP0_AWPROT   (ps7_o_M_AXI_GP0_AWPROT),
    .M_AXI_GP0_ARADDR   (ps7_o_M_AXI_GP0_ARADDR),
    .M_AXI_GP0_AWADDR   (ps7_o_M_AXI_GP0_AWADDR),
    .M_AXI_GP0_WDATA    (ps7_o_M_AXI_GP0_WDATA),
    .M_AXI_GP0_ARCACHE  (ps7_o_M_AXI_GP0_ARCACHE),
    .M_AXI_GP0_ARLEN    (ps7_o_M_AXI_GP0_ARLEN),
    .M_AXI_GP0_ARQOS    (ps7_o_M_AXI_GP0_ARQOS),
    .M_AXI_GP0_AWCACHE  (ps7_o_M_AXI_GP0_AWCACHE),
    .M_AXI_GP0_AWLEN    (ps7_o_M_AXI_GP0_AWLEN),
    .M_AXI_GP0_AWQOS    (ps7_o_M_AXI_GP0_AWQOS),
    .M_AXI_GP0_WSTRB    (ps7_o_M_AXI_GP0_WSTRB),
    .M_AXI_GP0_ACLK     (ps7_o_FCLK_CLK0),
    .M_AXI_GP0_ARREADY  (ps7_i_M_AXI_GP0_ARREADY),
    .M_AXI_GP0_AWREADY  (ps7_i_M_AXI_GP0_AWREADY),
    .M_AXI_GP0_BVALID   (ps7_i_M_AXI_GP0_BVALID),
    .M_AXI_GP0_RLAST    (ps7_i_M_AXI_GP0_RLAST),
    .M_AXI_GP0_RVALID   (ps7_i_M_AXI_GP0_RVALID),
    .M_AXI_GP0_WREADY   (ps7_i_M_AXI_GP0_WREADY),
    .M_AXI_GP0_BID      (ps7_i_M_AXI_GP0_BID),
    .M_AXI_GP0_RID      (ps7_i_M_AXI_GP0_RID),
    .M_AXI_GP0_BRESP    (ps7_i_M_AXI_GP0_BRESP),
    .M_AXI_GP0_RRESP    (ps7_i_M_AXI_GP0_RRESP),
    .M_AXI_GP0_RDATA    (ps7_i_M_AXI_GP0_RDATA),

    .M_AXI_GP1_ARVALID  (ps7_o_M_AXI_GP1_ARVALID),
    .M_AXI_GP1_AWVALID  (ps7_o_M_AXI_GP1_AWVALID),
    .M_AXI_GP1_BREADY   (ps7_o_M_AXI_GP1_BREADY),
    .M_AXI_GP1_RREADY   (ps7_o_M_AXI_GP1_RREADY),
    .M_AXI_GP1_WLAST    (ps7_o_M_AXI_GP1_WLAST),
    .M_AXI_GP1_WVALID   (ps7_o_M_AXI_GP1_WVALID),
    .M_AXI_GP1_ARID     (ps7_o_M_AXI_GP1_ARID),
    .M_AXI_GP1_AWID     (ps7_o_M_AXI_GP1_AWID),
    .M_AXI_GP1_WID      (ps7_o_M_AXI_GP1_WID),
    .M_AXI_GP1_ARBURST  (ps7_o_M_AXI_GP1_ARBURST),
    .M_AXI_GP1_ARLOCK   (ps7_o_M_AXI_GP1_ARLOCK),
    .M_AXI_GP1_ARSIZE   (ps7_o_M_AXI_GP1_ARSIZE),
    .M_AXI_GP1_AWBURST  (ps7_o_M_AXI_GP1_AWBURST),
    .M_AXI_GP1_AWLOCK   (ps7_o_M_AXI_GP1_AWLOCK),
    .M_AXI_GP1_AWSIZE   (ps7_o_M_AXI_GP1_AWSIZE),
    .M_AXI_GP1_ARPROT   (ps7_o_M_AXI_GP1_ARPROT),
    .M_AXI_GP1_AWPROT   (ps7_o_M_AXI_GP1_AWPROT),
    .M_AXI_GP1_ARADDR   (ps7_o_M_AXI_GP1_ARADDR),
    .M_AXI_GP1_AWADDR   (ps7_o_M_AXI_GP1_AWADDR),
    .M_AXI_GP1_WDATA    (ps7_o_M_AXI_GP1_WDATA),
    .M_AXI_GP1_ARCACHE  (ps7_o_M_AXI_GP1_ARCACHE),
    .M_AXI_GP1_ARLEN    (ps7_o_M_AXI_GP1_ARLEN),
    .M_AXI_GP1_ARQOS    (ps7_o_M_AXI_GP1_ARQOS),
    .M_AXI_GP1_AWCACHE  (ps7_o_M_AXI_GP1_AWCACHE),
    .M_AXI_GP1_AWLEN    (ps7_o_M_AXI_GP1_AWLEN),
    .M_AXI_GP1_AWQOS    (ps7_o_M_AXI_GP1_AWQOS),
    .M_AXI_GP1_WSTRB    (ps7_o_M_AXI_GP1_WSTRB),
    .M_AXI_GP1_ACLK     (ps7_o_FCLK_CLK0),
    .M_AXI_GP1_ARREADY  (ps7_i_M_AXI_GP1_ARREADY),
    .M_AXI_GP1_AWREADY  (ps7_i_M_AXI_GP1_AWREADY),
    .M_AXI_GP1_BVALID   (ps7_i_M_AXI_GP1_BVALID),
    .M_AXI_GP1_RLAST    (ps7_i_M_AXI_GP1_RLAST),
    .M_AXI_GP1_RVALID   (ps7_i_M_AXI_GP1_RVALID),
    .M_AXI_GP1_WREADY   (ps7_i_M_AXI_GP1_WREADY),
    .M_AXI_GP1_BID      (ps7_i_M_AXI_GP1_BID),
    .M_AXI_GP1_RID      (ps7_i_M_AXI_GP1_RID),
    .M_AXI_GP1_BRESP    (ps7_i_M_AXI_GP1_BRESP),
    .M_AXI_GP1_RRESP    (ps7_i_M_AXI_GP1_RRESP),
    .M_AXI_GP1_RDATA    (ps7_i_M_AXI_GP1_RDATA),

    .MIO                (FIXED_IO_mio[53:0]),

    .DDR_CAS_n          (DDR_cas_n),
    .DDR_CKE            (DDR_cke),
    .DDR_Clk_n          (DDR_ck_n),
    .DDR_Clk            (DDR_ck_p),
    .DDR_CS_n           (DDR_cs_n),
    .DDR_DRSTB          (DDR_reset_n),
    .DDR_ODT            (DDR_odt),
    .DDR_RAS_n          (DDR_ras_n),
    .DDR_WEB            (DDR_we_n),
    .DDR_BankAddr       (DDR_ba[2:0]),
    .DDR_Addr           (DDR_addr[14:0]),
    .DDR_VRN            (FIXED_IO_ddr_vrn),
    .DDR_VRP            (FIXED_IO_ddr_vrp),
    .DDR_DM             (DDR_dm[3:0]),
    .DDR_DQ             (DDR_dq[31:0]),
    .DDR_DQS_n          (DDR_dqs_n[3:0]),
    .DDR_DQS            (DDR_dqs_p[3:0]),

    .TTC0_WAVE0_OUT     (ps7_o_TTC0_WAVE0_OUT),
    .TTC0_WAVE1_OUT     (ps7_o_TTC0_WAVE1_OUT),
    .TTC0_WAVE2_OUT     (ps7_o_TTC0_WAVE2_OUT),

    .USB0_PORT_INDCTL   (ps7_o_USB0_PORT_INDCTL),
    .USB0_VBUS_PWRSELECT(ps7_o_USB0_VBUS_PWRSELECT),
    .USB0_VBUS_PWRFAULT (1'b0),

    .FCLK_CLK0          (ps7_o_FCLK_CLK0),
    .FCLK_RESET0_N      (ps7_o_FCLK_RESET0_N),
    .PS_SRSTB           (FIXED_IO_ps_srstb),
    .PS_CLK             (FIXED_IO_ps_clk),
    .PS_PORB            (FIXED_IO_ps_porb)
  ); // }}}

  // {{{ rst wires
  wire          rst_o_interconnect_aresetn;
  wire          rst_o_peripheral_aresetn;
  // }}} rst wires
  rst_m rst_u ( // {{{
    .slowest_sync_clk       (ps7_o_FCLK_CLK0),
    .aux_reset_in           (1'b1),
    .dcm_locked             (1'b1),
    .mb_debug_sys_rst       (1'b0),
    .ext_reset_in           (ps7_o_FCLK_RESET0_N),
    .interconnect_aresetn   (rst_o_interconnect_aresetn),
    .peripheral_aresetn     (rst_o_peripheral_aresetn)
  ); // }}}

// project-specific logic, wires and instances.
  pl_m pl_u ( // {{{
    .i_clk0(ps7_o_FCLK_CLK0),
    .i_ic_rst(rst_o_interconnect_aresetn),
    .i_rst(rst_o_peripheral_aresetn),

    // {{{ AXI ports from PS7
    .i_M_AXI_GP0_ARVALID(ps7_o_M_AXI_GP0_ARVALID),
    .i_M_AXI_GP0_AWVALID(ps7_o_M_AXI_GP0_AWVALID),
    .i_M_AXI_GP0_BREADY (ps7_o_M_AXI_GP0_BREADY),
    .i_M_AXI_GP0_RREADY (ps7_o_M_AXI_GP0_RREADY),
    .i_M_AXI_GP0_WLAST  (ps7_o_M_AXI_GP0_WLAST),
    .i_M_AXI_GP0_WVALID (ps7_o_M_AXI_GP0_WVALID),
    .i_M_AXI_GP0_ARID   (ps7_o_M_AXI_GP0_ARID),
    .i_M_AXI_GP0_AWID   (ps7_o_M_AXI_GP0_AWID),
    .i_M_AXI_GP0_WID    (ps7_o_M_AXI_GP0_WID),
    .i_M_AXI_GP0_ARBURST(ps7_o_M_AXI_GP0_ARBURST),
    .i_M_AXI_GP0_ARLOCK (ps7_o_M_AXI_GP0_ARLOCK),
    .i_M_AXI_GP0_ARSIZE (ps7_o_M_AXI_GP0_ARSIZE),
    .i_M_AXI_GP0_AWBURST(ps7_o_M_AXI_GP0_AWBURST),
    .i_M_AXI_GP0_AWLOCK (ps7_o_M_AXI_GP0_AWLOCK),
    .i_M_AXI_GP0_AWSIZE (ps7_o_M_AXI_GP0_AWSIZE),
    .i_M_AXI_GP0_ARPROT (ps7_o_M_AXI_GP0_ARPROT),
    .i_M_AXI_GP0_AWPROT (ps7_o_M_AXI_GP0_AWPROT),
    .i_M_AXI_GP0_ARADDR (ps7_o_M_AXI_GP0_ARADDR),
    .i_M_AXI_GP0_AWADDR (ps7_o_M_AXI_GP0_AWADDR),
    .i_M_AXI_GP0_WDATA  (ps7_o_M_AXI_GP0_WDATA),
    .i_M_AXI_GP0_ARCACHE(ps7_o_M_AXI_GP0_ARCACHE),
    .i_M_AXI_GP0_ARLEN  (ps7_o_M_AXI_GP0_ARLEN),
    .i_M_AXI_GP0_ARQOS  (ps7_o_M_AXI_GP0_ARQOS),
    .i_M_AXI_GP0_AWCACHE(ps7_o_M_AXI_GP0_AWCACHE),
    .i_M_AXI_GP0_AWLEN  (ps7_o_M_AXI_GP0_AWLEN),
    .i_M_AXI_GP0_AWQOS  (ps7_o_M_AXI_GP0_AWQOS),
    .i_M_AXI_GP0_WSTRB  (ps7_o_M_AXI_GP0_WSTRB),
    .o_M_AXI_GP0_ARREADY(ps7_i_M_AXI_GP0_ARREADY),
    .o_M_AXI_GP0_AWREADY(ps7_i_M_AXI_GP0_AWREADY),
    .o_M_AXI_GP0_BVALID (ps7_i_M_AXI_GP0_BVALID),
    .o_M_AXI_GP0_RLAST  (ps7_i_M_AXI_GP0_RLAST),
    .o_M_AXI_GP0_RVALID (ps7_i_M_AXI_GP0_RVALID),
    .o_M_AXI_GP0_WREADY (ps7_i_M_AXI_GP0_WREADY),
    .o_M_AXI_GP0_BID    (ps7_i_M_AXI_GP0_BID),
    .o_M_AXI_GP0_RID    (ps7_i_M_AXI_GP0_RID),
    .o_M_AXI_GP0_BRESP  (ps7_i_M_AXI_GP0_BRESP),
    .o_M_AXI_GP0_RRESP  (ps7_i_M_AXI_GP0_RRESP),
    .o_M_AXI_GP0_RDATA  (ps7_i_M_AXI_GP0_RDATA),

    .i_M_AXI_GP1_ARVALID(ps7_o_M_AXI_GP1_ARVALID),
    .i_M_AXI_GP1_AWVALID(ps7_o_M_AXI_GP1_AWVALID),
    .i_M_AXI_GP1_BREADY (ps7_o_M_AXI_GP1_BREADY),
    .i_M_AXI_GP1_RREADY (ps7_o_M_AXI_GP1_RREADY),
    .i_M_AXI_GP1_WLAST  (ps7_o_M_AXI_GP1_WLAST),
    .i_M_AXI_GP1_WVALID (ps7_o_M_AXI_GP1_WVALID),
    .i_M_AXI_GP1_ARID   (ps7_o_M_AXI_GP1_ARID),
    .i_M_AXI_GP1_AWID   (ps7_o_M_AXI_GP1_AWID),
    .i_M_AXI_GP1_WID    (ps7_o_M_AXI_GP1_WID),
    .i_M_AXI_GP1_ARBURST(ps7_o_M_AXI_GP1_ARBURST),
    .i_M_AXI_GP1_ARLOCK (ps7_o_M_AXI_GP1_ARLOCK),
    .i_M_AXI_GP1_ARSIZE (ps7_o_M_AXI_GP1_ARSIZE),
    .i_M_AXI_GP1_AWBURST(ps7_o_M_AXI_GP1_AWBURST),
    .i_M_AXI_GP1_AWLOCK (ps7_o_M_AXI_GP1_AWLOCK),
    .i_M_AXI_GP1_AWSIZE (ps7_o_M_AXI_GP1_AWSIZE),
    .i_M_AXI_GP1_ARPROT (ps7_o_M_AXI_GP1_ARPROT),
    .i_M_AXI_GP1_AWPROT (ps7_o_M_AXI_GP1_AWPROT),
    .i_M_AXI_GP1_ARADDR (ps7_o_M_AXI_GP1_ARADDR),
    .i_M_AXI_GP1_AWADDR (ps7_o_M_AXI_GP1_AWADDR),
    .i_M_AXI_GP1_WDATA  (ps7_o_M_AXI_GP1_WDATA),
    .i_M_AXI_GP1_ARCACHE(ps7_o_M_AXI_GP1_ARCACHE),
    .i_M_AXI_GP1_ARLEN  (ps7_o_M_AXI_GP1_ARLEN),
    .i_M_AXI_GP1_ARQOS  (ps7_o_M_AXI_GP1_ARQOS),
    .i_M_AXI_GP1_AWCACHE(ps7_o_M_AXI_GP1_AWCACHE),
    .i_M_AXI_GP1_AWLEN  (ps7_o_M_AXI_GP1_AWLEN),
    .i_M_AXI_GP1_AWQOS  (ps7_o_M_AXI_GP1_AWQOS),
    .i_M_AXI_GP1_WSTRB  (ps7_o_M_AXI_GP1_WSTRB),
    .o_M_AXI_GP1_ARREADY(ps7_i_M_AXI_GP1_ARREADY),
    .o_M_AXI_GP1_AWREADY(ps7_i_M_AXI_GP1_AWREADY),
    .o_M_AXI_GP1_BVALID (ps7_i_M_AXI_GP1_BVALID),
    .o_M_AXI_GP1_RLAST  (ps7_i_M_AXI_GP1_RLAST),
    .o_M_AXI_GP1_RVALID (ps7_i_M_AXI_GP1_RVALID),
    .o_M_AXI_GP1_WREADY (ps7_i_M_AXI_GP1_WREADY),
    .o_M_AXI_GP1_BID    (ps7_i_M_AXI_GP1_BID),
    .o_M_AXI_GP1_RID    (ps7_i_M_AXI_GP1_RID),
    .o_M_AXI_GP1_BRESP  (ps7_i_M_AXI_GP1_BRESP),
    .o_M_AXI_GP1_RRESP  (ps7_i_M_AXI_GP1_RRESP),
    .o_M_AXI_GP1_RDATA  (ps7_i_M_AXI_GP1_RDATA),
    // }}}

    .o_led(o_led)
  ); // }}}

endmodule
