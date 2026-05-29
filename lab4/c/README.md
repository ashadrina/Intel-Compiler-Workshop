# Vectorization Optimization Workshop (C)

**Goal:** Optimize matrix-vector multiply from **1.9 → 31.7 GFLOPS** (16x speedup)

**Time:** 1.5 hours  
**Problem:** `b[i] += a[i][j] * x[j]` (matrix-vector multiplication)

**Note:** The optimization report samples and performance results included in this README were generated using Intel® Compiler version 2026.0 and measured on an Intel® Xeon® Platinum 8480+ (Sapphire Rapids) system.

---

## Setup

```bash
source setup_icx.sh
icx --version
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
icx -O2 -xHost -no-vec multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~4.2s expected)
- **Record GFLOPS:** ________ (~1.9 expected)

**Generate optimization report:**
```bash
icx -g -O2 -no-vec -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```

**Key output:**
```
    Begin optimization report for: matvec

	LOOP BEGIN at multiply.c (22, 5)

		LOOP BEGIN at multiply.c (23, 9)
		LOOP END
	LOOP END

```

The vectoprization report is empty because we disabled vectorization. Note that this is not full optimization report as we limited only to a vectorization using the flag `-qopt-report-phase=vec`.

**We are interested in the vectorization of the inner loop** (line 23):
```c
    23          for (j = 0; j < cols; j += inc_j) {
    24              b[i] += a[i][j] * x[j];
    25          }
```

✅ **Checkpoint:** Baseline performance established. We now know how to check vectorization status via opt-reports.

---

### Step 2: Enable Vectorization (Still Fails)

```bash
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~4.2s expected)
- **Record GFLOPS:** ________ (~1.9 expected)

**Check why it failed:**
```bash
icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```
- **Find:** `remark #15521: Loop was not vectorized: loop control variable was not identified. Explicitly compute the iteration count before executing the loop or try using canonical loop form from OpenMP specification`

**Root cause:** `inc_i` and `inc_j` are `extern` runtime variables

✅ **Checkpoint:** Vectorization blocked, cause identified via opt-report

---

### Step 3: Fix with Compile-Time Constants

```bash
cd ../01-unit-stride
diff ../00-baseline/multiply.c multiply.c  # See the change
```

**Key change:** `enum { inc_i = 1, inc_j = 1 };` (compile-time constants)

**Compile and test:**
```bash
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~0.59s expected)
- **Record GFLOPS:** ________ (~13.6 expected)

We now have a significant speedup - from 4 seconds to less than 1 second!

**Verify vectorization:**
```bash
icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```

**Key output:**
```
    LOOP BEGIN at multiply.c (31, 5)
    <Multiversioned v1>
        remark #25228: Loop was not vectorized: all candidates are higher cost

        LOOP BEGIN at multiply.c (32, 9)
            remark #15300: LOOP WAS VECTORIZED
            remark #15305: vectorization support: vector length 4
            remark #15389: vectorization support: unmasked unaligned unit stride load: x
            remark #15389: vectorization support: unmasked unaligned unit stride load: a
        LOOP END
    <Remainder loop for multiversioning>
...
    <Multiversioned v2>
...
        LOOP BEGIN at multiply.c (32, 9)
            remark #15615: Loop was not vectorized: not vectorizable due to data dependence, fall-back loop for multiversioning
        LOOP END
```

- **Find:** `remark #15300: LOOP WAS VECTORIZED`

**Notice:** Loop is **multiversioned** (runtime checks for alignment/dependencies)
- **Fallback message:** `remark #15615: Loop was not vectorized: not vectorizable due to data dependence, fall-back loop for multiversioning`

✅ **Checkpoint:** First vectorization success, substabtial speedup (~7.6x). Loop is multiversioned - our next work will address this.

**Key Learning:** Compiler needs compile-time loop bounds to vectorize

---

## Activity 1.2: Break Loop Dependencies and Aliasing

