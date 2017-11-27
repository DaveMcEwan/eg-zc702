/* ps7axim.c
Drive the AXI master ports on ps7 (Zynq) on zc702.

Compile with Linux/arm-linux-gnueabi-gcc:
  arm-linux-gnueabi-gcc -Wall -Wextra -c -o wrapstd.o wrapstd.c
  arm-linux-gnueabi-gcc -Wall -Wextra -static ps7axim.c wrapstd.o -o ps7axim

Usage in Linux: ps7axim [-v] [-d] -p (0|1) [-r] [-w <value>] <offset>

To control the LEDs in the configuration from pl.bit given in 2016.2-mod:
# On zc702, configure the PL.
cat pl.bit > /dev/xdevcfg
# On host, build and transfer the binary.
make && make transfer
# On zc702, run the binary to print the current pattern.
./ps7axim --read 0x120_0000
# On zc702, run the binary to change the current pattern.
./ps7axim --write=0xaa 0x120_0000

Note the address offset 0x120_0000 is derived from the value shown in the
Address Editor of 0x4120_0000, where port 0 has a fixed offset of 0x4000_0000
Underscore are not necessary and are optional just for clarity.
*/

#include <argp.h>
#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "wrapstd.h"

#if __STDC_VERSION__ < 199901L
#if __GNUC__ >= 2
#define __func__ __FUNCTION__
#else
#define __func__ "<unknown>"
#endif
#endif

#define ZYNQ_M_AXI_GP0_BASEADDR (0x40000000)
#define ZYNQ_M_AXI_GP1_BASEADDR (0x80000000)
#define ZYNQ_M_AXI_GP0_SIZE (1 << 30)
#define ZYNQ_M_AXI_GP1_SIZE (1 << 30)

// {{{ argp

#define ARGP_N_POS 1

struct arguments {
  int debug;
  bool verbose;
  int unsigned port;
  char *args[ARGP_N_POS]; // Only 1 mandatory argument: offset
  bool read;
  bool write;
  uint32_t write_value;
  size_t length;
};

const char *argp_program_version = "ps7axim 0.1";
const char *argp_program_bug_address = "<dave.mcewan@bristol.ac.uk>";

static struct argp_option options[] = {
    // name, key, arg, flags, doc, group
    {"debug", 'd', 0, 0, "Print debug info.", 0},
    {"verbose", 'v', 0, 0, "Verbose mode, useful for logfiles.", 0},
    {"port", 'p', "(0|1)", 0, "Number of AXI master port. Default 0.", 0},
    {"read", 'r', 0, 0, "Perform read, printing result to STDOUT.", 0},
    {"write", 'w', "<value>", 0, "Perform write.", 0},
    {"length", 'l', "(1|2|4)", 0, "Access length in bytes. Default 4", 0},
    {0}};

void rm_uscores(char *rd) {
  char *wr = rd;
  char c;
  while ((c = *rd++) != '\0') {
    if (c != '_')
      *wr++ = c;
  }
  *wr = '\0';
}

static error_t parse_opt(int key, char *arg, struct argp_state *state) {
  struct arguments *args = state->input;

  switch (key) {
  case 'd':
    args->debug = 1;
    break;
  case 'v':
    args->verbose = 1;
    break;
  case 'p':
    args->port = strtol(arg, NULL, 10);
    break;
  case 'r':
    args->read = true;
    break;
  case 'w':
    args->write = true;
    rm_uscores(arg);
    args->write_value = strtol(arg, NULL, 0);
    break;
  case 'l':
    args->length = strtol(arg, NULL, 10);
    break;

  case ARGP_KEY_ARG:
    // Too many arguments.
    if (state->arg_num >= ARGP_N_POS)
      argp_usage(state);
    args->args[state->arg_num] = arg;
    break;
  case ARGP_KEY_END:
    // Not enough arguments.
    if (state->arg_num < ARGP_N_POS)
      argp_usage(state);
    break;
  default:
    return ARGP_ERR_UNKNOWN;
  }

  return 0;
}

static char args_doc[] = "<offset>";

static char doc[] = "Drive AXI master port on ps7 (Zynq).";

static struct argp argp = {options, parse_opt, args_doc, doc, 0, 0, 0};

// }}} argp

void *mmap_M_AXI_GPx(int dbg, int unsigned port, size_t len,
                     int unsigned offset) {
  int unsigned lower_mmap;
  int unsigned size_mmap;
  switch (port) {
  case 0:
    lower_mmap = ZYNQ_M_AXI_GP0_BASEADDR;
    size_mmap = ZYNQ_M_AXI_GP0_SIZE;
    break;
  case 1:
    lower_mmap = ZYNQ_M_AXI_GP1_BASEADDR;
    size_mmap = ZYNQ_M_AXI_GP1_SIZE;
    break;
  default:
    errx(1, "%s(port=%d),"
            " Only 0..1 accepted.",
         __func__, port);
    break;
  }

  switch (len) {
  case 1:
  case 2:
  case 4:
    break;
  default:
    errx(1, "%s(len=%d),"
            " Only 1,2,4 accepted.",
         __func__, len);
  }

  int unsigned size_req = offset + len;
  if (size_req > size_mmap) {
    errx(1, "%s(len=%d, offset=0x%x),"
            " len+offset exceeds upper size limit 0x%x",
         __func__, len, offset, size_mmap);
  }

  off_t offset_req = lower_mmap + offset;
  void *p = wstd_mmap_devmem(dbg, len, offset_req);

  wstd_dbg(dbg, "%s(%d, %d, 0x%x) = 0x%x", __func__, port, len, offset,
           (uintptr_t)p);
  return p;
}

uint32_t ps7axim_read(bool verb, int dbg, int unsigned port,
                          uintptr_t offset, size_t len) {
  if (verb) {
    printf("%s\tport=%d\toffset=0x%08x\tlen=%d", __func__, port, offset, len);
    printf((dbg) ? "\n" : "\t");
  }

  uint32_t r = 0xDEADDEAD;
  volatile uint32_t *p = mmap_M_AXI_GPx(dbg, port, len, offset);

  r = *p; // Perform actual read.

  wstd_munmap(dbg, (void *)offset, len);

  return r;
}

void ps7axim_write(bool verb, int dbg, int unsigned port, uintptr_t offset,
                   uint32_t value, size_t len) {
  if (verb)
    printf("%s\tport=%d\toffset=0x%08x\tlen=%d\tvalue=0x%08x\n", __func__, port,
           offset, len, value);

  volatile uint32_t *p = mmap_M_AXI_GPx(dbg, port, len, offset);

  *p = value; // Perform actual write.

  wstd_munmap(dbg, (void *)offset, len);

  return;
}

int main(int argc, char **argv) {

  struct arguments args;
  args.debug = 0;
  args.verbose = false;
  args.port = 0;
  args.read = false;
  args.write = false;
  args.length = 4;
  argp_parse(&argp, argc, argv, 0, 0, &args);
  rm_uscores(args.args[0]);
  int unsigned offset = strtol(args.args[0], NULL, 0);

  if (args.read) {
    uint32_t r = ps7axim_read(args.verbose, args.debug, args.port, offset,
                              args.length);
    printf("%s0x%08x\n", (args.verbose) ? "value=" : "", r);
  }

  if (args.write)
    ps7axim_write(args.verbose, args.debug, args.port, offset, args.write_value,
                  args.length);

  return 0;
}
