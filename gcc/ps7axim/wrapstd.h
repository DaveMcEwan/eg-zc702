/* wrapstd.h - Standard library functions wrapped in debug printers.
 * Dave McEwan 2017-11-08
 */

#ifndef _WRAPSTD_H
#define _WRAPSTD_H

void wstd_dbg(int dbg, const char *format, ...);
long wstd_sysconf(int dbg, int name);
int wstd_open(int dbg, const char *path, int oflag);
void wstd_close(int dbg, int fd);
int wstd_fstat(int dbg, int fd, struct stat *sb);
void *wstd_mmap(int dbg, void *addr, size_t len, int prot, int flags,
              int fd, off_t offset);
void wstd_munmap(int dbg, void *addr, size_t len);
void *wstd_mmap_devmem(int dbg, size_t len, off_t offset);

uintptr_t wstd_pagemask();
uintptr_t wstd_pagemaskn();

#endif
