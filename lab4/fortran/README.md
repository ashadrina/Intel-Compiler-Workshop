# Vectorization Optimization Workshop (Fortran)

**Goal:** Optimize matrix-vector multiply from **1.8 → 20.4 GFLOPS** (11.3x speedup)

**Time:** 2 hours  
**Problem:** `b(i) = b(i) + a(i,j) * x(j)` (matrix-vector multiplication)

**Note:** The optimization report samples and performance results included in this README were generated using Intel® Compiler version 2026.0 and measured on an Intel® Xeon® Platinum 8480+ (Sapphire Rapids) system.

---

## Setup

```bash
source setup_ifx.sh
ifx --version
```

**Quick Start (automated):**
```bash
./build_all.sh      # Build all solutions
./benchmark_all.sh  # Compare performance
```

**Manual Mode:** Follow activities below

---

## Activity 1.1: Baseline & Unit Stride Fix

### Step 1: Test Baseline Without Vectorization

```bash
cd 00-baseline
ifx -fpp -O2 -xHost -no-vec driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~4.5s expected)
- **Record GFLOPS:** ________ (~1.8 expected)

**Generate optimization report:**
```bash
ifx -fpp -g -O2 -no-vec -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c
```

**Key output:**
```
    Begin optimization report for: matvec_

	LOOP BEGIN at multiply.f90 ((21, 5)

		LOOP BEGIN at multiply.f90 (22, 9)
		LOOP END

		LOOP BEGIN at multiply.f90 (22, 9)
		<Remainder loop>
		LOOP END
	LOOP END
```

The vectorization report is empty because we disabled vectorization with `-no-vec`.

**We are interested in the vectorization of the inner loop** (line 24):
```fortran
    22          do j = 1, rows, inc_j
    23              b(i) = b(i) + a(j, i) * x(j)
    24          enddo
```

✅ **Checkpoint:** Baseline performance established. We now know how to check vectorization status via opt-reports.

---

### Step 2: Enable Vectorization (Still Fails)

```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~4.5s expected)
- **Record GFLOPS:** ________ (~1.8 expected)

**Check why it failed:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c
```
- **Find:** `remark #15344: Loop was not vectorized: vector dependence prevents vectorization` and ` remark #15346: vector dependence: assumed FLOW dependence between`

**Root cause:** `inc_i` and `inc_j` are module-level variables (treated as runtime variables)

✅ **Checkpoint:** Vectorization blocked, cause identified via opt-report

---

### Step 3: Fix with Local Compile-Time Constants

```bash
cd ../01-unit-stride
diff ../00-baseline/driver.f90 driver.f90  # See the change
```

**Key change:** Move constants to local scope
```fortran
<     integer :: inc_i = 1
<     integer :: inc_j = 1
---
>     parameter inc_i = 1
>     parameter inc_j = 1
```

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~0.52s expected)
- **Record GFLOPS:** ________ (~15.5 expected)

We now have a significant speedup - from 4.5 seconds to 0.5 seconds!

**Verify vectorization:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c
```

**Key output:**
```
LOOP BEGIN at multiply.f90 (21, 5)
<Multiversioned v1>
    remark #15541: loop was not vectorized: outer loop is not an auto-vectorization candidate.

    LOOP BEGIN at multiply.f90 (22, 9)
        remark #15300: LOOP WAS VECTORIZED
        remark #15305: vectorization support: vector length 4
        remark #15389: vectorization support: unmasked unaligned unit stride load: [ multiply.f90 (23, 13) ]
...
    LOOP END

    LOOP BEGIN at multiply.f90 (22, 9)
    <Remainder loop for vectorization>
    LOOP END
LOOP END

LOOP BEGIN at multiply.f90 (21, 5)
<Multiversioned v1>
    remark #15541: loop was not vectorized: outer loop is not an auto-vectorization candidate.

    LOOP BEGIN at multiply.f90 (22, 9)
        remark #15335: loop was not vectorized: vectorization possible but seems inefficient. Use vector always directive or -vec-threshold0 to override
    LOOP END
LOOP END

LOOP BEGIN at multiply.f90 (21, 5)
<Multiversioned v1>
<Remainder loop>
    remark #15541: loop was not vectorized: outer loop is not an auto-vectorization candidate.

    LOOP BEGIN at multiply.f90 (22, 9)
        remark #15300: LOOP WAS VECTORIZED
        remark #15305: vectorization support: vector length 4
        remark #15399: vectorization support: unroll factor 4
        remark #15389: vectorization support: unmasked unaligned unit stride load: [ multiply.f90 (23, 13) ]
...
    LOOP END

    LOOP BEGIN at multiply.f90 (22, 9)
    <Remainder loop for vectorization>
        remark #15440: remainder loop was vectorized (masked)
        remark #15305: vectorization support: vector length 4
        remark #15389: vectorization support: masked unaligned unit stride load: [ multiply.f90 (23, 13) ]
...
    LOOP END

    LOOP BEGIN at multiply.f90 (22, 9)
    <Remainder loop for vectorization>
    LOOP END
LOOP END