**Current state:** Vectorized but **multiversioned** (runtime checks for dependencies and alignment)

**Goal:** Remove multiversioning by resolving dependencies and aliasing

---

### Step 1: Break Loop Dependencies with `#pragma ivdep`

```bash
cd ../02-ivdep
diff ../01-unit-stride/multiply.c multiply.c
```

**Key change:** `#pragma ivdep` before inner loop

**Compile and test:**
```bash
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~0.72s expected)
- **Record GFLOPS:** ________ (~11.1 expected)

**Verify:**
```bash
icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```

**Key output:**
```

LOOP BEGIN at multiply.c (31, 5)
    remark #15541: loop was not vectorized: outer loop is not an auto-vectorization candidate.

    LOOP BEGIN at multiply.c (33, 9)
        remark #15300: LOOP WAS VECTORIZED
	...
	 LOOP END

    LOOP BEGIN at multiply.c (33, 9)
    <Remainder loop for vectorization>
    LOOP END

    LOOP BEGIN at multiply.c (33, 9)
    <Remainder loop for vectorization>
    LOOP END
LOOP END
```

✅ **Checkpoint:** `#pragma ivdep` tells compiler to ignore vector dependencies for this loop. **Multiversioning is gone** 

**When to use:** Loop has dependencies but they're safe to ignore (e.g., reductions, false dependencies)

---

### Step 2: Break Aliasing with `-fargument-noalias` Flag

```bash
cd ../03-fargument-noalias
diff ../02-ivdep/multiply.c multiply.c  # No code change!
```

**Key change:** Compiler flag only (multiply.c already has `#pragma ivdep`)

**Compile and test:**
```bash
icx -O2 -xHost -fargument-noalias multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~0.55s expected)
- **Record GFLOPS:** ________ (~14.7 expected)

**Verify:**
```bash
icx -g -O2 -xHost -fargument-noalias -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```

**Key output:**
```
    LOOP BEGIN at multiply.c (31, 5)
    <Multiversioned by loop blocking v1>
        remark #25228: Loop was not vectorized: all candidates are higher cost

        LOOP BEGIN at multiply.c (33, 9)
            remark #15300: LOOP WAS VECTORIZED
            ...
        LOOP END
```

**Notice:** Multiversioning changed from `<Multiversioned v1>` to `<Multiversioned by loop blocking v1>`

**Also check for remaining dependencies:**
```
    LOOP BEGIN at multiply.c (33, 9)
        remark #15344: Loop was not vectorized: vector dependence prevents vectorization
        remark #15346: vector dependence: assumed FLOW dependence
        remark #15620: SLP vectorization performed on 3 operation groups in loop
        remark #15622: SLP vectorization created 1 horizontal reductions in loop
    LOOP END
```

**What is FLOW dependence?** Read-after-write: `b[i]` is read and written in each iteration
```c
b[i] += a[i][j] * x[j];  // Read b[i], compute, write back to b[i]
```

✅ **Checkpoint:** Combined `#pragma ivdep` + `-fargument-noalias` improves performance. **Multiversioning still present** (now for loop blocking). FLOW dependence detected in fallback version.

**When to use:** Can't modify source, need easy toggle for all function arguments

---

### Step 3: Break Aliasing with `__restrict` Keyword

```bash
cd ../04-restrict
diff ../02-ivdep/multiply.c multiply.c
```

**Key change:** `FTYPE *__restrict b` (line 18) - only `b` gets restrict

**Compile and test:**
```bash
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~0.53s expected)
- **Record GFLOPS:** ________ (~15 expected)

**Verify:**
```bash
icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```

✅ **Checkpoint:** `__restrict` keyword enables loop blocking. **Multiversioning still present**.

**When to use:** Permanent guarantee that pointer doesn't overlap others (undefined behavior if wrong!)

---

### Compare Three Approaches

| Approach | GFLOPS  | Multiversioning | When to Use |
|----------|--------|-----------------|-------------|
| `#pragma ivdep` | 11.1 | Yes | Per-loop dependency control |
| `#pragma ivdep` + `-fargument-noalias` | 14.7 | Yes (loop blocking) | Clean code, easy toggle |
| `#pragma ivdep` + `__restrict b` | 15 |  Yes | Permanent guarantee |

