/* wrapstd.c - Standard library functions wrapped in debug printers.
 * Dave McEwan 2017-11-08
 *
 * These commands should all return 0:
 *
 * 1. Format checking with clang-format default options.
 *  clang-format wrapstd.c | diff wrapstd.c
 *
 * 2. Compile to object with GCC.
 *  gcc -Wall -Wextra -c wrapstd.c -o wrapstd.o
 *
 * 3. Compile to object with clang.
 *  clang -Wall -Wextra -c wrapstd.c -o wrapstd.o
 *
 */

#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#include "wrapstd.h"

void wstd_dbg(int dbg, const char *format, ...) {
  if (dbg) {
    printf("DEBUG: ");
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
    printf("\n");
  }
}

long wstd_sysconf(int dbg, int name) {
  long r = sysconf(name);
  if (r == -1) {
    err(1, "sysconf(%d)", name);
  }
  wstd_dbg(dbg, "sysconf(%d) = %d", name, r);
  return r;
}

int wstd_open(int dbg, const char *path, int oflag) {
  int fd = open(path, oflag);
  if (fd == -1) {
    err(1, "open(%s, 0x%x)", path, oflag);
  }
  wstd_dbg(dbg, "open(%s, 0x%x) = %d", path, oflag, fd);
  return fd;
}

void wstd_close(int dbg, int fd) {
  int c = close(fd);
  if (c) {
    warn("close(%d)", fd);
  }
  wstd_dbg(dbg, "close(%d) = %d", fd, c);
}

int wstd_fstat(int dbg, int fd, struct stat *sb) {
  int s = fstat(fd, sb);
  if (s) {
    err(1, "fstat(%d, 0x%x)", fd, (uintptr_t)sb);
  }
  wstd_dbg(dbg, "fstat(%d, 0x%x) = %d", fd, (uintptr_t)sb, s);
  return s;
}

void *wstd_mmap(int dbg, void *addr, size_t len, int prot, int flags, int fd,
                off_t offset) {
  void *p = mmap(addr, len, prot, flags, fd, offset);
  if (p == MAP_FAILED) {
    err(1, "mmap(0x%x, %d, 0x%x, 0x%x, %d, 0x%x)", (uintptr_t)addr, (int)len,
        prot, flags, fd, (int)offset);
  }
  wstd_dbg(dbg, "mmap(0x%x, %d, 0x%x, 0x%x, %d, 0x%x) = 0x%x", (uintptr_t)addr,
           (int)len, prot, flags, fd, (int)offset, (uintptr_t)p);
  return p;
}

void wstd_munmap(int dbg, void *addr, size_t len) {
  int u = munmap(addr, len);
  if (u) {
    warn("munmap(0x%x, %d)", (uintptr_t)addr, (int)len);
  }
  wstd_dbg(dbg, "munmap(0x%x, %d) = %d", (uintptr_t)addr, (int)len, u);
}

void *wstd_mmap_devmem(int dbg, size_t len, off_t offset) {
  const char *path = "/dev/mem";
  int fd = wstd_open(dbg, path, O_RDWR);

  struct stat sb;
  wstd_fstat(dbg, fd, &sb);
  if (!S_ISCHR(sb.st_mode)) {
    errx(1, "Unexpected file type, not a character device: %s", path);
  }

  void *p = mmap(0,                      // addr
                 len,                    // len
                 PROT_READ | PROT_WRITE, // prot
                 MAP_SHARED,             // flags
                 fd,                     // fd
                 offset);                // offset
  if (p == MAP_FAILED) {
    err(1, "mmap(0, %d, PROT_READ|PROT_WRITE, MAP_SHARED,"
           " open(\"%s\", O_RDWR), 0x%x)",
        (int)len, path, (int)offset);
  }
  wstd_close(dbg, fd);
  wstd_dbg(dbg, "mmap(0, %d, PROT_READ|PROT_WRITE, MAP_SHARED,"
                " open(\"%s\", O_RDWR), 0x%x) = 0x%x",
           (int)len, path, (int)offset, (uintptr_t)p);
  return p;
}