LOOP BEGIN at multiply.f90 (21, 5)
<Multiversioned v1>
<Remainder loop>
    remark #15541: loop was not vectorized: outer loop is not an auto-vectorization candidate.

    LOOP BEGIN at multiply.f90 (22, 9)
        remark #15335: loop was not vectorized: vectorization possible but seems inefficient. Use vector always directive or -vec-threshold0 to override
        remark #15620: SLP vectorization performed on 8 operation groups in loop
        remark #15622: SLP vectorization created 1 horizontal reductions in loop
    LOOP END

    LOOP BEGIN at multiply.f90 (22, 9)
    <Remainder loop>
    LOOP END
LOOP END

LOOP BEGIN at multiply.f90 (21, 5)
<Multiversioned v2>
    remark #15615: Loop was not vectorized: not vectorizable due to data dependence, fall-back loop for multiversioning

    LOOP BEGIN at multiply.f90 (22, 9)
        remark #15615: Loop was not vectorized: not vectorizable due to data dependence, fall-back loop for multiversioning
    LOOP END
LOOP END
```

- **Find:** `remark #15300: LOOP WAS VECTORIZED`
- **Find:** `vector length 4` (4 doubles per AVX-512 YMM register)

**Notice:** `unmasked unaligned unit stride load` - alignment not guaranteed yet

✅ **Checkpoint:** First vectorization success, ~8.6x speedup. Loop vectorized but unaligned loads. Multiversioning is present as well due to data dependence. We will continue with resolving dependencies and aliasing. 

**Key Learning:** Compiler needs compile-time loop strides to vectorize. Fortran module-level `parameter` is not sufficient - use local subroutine-level `parameter`.

---

## Activity 1.2: Resolve Aliasing and Dependencies

**Current state:** Vectorized but using **unaligned loads** and **multiversioning**

**Goal:** Improve vectorization quality with aliasing and dependency directives

---

### Step 1: Break Loop Dependencies with `!DIR$ IVDEP`

```bash
cd ../02-ivdep
diff ../00-baseline/multiply.f90 multiply.f90
```

**Key change:** `!DIR$ IVDEP` before outer loop
```fortran
    22  !DIR$ IVDEP
    23          do j = 1, rows, inc_j
    24              b(i) = b(i) + a(j, i) * x(j)
    25          enddo
```

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~1.11s expected)
- **Record GFLOPS:** ________ (~7.2 expected)

**Verify:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c
```

**Find:** Multiversioning is GONE!
**Find:** `remark #15389: vectorization support: unmasked unaligned unit stride load:`

**Performance drop:** 2x slower than unit-stride (15.4 → 7.2 GFLOPS). The `!DIR$ IVDEP` directive removes multiversioning but the compiler generates less efficient code. Without multiversioning's runtime optimization paths, the single vectorized path may have suboptimal register allocation or memory access patterns.

✅ **Checkpoint:** `!DIR$ IVDEP` tells compiler to ignore vector dependencies for this loop which leads to the resolution of multiversioning. Vectorization achieved but the cost is the performance drop.

**When to use:** Loop has dependencies but they're safe to ignore (e.g., reductions, false dependencies)

---

### Step 2: Add Contiguous Attribute (Pointer Version)

```bash
cd ../03-contiguous
diff ../02-ivdep/multiply.f90 multiply.f90
```

**Key change:** `contiguous` attribute on pointer arrays
```fortran
<     real*8, pointer :: a(:,:), b(:), x(:)
---
>     real*8, pointer, contiguous :: a(:,:), b(:), x(:)
```

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~1s expected)
- **Record GFLOPS:** ________ (~7.5 expected)

**Verify:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c
```

**Key output:**
```
    LOOP BEGIN at multiply.f90 (23, 9)
        remark #15300: LOOP WAS VECTORIZED
        remark #15305: vectorization support: vector length 4
		remark #15389: vectorization support: unmasked unaligned unit stride load:
