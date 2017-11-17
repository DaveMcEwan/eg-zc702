eg-zc702
========

Examples for the Xilinx Zynq development board ZC702.

The Zynq (hard dual-core ARM) will boot from the SD card quickly and run a
minimal linux environment which allows SSH access via a static IP
(`192.168.0.10`).
The Programmable Logic (PL) portion can be configured using the xdevcfg driver.

For more info about the on-chip linux environment and related modifications
please see `boot_sdcard/2016.2-mod/README.md`.

The host software required to modify the `boot_sdcard` files and compile C code
for the ARM cores is all available from the standard repositories.
Specifically, everything here is tested using Debian 9.2 (Stretch).

To modify the boot images you may need to install `u-boot-tools` via APT.
To compile software for the ARM you may need to install `gcc-arm-linux-gnueabi`
via APT.

Several make targets assume you have something similar to this in
`~/.ssh/config`:

    Host zc702
        Hostname 192.168.0.10
        User root
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
        LogLevel QUIET

When the Zynq core has booted this allows you to access a shell with
`ssh zc702` without dealing with the IP address or prompts every time.

The simplest Zynq C project is `hello` and should be tried before any others
because there is the least to go wrong.
