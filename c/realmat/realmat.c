/* realmat.c
Info and analysis on matrices of reals.
Take a file containing an ascii matrix of real numbers, do some analysis, and
print results to STDOUT in YAML format for use by other tools.

Everything contained in one file.

Dave McEwan
2017-11-19

Compile with Linux/GCC:
  gcc -Wall -Wextra -static realmat.c -lm -o realmat
Compile with Windows/MinGW:
  gcc -Wall -Wextra -o realmat realmat.c -lm -std=c99
Compile with Windows/VisualStudio:
  cl realmat.c
Compile with Linux/arm-linux-gnueabi-gcc:
  arm-linux-gnueabi-gcc -Wall -Wextra -static realmat.c -lm -o realmat

Usage in Linux: realmat [-i] [-n <maxiter>] [-e <epsilon>] <filename>
Usage in Win32: realmat <filename> [<maxiter>] [<epsilon>]\n");
*/

// {{{ setup

#define min(a, b)                                                              \
  ({                                                                           \
    __typeof__(a) _a = (a);                                                    \
    __typeof__(b) _b = (b);                                                    \
    _a < _b ? _a : _b;                                                         \
  })

#define max(a, b)                                                              \
  ({                                                                           \
    __typeof__(a) _a = (a);                                                    \
    __typeof__(b) _b = (b);                                                    \
    _a > _b ? _a : _b;                                                         \
  })

#include <assert.h>
#include <err.h>
#include <errno.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef __unix__
#include <argp.h> // libc only used for argp.
#else
#include <windows.h>
#endif

#ifndef M_PI
// MinGW's math.h doesn't seem to have these defined.
#define M_PI 3.14159265358979323846       /* pi */
#define M_PI_2 1.57079632679489661923     /* pi/2 */
#define M_PI_4 0.78539816339744830962     /* pi/4 */
#define M_1_PI 0.31830988618379067154     /* 1/pi */
#define M_2_PI 0.63661977236758134308     /* 2/pi */
#define M_2_SQRTPI 1.12837916709551257390 /* 2/sqrt(pi) */
#define M_2PI_3 2.0943951023931953        /* 2*pi/3 */
#endif

#define MAX_FILE_LINE 512
#define MAX_MAT_DIM 127

#ifdef __unix__
// {{{ argp

#define ARGP_N_POS 1

struct arguments {
  char *args[ARGP_N_POS]; // Only 1 mandatory argument: input matrix filename.
  int info;
  int maxiter;
  double epsilon;
};

const char *argp_program_version = "realmat 0.1";
const char *argp_program_bug_address = "<dave.mcewan@bristol.ac.uk>";

static struct argp_option options[] = {
    // name, key, arg, flags, doc, group
    {"info", 'i', 0, 0, "Print general info.", 0},
    {"maxiter", 'n', "(int > 1)", 0, "Maximum number of iterations.", 0},
    {"epsilon", 'e', "(float < 0.0)", 0, "Error bound.", 0},
    {0}};

