/* wrapstd.h - Common utility functions.
 * Dave McEwan 2017-11-08
 */

#ifndef _WRAPSTD_H
#define _WRAPSTD_H

void wstd_dbg(int dbg, const char *format, ...);
int wstd_open(int dbg, const char *path, int oflag);
void wstd_close(int dbg, int fd);
int wstd_fstat(int dbg, int fd, struct stat *sb);
void *wstd_mmap(int dbg, void *addr, size_t len, int prot, int flags,
              int fd, off_t offset);
void wstd_munmap(int dbg, void *addr, size_t len);
void *wstd_mmap_devmem(int dbg, size_t len, off_t offset);

#endif
