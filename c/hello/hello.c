/* hello.c - Simple example for realistic Makefile.
 * Dave McEwan 2017-11-17
 *
 * These commands should all return 0:
 *
 * 1. Format checking with clang-format default options.
 *  clang-format hello.c | diff hello.c -
 *
 * 2. Compile and link with GCC.
 *  gcc -Wall -Wextra another.c hello.c -o hello
 *
 * 3. Compile and link with clang.
 *  clang -Wall -Wextra another.c hello.c -o hello
 *
 * 4. Compile and link with makefile.
    make
 */

#include <stdio.h>

#include "another.h"

int main() {
  printf("Hello World!");
  printf(" my_rand() returned %d\n", my_rand(5));
}