static error_t parse_opt(int key, char *arg, struct argp_state *state) {
  struct arguments *arguments = state->input;

  switch (key) {
  case 'i':
    arguments->info = 1;
    break;
  case 'n':
    arguments->maxiter = atoi(arg);
    break;
  case 'e':
    arguments->epsilon = atof(arg);
    break;

  case ARGP_KEY_ARG:
    // Too many arguments.
    if (state->arg_num >= ARGP_N_POS)
      argp_usage(state);
    arguments->args[state->arg_num] = arg;
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

static char args_doc[] = "<matrix-filename>";

static char doc[] = "Info and eigenanalysis on matrices of reals.";

static struct argp argp = {options, parse_opt, args_doc, doc, 0, 0, 0};

// }}} argp
#else
struct arguments {
  int info;
  int maxiter;
  double epsilon;
};
#endif

// }}} setup

// {{{ realmat

typedef struct { // {{{ realmat
  int unsigned n_rows;
  int unsigned n_cols;

  double *M; // The actual matrix content.

  // Extra attributes which *may* be filled in.
  double tr;
  bool sq;
  double det;
  bool symm;
  bool tril;
  bool triu;
  bool diag;
} realmat; // }}}

realmat *new_realmat(int unsigned n_rows, int unsigned n_cols) { // {{{

  int unsigned n_bytes = n_rows * n_cols * sizeof(double);
  double *M = malloc(n_bytes);
  if (NULL == M)
    err(1, "new_realmat(%d, %d) 1st malloc()", n_rows, n_cols);
  memset(M, 0, n_bytes);

  realmat *r = malloc(sizeof(realmat));
  if (NULL == r)
    err(1, "new_realmat(%d, %d) 2nd malloc()", n_rows, n_cols);

  // Initialise contents
  r->n_rows = n_rows;
  r->n_cols = n_cols;
  r->M = M;

  // Initialise optional attributes.
  r->tr = 0;
  r->sq = false;
  r->det = 0;
  r->symm = false;
  r->triu = false;
  r->tril = false;
  r->diag = false;

  return r;
} // }}}

void del_realmat(realmat *A) { // {{{

  free(A->M);
  free(A);

  return;
} // }}}

void printf_realmat(realmat *A, char *name) { // {{{

  int unsigned n_rows = A->n_rows;
  int unsigned n_cols = A->n_cols;

  printf("%s:\n", name);
  for (int unsigned m = 0; m < n_rows; m++) {
    printf("    - [ ");
    for (int unsigned n = 0; n < n_cols; n++) {
      printf("%f", A->M[m * n_cols + n]);
      if (n < n_cols - 1)
        printf(", ");
    }
    printf(" ]\n");
  }

  return;
} // }}}

void cp_realmat(realmat *A, realmat *B) { // {{{
                                          // Copy A to B inplace.
  int unsigned A_rows = A->n_rows;
  int unsigned A_cols = A->n_cols;

  int unsigned B_rows = B->n_rows;
  int unsigned B_cols = B->n_cols;

  if ((A_rows != B_rows) || (A_cols != B_cols)) {
    errx(1, "ERROR: cp_realmat(). Matrix copy is only defined when "
            "the first factor has the same dimensions (A_rows=%d, A_cols=%d) "
            "as the second factor (B_rows=%d, B_cols=%d).",
         A_rows, A_cols, B_rows, B_cols);
  }

  for (int unsigned m = 0; m < A_rows; m++) {
    for (int unsigned n = 0; n < A_cols; n++)
      B->M[m * A_cols + n] = A->M[m * A_cols + n];
  }

  return;
} // }}}

realmat *col_realmat(realmat *A, int unsigned col) { // {{{
  // Copy column from matrix into new column vector.
  int unsigned n_rows = A->n_rows;
  int unsigned n_cols = A->n_cols;
  double *M = A->M;
  assert(col < n_cols);

  realmat *r = new_realmat(n_rows, 1);

  for (int unsigned m = 0; m < n_rows; m++) {
    r->M[m] = M[m * n_cols + col];
  }

  return r;
} // }}}

bool eq_realmat(realmat *A, realmat *B, double epsilon) { // {{{
  // Return true if two matrices of the same dimensions have the same absolute
  // values within a given bound epsilon.
  int unsigned A_rows = A->n_rows;
  int unsigned A_cols = A->n_cols;

  int unsigned B_rows = B->n_rows;
  int unsigned B_cols = B->n_cols;

  if ((A_rows != B_rows) || (A_cols != B_cols)) {
    errx(1, "ERROR: eq_realmat(). Matrix comparison is only defined when "
            "the first factor has the same dimensions (A_rows=%d, A_cols=%d) "
            "as the second factor (B_rows=%d, B_cols=%d).",
         A_rows, A_cols, B_rows, B_cols);
  }

  for (int unsigned m = 0; m < A_rows; m++) {
    for (int unsigned n = 0; n < A_cols; n++) {
      double a = A->M[m * A_cols + n];
      double b = B->M[m * B_cols + n];

      if (fabs(a - b) > epsilon) {
        return false;
      }
    }
  }

  return true;
} // }}}

// }}} realmat

// {{{ attributes

double trace(realmat *A) { // {{{
                           // Sum of the main diagonal.
  int unsigned n_rows = A->n_rows;
  int unsigned n_cols = A->n_cols;
  double *M = A->M;

  int unsigned mindim = min(n_rows, n_cols);

  double r = 0.0;
  for (int unsigned i = 0; i < mindim; i++) {
    r += M[i * n_cols + i];
  }

  return r;
} // }}}

double diagprod(realmat *A) { // {{{
                              // product of the main diagonal.
  int unsigned n_rows = A->n_rows;
  int unsigned n_cols = A->n_cols;

  int unsigned mindim = min(n_rows, n_cols);

  double r = 1.0;
  for (int unsigned i = 0; i < mindim; i++) {
    r *= A->M[i * n_cols + i];
  }

  return r;
} // }}}

double determinant(double *M, int unsigned dim) { // {{{
  // Calculate determinant of matrix M recursively.
  // MUST be called with a malloc'd square matrix.
  double r = 0.0; // result

  if (dim == 2) {
    double a = M[0];
    double b = M[1];
    double c = M[2];
    double d = M[3];
    r = (a * d - b * c);
  } else {
    int unsigned subM_dim = dim - 1;

    // Allocate memory for subM.
    // Reuse same space since all submatrices are the same dimensions.
    realmat *subM = new_realmat(subM_dim, subM_dim);

    for (int unsigned col = 0; col < dim; col++) {

      // Make submatrix for this col.
      // m, n = row, col for M
      // mm, nn = row, col for subM
      for (int unsigned m = 1; m < dim; m++) {
        int unsigned mm = m - 1;
        int unsigned nn = 0;
        for (int unsigned n = 0; n < dim; n++) {
          if (n == col)
            continue;

          subM->M[mm * subM_dim + nn] = M[m * dim + n];

          nn++;
        }
      }

      // Resursively sum for det of this submatrix.
      // Recursion depth = dim-2
      double subM_det = determinant(subM->M, subM_dim);
      //   +/- 1            top row
      r += pow(-1.0, col) * M[col] * subM_det;
    }

    del_realmat(subM);
  }

  return r;
} // }}}

bool symmetric(realmat *A, double epsilon) { // {{{
  // Return true if matrix is symmetric within error bound epsilon.
  // Only makes sense for a square matrix but will calculate for the top-left
  // square if a non-square matrix is given.
  int unsigned n_rows = A->n_rows;
  int unsigned n_cols = A->n_cols;
  double *M = A->M;

  int unsigned mindim = min(n_rows, n_cols);

  for (int unsigned m = 0; m < mindim; m++) {
    for (int unsigned n = 0; n < mindim; n++) {
      if (m == n)
        continue;

      double a = M[m * n_cols + n];
      double b = M[n * n_cols + m];

      bool d = (a - b) > epsilon;

      if (d)
        return false;
    }
  }

  return true;
} // }}}

int unsigned triangular(realmat *A, double epsilon) { // {{{
  // Test if matrix A is triangular within error bound epsilon.
  // 0 = Non-triangular
  // 1 = Lower triangular
  // 2 = Upper Triangluar
  // 3 = Diagoral (upper and lower triangular)
  int unsigned n_rows = A->n_rows;
  int unsigned n_cols = A->n_cols;

  double upper_sum = 0;
  double lower_sum = 0;

  for (int unsigned m = 0; m < n_rows; m++) {
    for (int unsigned n = 0; n < n_cols; n++) {
      if (m == n)
        continue;

      if (m < n)
        upper_sum += fabs(A->M[m * n_cols + n]);
      if (n < m)
        lower_sum += fabs(A->M[m * n_cols + n]);
    }
  }

  int unsigned r = 0;
  if (upper_sum <= epsilon)
    r |= 1;
  if (lower_sum <= epsilon)
    r |= 2;
  // printf("DEBUG: upper_sum = %f\n", upper_sum);
  // printf("DEBUG: lower_sum = %f\n", lower_sum);

  return r;
} // }}}

// }}} attributes

// {{{ fromfile

void fromfile_n_rowcol(FILE *fd, int unsigned *r, int unsigned *c) { // {{{
  // Count the number of numeric rows and columns in a file.
  // This can then be used to malloc the appropriate size.
  char linebuff[MAX_FILE_LINE];

  // Do calculation in registers instead of doing lots of memory access.
  int unsigned n_rows = 0;
  int unsigned n_cols = 0;

  // Count lines to determine n_row.
  while (fgets(linebuff, MAX_FILE_LINE, fd)) {
    n_rows++;

    // Scan line counting elements.
    int unsigned cols = 0;
    bool in_num = false;
    int unsigned i = 0;
    while (linebuff[i] != '\0') {
      char c = linebuff[i];
      bool numeric = isdigit(c) || (c == '.');
      if (numeric && !in_num)
        cols++;
      in_num = numeric;
      i++;
    }

    if (1 == n_rows)
      n_cols = cols;

    if (n_rows > 1 && n_cols != cols) {
      errx(1, "n_cols = %d but on line %d there are %d cols.", n_cols, n_rows,
           cols);
    }
  }

  *r = n_rows;
  *c = n_cols;
} // }}}

void fromfile_fill(FILE *fd, double *M, int unsigned n_cols) { // {{{
  // Fill matrix from file.
  int unsigned row = 0;
  char linebuff[MAX_FILE_LINE];

  rewind(fd);
  while (fgets(linebuff, MAX_FILE_LINE, fd)) {

    // Scan line reading elements into M.
    int unsigned col = 0;
    bool in_num = false;
    int unsigned prev_i = 0;
    int unsigned curr_i = 0;
    char realbuff[MAX_FILE_LINE] = "";

    while (linebuff[curr_i] != '\0') {
      char c = linebuff[curr_i];
      bool numeric = isdigit(c) || (c == '.') || (c == '-') || (c == '+');

      if (numeric && !in_num)
        prev_i = curr_i;

      if (!numeric && in_num) {
        strncpy(realbuff, linebuff + prev_i, curr_i - prev_i);
        M[row * n_cols + col] = atof(realbuff);
        col++;
        memset(realbuff, 0, MAX_FILE_LINE);
      }

      in_num = numeric;
      curr_i++;
    }

    row++;
  }
} // }}}

realmat *realmat_fromfile(char *filepath) { // {{{
  // Initialise and fill a matrix from a file.
  FILE *fd = fopen(filepath, "r");
  if (NULL == fd) {
    err(1, "fopen(%s, \"r\")", filepath);
  }

  int unsigned n_rows;
  int unsigned n_cols;
  fromfile_n_rowcol(fd, &n_rows, &n_cols);

  realmat *r = new_realmat(n_rows, n_cols);

  fromfile_fill(fd, r->M, n_cols);

  fclose(fd);

  r->tr = trace(r);

  bool sq = (n_rows == n_cols) ? true : false;
  r->sq = sq;

  if (sq) {
    r->det = determinant(r->M, n_rows);
  }

  // First reading has error bound of 0.
  double epsilon = 0.0;

  r->symm = symmetric(r, epsilon);

  int unsigned tri = triangular(r, epsilon);
  r->tril = (tri & 1) ? true : false;
  r->triu = (tri & 2) ? true : false;
  r->diag = (3 == tri) ? true : false;

  return r;
} // }}}

// }}} fromfile

// {{{ operations

void mul_scal_inplace(realmat *A, double s) { // {{{
  // Multiply matrix in-place by scalar s.
  // C = A.s
  int unsigned n_rows = A->n_rows;
  int unsigned n_cols = A->n_cols;

  for (int unsigned m = 0; m < n_rows; m++) {
    for (int unsigned n = 0; n < n_cols; n++) {
      A->M[m * n_cols + n] *= s;
    }
  }

  return;
} // }}}

realmat *mul_mat(realmat *A, realmat *B) { // {{{
  // Return pointer to result of C = A.B
  int unsigned A_rows = A->n_rows;
  int unsigned A_cols = A->n_cols;

  int unsigned B_rows = B->n_rows;
  int unsigned B_cols = B->n_cols;

  if (A_cols != B_rows) {
    errx(1, "ERROR: mat_mul(). Matrix multiplication is only defined when "
            "the first factor has the same number of columns (A_cols=%d) "
            "as the second factor has rows (B_rows=%d).",
         A_cols, B_rows);
  }

  int unsigned C_rows = A_rows;
  int unsigned C_cols = B_cols;
  realmat *r = new_realmat(C_rows, C_cols);
  double *C_M = r->M;

  for (int unsigned m = 0; m < C_rows; m++) {
    for (int unsigned n = 0; n < C_cols; n++) {
      double e = 0.0;
      for (int unsigned i = 0; i < A_cols;
           i++) // Dimension in common. A_cols == B_rows.
        e += A->M[m * A_cols + i] * B->M[i * B_cols + n];
      C_M[m * C_cols + n] = e;
    }
  }

  return r;
} // }}}

double col_l2norm(realmat *A, int unsigned col) { // {{{
  int unsigned n_rows = A->n_rows;
  int unsigned n_cols = A->n_cols;
  assert(col < n_cols);

  double sqsum = 0.0;
  for (int unsigned m = 0; m < n_rows; m++) {
    sqsum += pow(A->M[m * n_cols + col], 2.0);
  }

  return sqrt(sqsum);
} // }}}

double col_dotprod(realmat *A, int unsigned colA, realmat *B,
                   int unsigned colB) { // {{{
  // Return the dot product of column vectors of the same height.
  int unsigned A_rows = A->n_rows;
  int unsigned A_cols = A->n_cols;
  assert(colA < A_cols);

  int unsigned B_rows = B->n_rows;
  int unsigned B_cols = B->n_cols;
  assert(colB < B_cols);

  if (A_rows != B_rows) {
    errx(1, "ERROR: col_dotprod(). Column dot product is only defined when "
            "the first factor has the same number of rows (A_rows=%d) "
            "as the second factor (B_rows=%d).",
         A_rows, B_rows);
  }

  double r = 0.0;
  for (int unsigned m = 0; m < A_rows; m++) {
    r += A->M[m * A_cols + colA] * B->M[m * B_cols + colB];
  }

  return r;
} // }}}

realmat *col_proj(realmat *V, int unsigned colV, realmat *U,
                  int unsigned colU) { // {{{
                                       // Return the projection of V onto U.
  // https://en.wikipedia.org/wiki/Gram-Schmidt_process
  // proj_{u}(v)
  int unsigned V_rows = V->n_rows;
  int unsigned V_cols = V->n_cols;
  assert(colV < V_cols);

  int unsigned U_rows = U->n_rows;
  int unsigned U_cols = U->n_cols;
  assert(colU < U_cols);

  if (V_rows != U_rows) {
    errx(1, "ERROR: col_proj(). Column dot product is only defined when "
            "the first factor has the same number of rows (V_rows=%d) "
            "as the second factor (U_rows=%d).",
         V_rows, U_rows);
  }

  realmat *r = new_realmat(U_rows, 1);

  // proj_{0}(v) := 0
  // If u = 0 we define return value as all zeros (initialised state).
  bool u_eq_0 = true;
  for (int unsigned m = 0; m < U_rows; m++) {
    if (U->M[m * U_cols + colU] != 0) {
      u_eq_0 = false;
      break;
    }
  }
  if (u_eq_0)
    return r;

  double v_u = col_dotprod(V, colV, U, colU);
  double u_u = col_dotprod(U, colU, U, colU);
  double s = v_u / u_u;

  for (int unsigned m = 0; m < U_rows; m++) {
    r->M[m] = s * U->M[m * U_cols + colU];
  }

  return r;
} // }}}

void col_acc(realmat *A, int unsigned col, realmat *V) { // {{{
  // Accumulate (add in-place) a column vector to a given column in a given
  // matrix.
  int unsigned A_rows = A->n_rows;
  int unsigned A_cols = A->n_cols;
  assert(col < A_cols);

  int unsigned V_rows = V->n_rows;
  int unsigned V_cols = V->n_cols;
  assert(1 == V_cols);
  assert(A_rows == V_rows);

  for (int unsigned m = 0; m < A_rows; m++) {
    A->M[m * A_cols + col] += V->M[m];
  }

  return;
} // }}}

// }}} operations

int unsigned eig_qr(realmat *A, realmat *retR, realmat *retQ, double epsilon,
                    int unsigned maxiter) { // {{{
  // QR decomposition via Gram-Schmidt process.
  int unsigned n_rows = A->n_rows;
  int unsigned n_cols = A->n_cols;

  realmat *W = new_realmat(n_rows, n_cols); // Working copy.
  cp_realmat(A, W);

  realmat *Q = new_realmat(n_rows, n_cols); // Orthogonal (Q.Qt=I)
  realmat *U = new_realmat(n_rows, n_cols); // Intermediate
  realmat *R = new_realmat(n_rows, n_cols); // Upper triangular

  int unsigned iter = 0;
  bool done = false;
  do {
    // 1st term of u vectors.
    cp_realmat(W, U);

    for (int unsigned n = 0; n < n_cols; n++) {

      // u column, 2nd term onwards.
      for (int nn = n - 1; nn >= 0; nn--) {
        realmat *proj = col_proj(W, n, U, nn);
        mul_scal_inplace(proj, -1);
        col_acc(U, n, proj);
        del_realmat(proj);
      }

      // e column
      double Un_l2norm = col_l2norm(U, n);
      // l2norm can only be 0 when all u are 0.
      // When l2norm=0 leave Q in initialised state of all 0.0.
      if (Un_l2norm != 0.0) {
        for (int unsigned m = 0; m < n_rows; m++) {
          Q->M[m * n_cols + n] = U->M[m * n_cols + n] / Un_l2norm;
        }
      }
    }

    // Q is now filled for this iteration.
    // Now build up R.
    for (int unsigned m = 0; m < n_rows; m++) {
      for (int unsigned n = 0; n < n_cols; n++) {
        R->M[m * n_cols + n] = (n < m) ? 0.0 : col_dotprod(W, n, Q, m);
      }
    }

    // Update working copy at end of iteration.
    realmat *Wnext = mul_mat(R, Q);
    done =
        eq_realmat(W, Wnext, epsilon); // Next iteration will give same result.
    cp_realmat(Wnext, W);
    del_realmat(Wnext);

    iter++;
  } while ((iter < maxiter) && !done);

  del_realmat(U);
  del_realmat(W);

  // Check that absolute product of diagonal of R = absolute determinant.
  double R_dp = diagprod(R);
  if (fabs(fabs(R_dp) - fabs(A->det)) > epsilon) {
    printf("# WARN: Product of eigenvalues (%f) != determinant.\n", R_dp);
  }

  // Copy results in-place to given retR and retQ.
  cp_realmat(Q, retQ);
  cp_realmat(R, retR);
  del_realmat(Q);
  del_realmat(R);

  return iter;
} // }}} eig_qr

int main(int argc, char **argv) { // {{{
  realmat *F; // VS compiler stupidly requires this to be at top of scope.

  // {{{ Parse options
  struct arguments arguments;
  arguments.info = 0;
  arguments.maxiter = 1000;
  arguments.epsilon = 0.000001;
#ifdef __unix__
  argp_parse(&argp, argc, argv, 0, 0, &arguments);
  char *filepath = arguments.args[0];
#else

  if (argc < 2 || argc > 4) {
    errx(1, "ERROR: usage:realmat <filename> [<maxiter>] [<epsilon>]");
  }

  arguments.info = 1;
  char *filepath = argv[1];
  if (argc == 3)
    arguments.maxiter = atoi(argv[2]);
  if (argc == 4)
    arguments.epsilon = atoi(argv[3]);
#endif
  // }}} Parse options

  if (arguments.info)
    printf("filepath: %s\n", filepath);
  F = realmat_fromfile(filepath);

  int unsigned n_rows = F->n_rows;
  int unsigned n_cols = F->n_cols;

  if (arguments.info) {
    printf("n_rows: %d\n", n_rows);
    printf("n_cols: %d\n", n_cols);

    printf_realmat(F, "input");

    printf("symmetric: %s\n", F->symm ? "yes" : "no");
    printf("trace: %f\n", F->tr);
    printf("square: %s\n", F->sq ? "yes" : "no");
    if (F->sq)
      printf("determinant: %f\n", F->det);

    printf("tril: %s\n", F->tril ? "yes" : "no");
    printf("triu: %s\n", F->triu ? "yes" : "no");
    printf("diag: %s\n", F->diag ? "yes" : "no");
  }

  if (F->sq) {
    realmat *R = new_realmat(n_rows, n_cols); // Diagonal matrix of eigenvalues.
    realmat *Q = new_realmat(n_rows, n_cols); // Columns of eigenvectors.

    int unsigned iter = eig_qr(F, R, Q, arguments.epsilon, arguments.maxiter);

    // 16 char is enough for Q, _, ...n*13..., NULL
    // Note that result e.g. Q_23 is 1-indexed like literature, not C.
    char q[16];
    char r[16];
    assert(sprintf(q, "Q_%d", iter) > 0);
    assert(sprintf(r, "R_%d", iter) > 0);
    printf_realmat(Q, q);
    printf_realmat(R, r);

    del_realmat(Q);
    del_realmat(R);
  }

  del_realmat(F);
  return 0;
} // }}} main