```

✅ **Checkpoint:** The `contiguous` attribute tells the compiler that array elements are compact in memory with unit stride. Fortran allows creating array subsets with non-unit stride, which hinders vectorization. By adding `contiguous` to pointer arrays, we guarantee unit-stride access, enabling better optimization. Performance improves slightly (7.2 → 7.5 GFLOPS) over ivdep-only version.

**When to use:** Assumed-shape or pointer arrays where you know memory is contiguous and unit-stride

---

## Activity 1.3: Alignment Optimization

**Current goal:** Eliminate runtime alignment checks and enable aligned vector loads

**Why not using `!DIR$ IVDEP`?** 
We return to the unit-stride solution (01-unit-stride) as the baseline for alignment work. While `!DIR$ IVDEP` removed multiversioning in Activity 1.2, it caused a 2x performance drop. The compiler's automatic multiversioning with alignment optimization yields better performance than forcing dependency removal. We'll let the compiler handle dependencies while we focus on fixing alignment.

---

### Step 1: Enforced Alignment with `!DIR$ ATTRIBUTES ALIGN`

**Motivation:** The arrays `a`, `b`, and `x` used in the loops are allocated in `driver.f90` without guaranteed alignment. By using the `!DIR$ ATTRIBUTES ALIGN` directive, we force the compiler to allocate these arrays on 64-byte boundaries (required for AVX-512), enabling potential use of aligned vector loads.

**Apply alignment directive:**
```bash
cd ../04-alignment
diff ../03-contiguous/driver.f90 driver.f90
```

**Key changes:**
1. **Remove pointer indirection:** Change from `pointer, contiguous` to direct `contiguous` arrays
2. **Add alignment directive:** `!DIR$ ATTRIBUTES ALIGN : 64 :: a, b, x` 
3. **Simplify allocation:** Direct `allocatable` instead of `target` + pointer
4. **Direct subroutine calls:** Pass `a, b, x` directly instead of pointer aliases `pa, pb, px` 

```fortran
diff ../03-contiguous/driver.f90 driver.f90
32c32
<             real*8, pointer, contiguous :: a(:,:), b(:), x(:)
---
>             real*8, contiguous :: a(:,:), b(:), x(:)
99,100c99,102
<     real*8, allocatable, target :: a(:,:), b(:), x(:)
<     real*8, pointer, contiguous :: pa(:,:), pb(:), px(:)
---
>     ! Worst case alignment is 64 byte:
>     ! 16 byte for SSE, 32 byte for AVX & 64 byte for MIC
> !DIR$ ATTRIBUTES ALIGN : 64 :: a, b, x
>     real*8, allocatable :: a(:,:), b(:), x(:)
105,107d106
<     pa=>a(:,:)
<     pb=>b(:)
<     px=>x(:)
120c119
<         call matvec(ROWWIDTH, COL, pa, pb, px)
---
>         call matvec(ROWWIDTH, COL, a, b, x)
```

**Why remove pointers?** 
Pointers add indirection overhead and prevent the compiler from knowing alignment guarantees. By using direct `contiguous` arrays without pointers, the compiler can better optimize and directly apply alignment information from the `!DIR$ ATTRIBUTES ALIGN` directive.

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~0.44s expected)
- **Record GFLOPS:** ________ (~18.2 expected)

**Verify:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c | grep "15388"
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c | grep "15389"
```

- **Find:** `remark #15389: vectorization support: unmasked unaligned unit stride load:` - for every load; no aligned loads yet.
- **Find:** the loop is again multiversioned: 

```fortran
    LOOP BEGIN at multiply.f90 (23, 9)
        remark #15344: Loop was not vectorized: vector dependence prevents vectorization
        remark #15346: vector dependence: assumed FLOW dependence
```

**What is FLOW dependence?** Read-after-write on `b(i)`:

```fortran
do j = 1, rows
    b(i) = b(i) + a(j, i) * x(j)  ! Read b(i), compute, write b(i)
enddo
```

Each iteration reads and modifies `b(i)`, creating a loop-carried dependency. The compiler cannot prove these are safe to vectorize without runtime checks, hence multiversioning.

✅ **Checkpoint:** Alignment directive applied in `driver.f90`. Arrays now allocated on 64-byte boundaries. However, `multiply.f90` doesn't yet know about this alignment, so loads remain unaligned. Loop is multiversioned due to FLOW dependence on `b(i)`.

**Key Learning:** `!DIR$ ATTRIBUTES ALIGN` forces aligned allocation but doesn't automatically enable aligned loads - the subroutine must also be told about alignment. Major performance boost (7.5 → 18.1 GFLOPS, 2.4x) comes from removing pointer indirection and simpler memory layout, not from aligned loads yet.

### Step 2: Assert Alignment with `!DIR$ ASSUME_ALIGNED`

**Build on unit-stride solution with alignment assertions:**
```bash
cd ../05-assume-aligned
diff ../04-alignment/multiply.f90 multiply.f90
```

**Key changes:**
```fortran
    real*8, contiguous :: a(:,:), b(:), x(:)
!DIR$ ASSUME_ALIGNED a:64, b:64, x:64
```

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~0.46s expected)
- **Record GFLOPS:** ________ (~17.4 expected)

**Check alignment hints:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c | grep "15388"
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c | grep "15389"
```
- **Find:** `remark #15388: vectorization support: unmasked aligned unit stride load` (aligned loads achieved!)
- **Note:** Also shows some unaligned loads because loop is multiversioned (multiple code paths)

✅ **Checkpoint:** `!DIR$ ASSUME_ALIGNED` successfully enables aligned vector loads. Slight performance drop (18.1 → 17.4 GFLOPS) is acceptable trade-off - the goal of achieving aligned loads is met. The compiler now generates aligned load instructions for the optimized code path.  

**Warning:** `assume_aligned` is programmer assertion - non-standard-conforming behavior if data not actually aligned!

---

### Step 3: Eliminate Remainder Loop (Padding)

**Pad columns to vector-length multiple:**
```bash
cd ../06-padding
diff ../05-assume-aligned/driver.f90 driver.f90
```

**Key changes:**
```fortran
<     parameter ROWBUF = 0
---
>     parameter ROWBUF = 1
```

The critical detail: Loop iterates over `rows` parameter, which equals `ROWWIDTH`:

- **No padding (ROW=63):**
  - Main loop: 63 ÷ 4 = 15 iterations (60 elements)
  - Remainder loop: 3 elements per column × 64M iterations = 192M masked operations

- **With padding (ROW=64):**
  - Main loop: 64 ÷ 4 = 16 iterations (64 elements)
  - Remainder loop: 0 elements = never executes

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~0.40s expected)
- **Record GFLOPS:** ________ (~20.4 expected)