**Key Learning:** 
- `#pragma ivdep` breaks loop-carried dependencies
- `-fargument-noalias` and `__restrict` break pointer aliasing
- All three combinations achieve vectorization with ~7-7.6x speedup
- Multiversioning persists due to alignment uncertainty

---

## Activity 1.3: Alignment Optimization

**Current goal:** Fix unaligned unit stride accesses to enable aligned vector loads

---

### Step 1: Declare Aligned Allocation

**Apply alignment to arrays in driver.c:**
```bash
cd ../05-alignment-declspec
diff ../02-ivdep/driver.c driver.c
```

**Key change:** `__declspec(align(64)) FTYPE a[ROW][COLWIDTH];` (and for `b`, `x`)
We selected 64-byte alignment for the modern CPUs supporting AVX-512. Use 32 byte here and in next steps if you are running on older CPUs supporting only AVX2.

**Compile and test:**
```bash
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~0.72s expected)
- **Record GFLOPS:** ________ (~11.1 expected)
 
**Check opt-report:**
```bash
icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```
- **Find:** `remark #15389: vectorization support: unmasked unaligned unit stride load`
- **Find:** multiversioning is gone!
- **Why still unaligned?** `multiply.c` doesn't know about alignment declarations in `driver.c`

✅ **Checkpoint:** Data aligned in memory (64-byte boundaries), but compiler doesn't know yet. Small performance improvement.

---

### Step 2: Assert Alignment with `__builtin_assume_aligned`

**Tell compiler about alignment:**
```bash
cd ../06-alignment-assume
diff ../05-alignment-declspec/multiply.c multiply.c
```

**Key changes:**
- **driver.c:** Pointer array `FTYPE *ax[ROW];` for row pointers
- **multiply.c:** Alignment assertions using `__builtin_assume_aligned(..., 64)`

**Compile and test:**
```bash
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~0.71s expected)
- **Record GFLOPS:** ________ (~11.2 expected)

Note that after we added __builtin_assume_aligned, our loop is moved to the line 41:
```c
    41          for (j = 0; j < cols; j += inc_j) {
    42              bx[i] += ax[i][j] * xx[j];
    43          }
```

**Check opt-report:**
```bash
icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```
- **Find:** `remark #15389: vectorization support: unmasked unaligned unit stride store` or `remark #15389: vectorization support: unmasked unaligned unit stride load`
- **Find:** multiversioning is gone!

**Why still unaligned?** The pointer array `ax[i]` points to aligned data, but:
1. Extra pointer indirection: `ax[i][j]` vs `a[i][j]`
2. Compiler can't prove row pointers maintain alignment
3. Initialization loop adds overhead (64 iterations)

✅ **Checkpoint:** Alignment assertion attempted via `__builtin_assume_aligned`, but pointer indirection introduces overhead and still shows unaligned accesses.

**Key Learning:** Pointer tricks can hurt performance; direct array access is faster

---

### Step 3: Use Alignment Pragma (Simple Approach)

**Use pragma without pointer tricks:**
```bash
cd ../07-alignment-pragma
diff ../05-alignment-declspec/multiply.c multiply.c
```

**Key change:** `#pragma vector aligned` (line 32) - no pointer array, direct access!

**Compile and test:**
```bash
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~0.72s expected)
- **Record GFLOPS:** ________ (~11.1 expected)

**Verify aligned loads:**
```bash
icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```
- **Find:** `remark #15388: vectorization support: unmasked aligned unit stride load`
- **Find:** multiversioning is gone!

