#include "multiply.h"

void matvec(unsigned int rows, unsigned int cols,
            FTYPE (*a)[cols], FTYPE *__restrict b, FTYPE *__restrict x)
{
    int i, j;
    enum { inc_i = 1, inc_j = 1 };

    for (i = 0; i < rows; i += inc_i) {
        FTYPE temp = b[i];  // Read once
#pragma vector aligned
        for (j = 0; j < cols; j += inc_j) {
            temp += a[i][j] * x[j];  // Pure computation, no memory dependency
        }
        b[i] = temp;  // Write once
    }
}