**Verify:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c
```

**Key observations from opt-report:**
```
<Multiversioned v1>
    LOOP BEGIN at multiply.f90 (23, 9)
        remark #15300: LOOP WAS VECTORIZED
        remark #15388: vectorization support: unmasked aligned unit stride load
        remark #15389: vectorization support: unmasked unaligned unit stride load
    LOOP END
    
    LOOP BEGIN at multiply.f90 (23, 9)
    <Remainder loop for vectorization>
        remark #15440: vectorization support: remainder loop was vectorized (masked)
        remark #15389: vectorization support: masked unaligned unit stride loads
    LOOP END
```

**Why padding still makes sense despite multiversioning:**
- **Multiversioning present:** Yes, but padding ensures the remainder loop has 0 iterations at runtime
- **Mixed aligned/unaligned:** Multiversioned v1 has 1 aligned + 8 unaligned loads, but it's the main path
- **Remainder never executes:** With ROWWIDTH=64 (divisible by 4), remainder condition is always false
- **Performance gain:** 17.4 → 20.4 GFLOPS (17% faster) from eliminating 192M remainder operations

✅ **Checkpoint:** Best automatic Fortran solution, 20.3 GFLOPS, ~11.3x speedup. Padding eliminates remainder loop execution despite opt-report showing remainder code exists.

**Key Learning:** Padding ensures runtime trip count divisibility. Opt-reports show generated code (static), not execution behavior (dynamic). With ROWWIDTH=64 divisible by vector length 4, remainder loop never taken.

---

### Step 4: Use Alignment Pragma (Simple Approach)

**Use pragma without pointer tricks:**
```bash
cd ../07-alignment-pragma
diff ../06-padding/multiply.f90 multiply.f90
```

**Key changes:** `!DIR$ VECTOR ALIGNED` (line 24) - no pointer array, direct access!
```
    21  !DIR$ ASSUME (MOD(rows, 64) .EQ. 0)
    22
    23      do i = 1, cols, inc_i
    24  !DIR$ VECTOR ALIGNED
    25          do j = 1, rows, inc_j
    26              b(i) = b(i) + a(j, i) * x(j)
    27          enddo
    28      enddo
```

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```

- **Record time:** ________ sec (~0.36s expected)
- **Record GFLOPS:** ________ (~22.7 expected)

**Why add `!DIR$ VECTOR ALIGNED` after already having padding and assume_aligned?**

With `ROWBUF=1` ensuring `ROWWIDTH=64` (multiple of vector length 4), we can now **safely enforce** aligned accesses for all loop iterations. The `!DIR$ VECTOR ALIGNED` directive tells the compiler to use aligned load instructions unconditionally.

**Add `!DIR$ ASSUME`** to assert trip count divisibility:
```fortran
!DIR$ ASSUME (MOD(rows, 64) .EQ. 0)
```
This tells the compiler that `rows` is always a multiple of 64 elements (512 bytes for double precision), which is a multiple of all possible vector lengths (4, 8). The larger the assertion, the more optimization flexibility for the compiler.

**Verify:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c | grep "15388"
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c | grep "15389"
```

- **Find:** `remark #15388: vectorization support: unmasked aligned unit stride load` (4+ instances - most loads aligned)
- **Find:** Loop still multiversioned but with aligned path dominant

✅ **Checkpoint:** Best Fortran solution achieved: 22.6 GFLOPS, 12.7x speedup. The combination of padding + assume_aligned + vector aligned + assume(mod) directive maximizes vectorization efficiency with aligned operations throughout.

**Key Learning:** `!DIR$ VECTOR ALIGNED` unconditionally enforces aligned vector operations for all accesses in the loop. **Critical:** Only safe to use after padding ensures all iterations are vector-length multiples. Without padding, this directive would cause non-standard-conforming behavior (crashes/wrong results) because the compiler would use aligned instructions on unaligned data. The `!DIR$ ASSUME (MOD(rows, 64) .EQ. 0)` assertion gives the compiler maximum optimization freedom by guaranteeing large divisibility.

---

## Critical Thinking Exercise

**Analyze the memory access pattern:**

**Question:** How many times is `b(i)` accessed in the inner loop?
```fortran
        do j = 1, rows, inc_j
            b(i) = b(i) + a(j, i) * x(j)  ! Read and write b(i) every iteration
        enddo
```
- **Answer:** 63 reads + 63 writes = **126 memory accesses per column**

**Optimization opportunity:** Could we reduce this to just 2 accesses (1 read, 1 write) using a temporary variable? Yes - accumulate in a register `tmp`, then write once. This pattern demonstrates manual dependency resolution through explicit scalar accumulation, which can be found in **Activity 1.6 (Manual Dependency Resolution)**.

However, before exploring manual optimization, let's first examine portable, standards-based approaches using **OpenMP SIMD directives** (Activity 1.4) and **Fortran array notation** (Activity 1.5), which already incorporate the temporary accumulator pattern.

---
## Activity 1.4: Portable Vectorization with OpenMP SIMD

**Goal:** Use OpenMP SIMD directives for portable, standards-based vectorization

OpenMP 4.0+ provides `!$OMP SIMD` directives for explicit vectorization that work across compilers (Intel, GCC, Clang). This approach combines manual dependency resolution (tmp accumulator) with portable SIMD hints.

**Current state:** We've achieved vectorization through compiler-specific directives (Activities 1.1-1.3). Now let's use OpenMP SIMD for a portable, cross-compiler solution.

---

### Step 1: Basic OpenMP SIMD

