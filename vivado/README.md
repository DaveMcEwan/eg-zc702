Vivado
======

These are example Vivado projects for generating bitstream files suitable for
congfiguring the Programmable Logic (PL) part of the Zynq FPGA.


projmode-led8
-------------

This is the simplest Vivado project and runs in "Project Mode" where Vivado
provides all workflow infrastructure and integration with the GUI.
The goal is to generate a bitstream equivalent to the one provided with the
2016.2-mod boot image files called `pl.bit`.
To get started:

- `cd projmode-led8`
- Start the Vivado GUI and recreate the project
    `vivado -source recreate.tcl`
- Make design changes (optional, skip this first time)
- On LHS of the GUI click "Generate Bitstream"
    - Once finished running (a few minutes) a bitstream file will be available
      as `projmode-led8.runs/impl_1/led8_wrapper.bit`
- Test the new bitstream
    - `scp led8_wrapper.bit zc702:~/`
    - `ssh zc702 -C "cat led8_wrapper.bit > /dev/xdevcfg"`
    - The LEDs should be in the pattern 0x55.

Note that this method of using the GUI requires much more care and attention
with respect to source control.
Non-project mode which doesn't rely on the GUI so much is an easier option to
use with source control.