✅ **Checkpoint:** Aligned loads achieved with simple pragma, good performance restored

**Warning:** `#pragma vector aligned` requires all arrays to be truly aligned. Using without proper allocation causes undefined behavior!

---

### Step 4: Eliminate Remainder Loop (Padding)

**Pad rows to vector-length multiple:**
```bash
cd ../08-padding
diff ../06-alignment-assume/multiply.h multiply.h
```

**Key change:** `#define COLBUF 1` → `COLWIDTH = 64` (divisible by 4 and 8)

The critical detail is that the loop iterates over the cols parameter, which equals COLWIDTH:

  Solution 07 (no padding):
  - COLWIDTH = 63
  - Main loop: 63 ÷ 4 = 15 iterations (60 elements)
  - Remainder loop: 3 elements per row × 64M total = 192M masked operations

  Solution 08 (with padding):
  - COLWIDTH = 64
  - Main loop: 64 ÷ 4 = 16 iterations (64 elements)
  - Remainder loop: 0 elements per row = never executes

**Compile and test:**
```bash
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~0.55s expected)
- **Record GFLOPS:** ________ (~14.6 expected)

**Verify:**
```bash
icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```

✅ **Checkpoint:** Padding ensures runtime trip count divisibility

**Key Learning:** PPadding data to vector-length multiples ensures remainder loops are never executed at runtime, eliminating masked operation overhead and achieving significant performance gains.

---

## Critical Thinking Break

**Before Solution 09, analyze the code:**

**Question 1:** How many times is `b[i]` accessed in the inner loop?
```c
for (j = 0; j < cols; j++) {
    b[i] += a[i][j] * x[j];  // b[i] read AND written every iteration
}
```
- **Answer:** 63 reads + 63 writes = **126 memory accesses per row**

**Question 2:** Can we reduce this to just 2 accesses (1 read, 1 write)?
- **Hint:** Use a temporary variable in a register

**Question 3:** Why was Solution 06 slower despite "helping" the compiler?
- **Answer:** Pointer indirection (`ax[i][j]`) + initialization loop overhead

**Question 4:** Current best: 14.9 GFLOPS. Can we do better?
- **Bottleneck:** Memory bandwidth (126 accesses to `b[i]` per row!)

---

## Activity 1.4: Manual Dependency Resolution

**Goal:** Eliminate memory bottleneck with scalar accumulator

### Step 1: Apply Manual Optimization

```bash
cd ../09-combined
diff ../05-alignment-declspec/multiply.c multiply.c
```

**Key changes:**
1. **Scalar accumulator:** `FTYPE temp = b[i];` (read ONCE at line 37)
2. **Accumulate in register:** `temp += a[i][j] * x[j];` (line 40)
3. **Write back ONCE:** `b[i] = temp;` (line 42)
4. **Alignment pragma:** `#pragma vector aligned` (line 38)
5. **Restrict pointers:** `__restrict b` and `__restrict x` (line 18)

**Compile and test:**
```bash
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~0.36s expected)
- **Record GFLOPS:** ________ (~22.2 expected)

After all the changes, the loop is at line 12:
```c
    12          for (j = 0; j < cols; j += inc_j) {
    13              temp += a[i][j] * x[j];  // Pure computation, no memory dependency
    14          }
    15          b[i] = temp;  // Write once

```

**Verify reduction recognized:**
```bash
icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c
```
- **Find:** `remark #25587: Loop has reduction`
- **Find:** `remark #15300: LOOP WAS VECTORIZED`
- **Find:** `remark #15388: vectorization support: unmasked aligned unit stride load`

**Memory operation reduction:**
- **Before (Solution 05):** 63 reads + 63 writes = **126 ops per row**
- **After (Solution 09):** 1 read + 1 write = **2 ops per row**
- **Savings:** **98% fewer accesses to `b[i]`**

✅ **Checkpoint:** Best manual optimization, 22 GFLOPS, 10.8x speedup