**Navigate to solution folder:**
```bash
cd ../08-openmp-simd
diff ../03-contiguous/multiply.f90 multiply.f90
```

**Key changes:**
```fortran
subroutine matvec(rows, cols, a, b, x)
    use Global ! inc_i & inc_j
    implicit none
    integer rows, cols, i, j
    real*8, contiguous :: a(:,:), b(:), x(:)
    real*8 tmp

    do i = 1, cols, inc_i
		! Use a temporary because OpenMP reduction variables must be scalars
		! or array sections, not indexed elements like b(i)
        tmp = 0.0D+0
!$OMP SIMD LINEAR(j:inc_j) REDUCTION(+:tmp)
        do j = 1, rows, inc_j
            tmp = tmp + mult(a(j, i), x(j))
        enddo
        b(i) = b(i) + tmp
    enddo

    contains
        real*8 function mult(a, x)
!$OMP DECLARE SIMD(mult) NOTINBRANCH
            implicit none
            real*8, intent(in) :: a, x
            mult = a * x
        end function
end subroutine
```

**What changed:**
1. **`real*8 tmp`**: Scalar accumulator (OpenMP requirement - cannot reduce on array element)
2. **`!$OMP SIMD`**: OpenMP vectorization directive
3. **`LINEAR(j:inc_j)`**: Declares j as loop induction variable
4. **`REDUCTION(+:tmp)`**: Safe parallel reduction across SIMD lanes
5. **`mult()` function**: Wrapper for multiplication
6. **`!$OMP DECLARE SIMD`**: Generate vectorized version of mult()
7. **`b(i) = b(i) + tmp`**: Write accumulated result once

**Compile and test:**
```bash
ifx -fpp -O2 -xHost -qopenmp driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~0.76s expected)
- **Record GFLOPS:** ________ (~10.6 expected)

**Generate opt-report:**
```bash
ifx -fpp -g -O2 -xHost -qopenmp -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c
```
- **Find:** `remark #15569: Compiler has chosen to target XMM/YMM vector. Try using -mprefer-vector-width=512 to override` - we will discuss this later
- **Find:** `remark #15300: LOOP WAS VECTORIZED`
- **Find:** ` remark #15305: vectorization support: vector length 4`
- **Find:** Function `mult` has vectorized version generated

Did you notice that the opt report looks different now? 

This is because of the `mult()` function vectorization. You see multiple versions:
``` bash
ZGVeN8vv_matvec::mult_   (vector length 8)
ZGVcN4vv_matvec::mult_   (vector length 4)
ZGVdN4vv_matvec::mult_
ZGVbN2vv_matvec::mult_
```

Why multiple versions? Because of: `!$OMP DECLARE SIMD(mult)`. Compiler generates multi-versioned vector functions for different ISA widths (AVX-512, AVX2, SSE) and calling contexts.

✅ **Checkpoint:** Portable OpenMP SIMD achieves ~10.6 GFLOPS (~6x speedup). Lower than our previous solutions (20+ GFLOPS) but works across compilers. Temporary accumulator reduces memory traffic.

**When to use:** Cross-platform code requiring portability over peak performance

---

### Step 2: Optimized OpenMP SIMD with Alignment

**Navigate to solution folder:**
```bash
cd ../09-openmp-simd-best
diff ../08-openmp-simd/multiply.f90 multiply.f90
```

**Key changes:**
```fortran
    19      real*8, contiguous :: a(:,:), b(:), x(:)
    20      real*8 tmp
    21  !DIR$ ASSUME_ALIGNED a:64, b:64, x:64
    22  !DIR$ ASSUME (MOD(rows, 64) .EQ. 0)
    23
    24      do i = 1, cols, inc_i
    25          ! Use a temporary because OpenMP reduction variables must be scalars
    26          ! or array sections, not indexed elements like b(i)
    27          tmp = 0.0D+0
    28  !$OMP SIMD LINEAR(j:inc_j) REDUCTION(+:tmp) ALIGNED(a, b, x:64)
    29          do j = 1, rows, inc_j
    30              tmp = tmp + mult(a(j, i), x(j))
    31          enddo
    32          b(i) = b(i) + tmp
    33      enddo
    34
    35      contains
    36          real*8 function mult(a, x)
    37  !$OMP DECLARE SIMD(mult) NOTINBRANCH
    38              implicit none
    39              real*8, intent(in) :: a, x
    40              mult = a * x
    41          end function
```

**Compile and test:**
```bash
ifx -fpp -O2 -xHost -qopenmp driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~0.56s expected)
- **Record GFLOPS:** ________ (~14.5 expected)

**Generate opt-report:**
```bash
ifx -fpp -g -O2 -xHost -qopenmp -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c
```
- **Find:** `remark #15388: vectorization support: unmasked aligned unit stride`
- **Find:** Alignment hints respected

✅ **Checkpoint:** Optimized OpenMP SIMD achieves ~14.5 GFLOPS (~7x speedup). Alignment clauses improve performance but still trail vendor-specific solutions (22+ GFLOPS). Trade-off: portability vs peak performance.

**Key Learning:** OpenMP SIMD provides portable vectorization with explicit control over induction variables, reductions, and alignment. The temporary accumulator pattern reduces memory bandwidth pressure (126 → 2 accesses to `b(i)`). However, function call overhead and conservative code generation limit peak performance compared to vendor directives.

