!* ========================================================================== *
!*
!* SAMPLE SOURCE CODE - SUBJECT TO THE TERMS OF SAMPLE CODE LICENSE AGREEMENT,
!* http://software.intel.com/en-us/articles/intel-sample-source-code-license-agreement/
!*
!* Copyright 2010-2018 Intel Corporation
!*
!* THIS FILE IS PROVIDED "AS IS" WITH NO WARRANTIES, EXPRESS OR IMPLIED,
!* INCLUDING BUT NOT LIMITED TO ANY IMPLIED WARRANTY OF MERCHANTABILITY,
!* FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT OF INTELLECTUAL
!* PROPERTY RIGHTS.
!*
!* ========================================================================== *

subroutine matvec(rows, cols, a, b, x)
    use Global ! inc_i & inc_j
    implicit none
    integer rows, cols, i, j
    real*8, contiguous :: a(:,:), b(:), x(:)
    real*8 temp
!DIR$ ASSUME_ALIGNED a:64, b:64, x:64
!DIR$ ASSUME (MOD(rows, 64) .EQ. 0)

    do i = 1, cols, inc_i
        temp = 0.0D+0  ! Initialize accumulator
!DIR$ VECTOR ALIGNED
        do j = 1, rows, inc_j
            temp = temp + a(j, i) * x(j)  ! Pure computation, no memory dependency
        enddo
        b(i) = b(i) + temp  ! Write once at end
    enddo
end subroutine