**Key Learning:** Manual optimization still matters - reducing memory traffic gave a significant over best automatic solution

---

## Activity 2: Inter-Procedural Optimization (IPO)

**Goal:** Cross-file optimization via function inlining and constant propagation

### Step 1: Test Without IPO

**Compile and test:**
```bash
cd ../10-ipo
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```

The code is the same as 09-combined.

- **Record time:** ________ sec (~0.37s expected)
- **Record GFLOPS:** ________ (~22 expected)

✅ **Checkpoint:** Baseline for IPO comparison

---

### Step 2: Enable IPO

**Compile and test:**
```bash
cd ../10-ipo
icx -O2 -xHost -ipo multiply.c driver.c -o matvec
./matvec
```
- **Record time:** ________ sec (~0.25s expected)
- **Record GFLOPS:** ________ (~31.8 expected)

**Check IPO report:**
```bash
 icx -g -O2 -xHost -ipo -qopt-report=3 -qopt-report-phase=ipo -qopt-report-file=stdout multiply.c driver.c
```
- **Find:** `-> INLINE: matvec driver.c(116,9)`

✅ **Checkpoint:** Ultimate optimization achieved, 31.8 GFLOPS, 16.4x speedup

---

## Performance Summary

```
Solution                | Time (s) | GFLOPS | Speedup | Category
------------------------|----------|--------|---------|------------------
00-baseline (no-vec)    | 4.158447 | 1.939185 |   1.00x | Not vectorized
00-baseline (vec on)    | 4.159490 | 1.938699 |    .99x | Failed (runtime vars)
01-unit-stride          | 0.553565 | 14.567395 |   7.51x | First success ★
02-ivdep                | 0.722107 | 11.167320 |   5.75x | Break dependencies
03-fargument-noalias    | 0.554485 | 14.543225 |   7.49x | Flag + ivdep
04-restrict             | 0.547832 | 14.719841 |   7.59x | Keyword + ivdep
05-alignment-declspec   | 0.722968 | 11.154021 |   5.75x | Aligned allocation
06-alignment-assume     | 0.731306 | 11.026848 |   5.68x | Pointer trap ⚠
07-alignment-pragma     | 0.723168 | 11.150936 |   5.75x | Aligned pragma
08-padding              | 0.529614 | 15.467869 |   7.85x | Best automatic ★
09-combined             | 0.368948 | 22.203671 |  11.27x | Manual best ★★
10-ipo                  | 0.257373 | 31.829291 |  16.15x | Ultimate ★★★
```

**Key milestones:**
- **7.6x:** First vectorization (unit-stride)
- **7.7x:** Best automatic (alignment-declspec)
- **10.8x:** Manual optimization (scalar accumulator)
- **16.4x:** IPO (cross-file inlining)

---

## Advanced Exercise: ZMM Registers (Optional)

For `double` (8 bytes per element):

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
cd ../09-combined
icx -O2 -xHost multiply.c driver.c -o matvec
./matvec
```

- **Record time:** ________ sec (~0.36s expected)
- **Record GFLOPS:** ________ (~22.2 expected)

**Verify:**
```bash
icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c | grep "vector length"
```
**Find:** `remark #15305: vectorization support: vector length 4`

✅ **Checkpoint:** Baseline for vector length comparison

**Before testing ZMM registers, predict:**
- Will it be faster? 
- By how much? (2X wider vectors = 2X throughput?)
---

### Step 2: Test With  ZMM:

```bash
cd ../09-combined
icx -O2 -xHost -qopt-zmm-usage=high multiply.c driver.c -o matvec_zmm
./matvec_zmm
```

- **Record time:** ________ sec (~0.27s expected)
- **Record GFLOPS:** ________ (~30 expected)


**Verify vector length 8:**
```bash
icx -g -O2 -xHost -qopt-zmm-usage=high -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c | grep "vector length"
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

---