---

## Activity 1.5: Fortran Array Notation

**Goal:** Explore Fortran's array notation as an alternative approach to explicit loops

Fortran provides **array notation** using array slicing and intrinsic functions like `sum()`. This allows expressing operations more concisely while potentially enabling compiler optimizations.

**Current state:** We've optimized explicit `do` loops through **Activities 1.1-1.3**. Now let's explore whether array notation offers comparable performance when combined with the same optimization techniques.
 
---

### Step 1: Basic Array Notation

**Objective:** Replace explicit inner loop with Fortran array notation using `sum()` and array slicing.

```bash
cd ../10-arraynotation
diff ../00-baseline/multiply.f90 multiply.f90
```

**Key changes from baseline:** 
```fortran
    19      real*8, contiguous :: a(:,:), b(:), x(:)
    20
    21      do i = 1, cols, inc_i
    22          b(i) = sum(a(1:rows:inc_j, i) * x(1:rows:inc_j))
    23      enddo
```

**What changed:**
- Replaced explicit `do j = 1, rows, inc_j` loop with array slice notation `a(1:rows:inc_j, i)`
- Used intrinsic `sum()` function to compute dot product
- Array multiplication `a(...) * x(...)` is element-wise in Fortran
- Still uses `contiguous` attribute from Activity 1.2 but avoid pointers

**Compile and test:**
```bash
ifx -fpp -O2 -xHost -qopenmp driver.f90 multiply.f90 -o matvec
./matvec
```
- **Record time:** ________ sec (~0.42s expected)
- **Record GFLOPS:** ________ (~19.1 expected)

**Generate opt-report:**
```bash
ifx -fpp -g -O2 -xHost -qopenmp -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c
```
- **Find:** `remark #15300: LOOP WAS VECTORIZED`
- **Find:** aligned and unaligned loads, multiversioning is present

✅ **Checkpoint:** Array notation vectorizes successfully! The compiler recognizes the array slice pattern and generates vectorized code for the `sum()` operation.

**Key learning:**
- Fortran array notation is not just syntactic sugar — the compiler understands it
- The `contiguous` attribute helps ensure unit-stride access
- Performance is competitive with explicit loops for this simple case

---
 
### Step 2: Add Alignment Directive

**Objective:** Apply Activity 1.3 Step 1 optimization (enforced alignment) to array notation.

```bash
cd ../11-arraynotation-alignment
diff ../10-arraynotation/driver.f90 driver.f90
``` 

**Key changes:** - Added `!DIR$ ATTRIBUTES ALIGN : 64` directive to force 64-byte alignment at allocation
```fortran
>     ! Worst case alignment is 64 byte:
>     ! 16 byte for SSE, 32 byte for AVX & 64 byte for AVX-512
> !DIR$ ATTRIBUTES ALIGN : 64 :: a, b, x
```

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```

- **Record time:** ________ sec (~0.42 expected)
- **Record GFLOPS:** ________ (~19.1 expected)

**Generate opt-report:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec  -qopt-report-file=stdout multiply.f90 -c 
```

**Checkpoint:** Performance: ~19 GFLOPS (no significant change)

**Why similar performance?**
- Alignment alone doesn't eliminate remainder loops when `rows=63` is not divisible by vector length
- The compiler still generates multiversioned code for runtime alignment checks
- Need padding to achieve optimal performance (next step)

---

### Step 3: Add Padding

**Objective:** Apply Activity 1.3 Step 3 optimization (padding) to eliminate remainder loops.

```bash
cd ../12-arraynotation-padding
diff ../11-arraynotation-alignment/driver.f90 driver.f90
``` 

**Key changes:**
```fortran
<     parameter ROWBUF = 0
---
>     parameter ROWBUF = 1
```

**What changed:**
- Set `ROWBUF = 1` to make `ROWWIDTH = 64` (divisible by vector length 4)
- Kept 64-byte alignment directive

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```

- **Record time:** ________ sec (~0.34 expected)
- **Record GFLOPS:** ________ (~23.6 expected)

**Generate opt-report:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec  -qopt-report-file=stdout multiply.f90 -c 
```

**Why the performance jump?**

With `ROWWIDTH=64` divisible by vector length 4:
- Array slices `a(1:rows:inc_j, i)` now span exactly 16 vector iterations
- Remainder loop code exists but **never executes** (trip count % 4 == 0)
- Eliminates masked operations and branch overhead

This demonstrates the same principle from Activity 1.3: padding provides the largest single performance boost by ensuring runtime trip counts align with vector boundaries.

**Checkpoint:** Performance: ~23.5 GFLOPS (**24% speedup!**)

---

### Step 4: Add Assume Aligned + Vector Aligned

**Objective:** Apply Activity 1.3 Step 2 & Step 4 optimizations (alignment assertions) to array notation.

```bash
cd ../13-arraynotation-best
diff ../12-arraynotation-padding/multiply.f90 multiply.f90
``` 

**Key changes:**
```fortran
    19      real*8, contiguous :: a(:,:), b(:), x(:)
    20  !DIR$ ASSUME_ALIGNED a:64, b:64, x:64
    21  !DIR$ ASSUME (MOD(rows, 64) .EQ. 0)
    22
    23      do i = 1, cols, inc_i
    24  !DIR$ VECTOR ALIGNED
    25          b(i) = sum(a(1:rows:inc_j, i) * x(1:rows:inc_j))
    26      enddo
```

