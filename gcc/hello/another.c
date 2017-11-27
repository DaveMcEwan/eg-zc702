/* another.c - Simple example for realistic Makefile.
 * Dave McEwan 2017-11-17
 *
 * These commands should all return 0:
 *
 * 1. Format checking with clang-format default options.
 *  clang-format another.c | diff another.c -
 *
 * 2. Compile to object with GCC.
 *  gcc -Wall -Wextra -c another.c -o another.o
 *
 * 3. Compile to object with clang.
 *  clang -Wall -Wextra -c another.c -o another.o
 *
 */

#include <stdlib.h>

#include "another.h"

int my_rand(int seed) {
  srand(seed);
  return rand();
}
