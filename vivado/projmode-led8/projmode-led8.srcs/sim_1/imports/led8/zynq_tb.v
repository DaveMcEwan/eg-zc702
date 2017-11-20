`timescale 1ns / 1ps

module tb;
    reg tb_ACLK;
    reg tb_ARESETn;

    wire temp_clk;
    wire temp_rstn;

    reg [31:0] read_data;
    wire [7:0] leds;
    reg resp;


    initial
    begin
        tb_ACLK = 1'b0;
    end

    //------------------------------------------------------------------------
    // Simple Clock Generator
    //------------------------------------------------------------------------

    always #10 tb_ACLK = !tb_ACLK;

    initial
    begin

        $display ("running the tb");

        tb_ARESETn = 1'b0;
        repeat(20)@(posedge tb_ACLK);
        tb_ARESETn = 1'b1;
        @(posedge tb_ACLK);

        repeat(5) @(posedge tb_ACLK);

        //Reset the PL
        tb.zynq_sys.led8_i.processing_system7_0.inst.fpga_soft_reset(32'h1);
        tb.zynq_sys.led8_i.processing_system7_0.inst.fpga_soft_reset(32'h0);

        //This drives the LEDs on the GPIO output
        tb.zynq_sys.led8_i.processing_system7_0.inst.write_data(32'h41200000,4, 32'hFFFFFFFF, resp);
        $display ("LEDs are toggled, observe the waveform");
        //Write into the BRAM through GP0 and read back
        tb.zynq_sys.led8_i.processing_system7_0.inst.write_data(32'h40000000,4, 32'hDEADBEEF, resp);
        tb.zynq_sys.led8_i.processing_system7_0.inst.read_data(32'h40000000,4,read_data,resp);
        $display ("%t, running the testbench, data read from BRAM was 32'h%x",$time, read_data);
        if(read_data == 32'hDEADBEEF) begin
           $display ("AXI VIP Test PASSED");
        end
        else begin
           $display ("AXI VIP Test FAILED");
        end
        $display ("Simulation completed");
        $stop;
    end

    assign temp_clk = tb_ACLK;
    assign temp_rstn = tb_ARESETn;

led8_wrapper zynq_sys
   (.DDR_addr(),
    .DDR_ba(),
    .DDR_cas_n(),
    .DDR_ck_n(),
    .DDR_ck_p(),
    .DDR_cke(),
    .DDR_cs_n(),
    .DDR_dm(),
    .DDR_dq(),
    .DDR_dqs_n(),
    .DDR_dqs_p(),
    .DDR_odt(),
    .DDR_ras_n(),
    .DDR_reset_n(),
    .DDR_we_n(),
    .FIXED_IO_ddr_vrn(),
    .FIXED_IO_ddr_vrp(),
    .FIXED_IO_mio(),
    .FIXED_IO_ps_clk(temp_clk),
    .FIXED_IO_ps_porb(temp_rstn ),
    .FIXED_IO_ps_srstb(temp_rstn),
    .LED8b_tri_o(leds));

endmodule