**What changed:**
- Added `!DIR$ ASSUME_ALIGNED a:64, b:64, x:64` to assert 64-byte alignment
- Added `!DIR$ ASSUME (MOD(rows, 64) .EQ. 0)` to assert divisibility
- Added `!DIR$ VECTOR ALIGNED` to enforce aligned vector operations

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```

- **Record time:** ________ sec (~0.33 expected)
- **Record GFLOPS:** ________ (~24.2 expected)

**Generate opt-report:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec  -qopt-report-file=stdout multiply.f90 -c 
```

**Why the final boost?**
- Assertions eliminate multiversioning and runtime alignment checks
- Compiler generates simpler, more efficient code path
- Aligned loads are faster than unaligned on most architectures

- **Find:** `remark #15388: vectorization support: masked aligned unit stride load`
- **Find:** `remark #15388: vectorization support: masked unaligned unit stride load`
- **Find:** Loop still multiversioned but with aligned path dominant

**Checkpoint:** Performance: ~24.2 GFLOPS (**Best array notation result**)

---

## Activity 1.6: Manual Dependence Resolution

**Goal:** Eliminate loop-carried dependencies through manual optimization

**Current state:** Solutions 07 and 11 achieve excellent performance (~22-24 GFLOPS) but still have a read-after-write dependency on `b(i)` in the inner loop. By manually resolving this dependence with a temporary accumulator, we can potentially achieve even better performance.

**The dependence problem:**

```fortran
do i = 1, cols, inc_i
    do j = 1, rows, inc_j
        b(i) = b(i) + a(j, i) * x(j)  ! Read b(i), compute, write b(i) - EVERY iteration
    enddo
enddo
```

**Memory access pattern:**
- Inner loop executes 64 iterations (rows = 64)
- Each iteration: **1 read + 1 write** to `b(i)` = **128 memory accesses per column**
- The compiler must assume `b(i)` could be modified, preventing full optimization

```bash
cd ../14-combined
diff ../07-alignment-pragma/multiply.f90 multiply.f90
``` 

**Key changes:**
```fortran
    19      real*8, contiguous :: a(:,:), b(:), x(:)
    20      real*8 temp
    21  !DIR$ ASSUME_ALIGNED a:64, b:64, x:64
    22  !DIR$ ASSUME (MOD(rows, 64) .EQ. 0)
    23
    24      do i = 1, cols, inc_i
    25          temp = 0.0D+0  ! Initialize accumulator
    26  !DIR$ VECTOR ALIGNED
    27          do j = 1, rows, inc_j
    28              temp = temp + a(j, i) * x(j)  ! Pure computation, no memory dependency
    29          enddo
    30          b(i) = b(i) + temp  ! Write once at end
    31      enddo
```

**What changed:**
1. **Declared `real*8 temp`**: Local scalar accumulator
2. **Initialize `temp = 0.0D+0`**: Before inner loop
3. **Accumulate in register**: `temp = temp + ...` eliminates memory dependency
4. **Single write**: `b(i) = b(i) + temp` after loop completes

**Compile and test:**
```bash
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```

- **Record time:** ________ sec (~0.35 expected)
- **Record GFLOPS:** ________ (~23.2 expected)

**Generate opt-report:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec  -qopt-report-file=stdout multiply.f90 -c 
```

**Why this helps vectorization:**
- No loop-carried memory dependency—compiler can fully pipeline the inner loop
- All inner loop operations happen in registers (extremely fast)
- Reduces memory traffic by 64x
- Enables more aggressive compiler optimizations
 
- **Find:** `remark #15388: vectorization support: masked aligned unit stride load`
- **Find:** `remark #15388: vectorization support: masked unaligned unit stride load`
- **Find:** Loop still multiversioned but with aligned path dominant

✅ **Checkpoint:** Performance: ~23 GFLOPS (competitive with best solutions)

**Key learning:**
- Manual dependency resolution can achieve performance comparable to compiler-driven optimizations
- Using temporary accumulators is a classic optimization technique
- This pattern (accumulate in register → write once) appears in high-performance code
- The performance gain depends on memory system characteristics and CPU architecture

---

## Activity 1.7: Interprocedural Optimization (IPO)

**Goal:** Apply cross-file optimization through IPO to extract final performance gains

### Step 1: Test Without IPO

**Compile and test:**
```bash
cd ../15-ipo
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```

The code is the same as 12-combined.

- **Record time:** ________ sec (~0.35s expected)
- **Record GFLOPS:** ________ (~23.2 expected)

✅ **Checkpoint:** Baseline for IPO comparison

---

### Step 2: Enable IPO

**Compile and test:**
```bash
cd ../15-ipo
ifx -fpp -O2 -xHost -ipo driver.f90 multiply.f90 -o matvec
./matvec
```

- **Record time:** ________ sec (~0.41s expected)
- **Record GFLOPS:** ________ (~19.9 expected)

**Performance drop:** 23.2 → 19.9 GFLOPS with IPO. Why?

**Generate opt-report:**
```bash
ifx -fpp -g -O2 -xHost -ipo -qopt-report=3 -qopt-report-phase=ipo,vec -qopt-report-file=stdout driver.f90 multiply.f90  
```

**Expected IPO activity:**
```
-> INLINE: global::init_matrix_ (140<=225)
-> INLINE: global::init_vector_ (65<=225)
-> INLINE: global::printsum_ (190<=225)
```

IPO inlines helper functions (init, printsum) but **does not improve the critical matvec function** because:
1. `matvec` is already optimally vectorized (no additional inlining opportunities)
2. The algorithm is memory-bandwidth-bound (not compute-bound)
3. IPO adds code size which can affect instruction cache efficiency
4. For this specific case, the standalone optimized version performs better

✅ **Checkpoint:** IPO explored. Performance dropped to 19.9 GFLOPS (10% slower than 12-combined). IPO is most beneficial for compute-bound code with cross-file function calls - not this memory-bound matrix operation.

**Key learning:** IPO is not universally beneficial. For already-optimized, memory-bound kernels, IPO can hurt performance through increased code size and instruction cache pressure.

---

## Performance Summary

```
Solution             | Time (s) | GFLOPS | Speedup | Category
---------------------|----------|--------|---------|------------------
00-baseline (no-vec) | 4.563600 | 1.76702600756089 |   1.00x | Not vectorized
00-baseline (vec on) | 4.548100 | 1.77304808809593 |   1.00x | Failed (module vars)
01-unit-stride       | 0.5183000 | 15.5585569148461 |   8.80x | First success ★
02-ivdep             | 1.112200 | 7.25049437362604 |   4.10x | Break dependencies
03-contiguous        | 1.080000 | 7.46666636996800 |   4.22x | Contiguous attr
04-alignment         | 0.4415000 | 18.2650053271566 |  10.33x | Enforced alignment
05-assume-aligned    | 0.4622000 | 17.4469931730628 |   9.87x | Alignment assertion
06-padding           | 0.4019000 | 20.3831802292324 |  11.35x | Padding
07-alignment-pragma  | 0.3600000 | 22.7555546513311 |  12.67x | Alignment pragma
08-openmp-simd       | 0.7566000 | 10.6582074572451 |   6.03x | OpenMP SIMD
09-openmp-simd-best  | 0.5629000 | 14.5532064335743 |   8.10x | OpenMP + alignment
10-arraynotation     | 0.4224000 | 19.0909091943552 |  10.80x | Array notation base
11-arraynotation-alignment | 0.4212000 | 19.1452988180181 |  10.83x | Array + alignment
12-arraynotation-padding | 0.3475000 | 23.5741009620361 |  13.13x | Array + padding
13-arraynotation-best | 0.3377000 | 24.2582166813222 |  13.51x | Array notation best
14-combined          | 0.3532000 | 23.1936587325153 |  12.92x | Manual optimization
15-ipo               | 0.3913000 | 20.9353441112689 |  11.66x | IPO (best) ★★★

```

**Key milestones:**
- **8.79x:** First vectorization (local constants enable unit-stride)
- **10.33x:** Enforced alignment
- **11.34x:** Padding eliminates remainder loops
- **12.67x:** Best loop-based solution (alignment pragma)
- **13.51x:** Best overall (array notation with full optimizations)

---

## Advanced Exercise: ZMM Registers (Optional)

For `real*8` (8 bytes per element):

| Register | Bit Width | Elements | Vector Length |
|----------|-----------|----------|---------------|
| YMM (AVX2) | 256-bit | 4 doubles | **4** |
| ZMM (AVX-512) | 512-bit | 8 doubles | **8** |

**Compiler uses YMM (256-bit) by default**, even on AVX-512 hardware!

**Why?** Conservative strategy to avoid:
- CPU frequency scaling (AVX-512 can reduce clock speed)
- Register pressure (fewer effective registers with larger vectors)
- Not always faster in practice


### Step 1: Test Without YMM:

```bash
cd ../14-combined
ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec
./matvec
```

- **Record time:** ________ sec (~0.35s expected)
- **Record GFLOPS:** ________ (~23.2 expected)

**Verify:**
```bash
ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c | grep "vector length"
```
**Find:** `remark #15305: vectorization support: vector length 4`

✅ **Checkpoint:** Baseline for vector length comparison

**Before testing ZMM registers, predict:**
- Will it be faster? 
- By how much? (2X wider vectors = 2X throughput?)
---

### Step 2: Test With ZMM:

```bash
cd ../14-combined
ifx -fpp -O2 -xHost -qopt-zmm-usage=high driver.f90 multiply.f90 -o matvec_zmm
./matvec_zmm
```

- **Record time:** ________ sec (~0.26s expected)
- **Record GFLOPS:** ________ (~31.5 expected)


**Verify vector length 8:**
```bash
ifx -fpp -g -O2 -xHost -qopt-zmm-usage=high -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c | grep "vector length"
```
- **Find:** `remark #15305: vectorization support: vector length 8` (vs `vector length 4` default)

Hint: You can now run `./test_zmm.sh` to apply it to all solutions. Predict, will all solutions benefit equally?

**Key insight:** Wider vectors ≠ automatically faster.

--- 

## Utility Scripts

**Build all solutions:**
```bash
./build_all.sh
```

**Benchmark all:**
```bash
./benchmark_all.sh
```

**Clean artifacts:**
```bash
./clean_all.sh 
```

**Test solutions with wider vectors:**
```bash
./test_zmm.sh
```

---