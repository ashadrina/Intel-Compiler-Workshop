# N-Body Gravitational Simulation Optimization

**Goal:** Optimize N-body physics simulation from **3.8 → 73+ GFLOPS single-threaded** (19x speedup), **10,000+ GFLOPS multi-threaded** (2700x+ speedup)

**Time:** 2-3 hours  
**Problem:** Gravitational force calculation for 16,000 particles over 10 time steps

**Note:** Performance results included in this README were measured using Intel® oneAPI DPC++/C++ Compiler 2026.0.0 on an Intel® Xeon® Platinum 8480+ (Sapphire Rapids) system.

---

## What is N-Body Simulation?

N-body simulation models the motion of particles under physical forces (gravity, electromagnetism, etc.). Each particle exerts a force on every other particle, requiring **O(n²) calculations** per time step.

**Applications:**
- Astrophysics (galaxy formation, star clusters)
- Molecular dynamics (protein folding)
- Plasma physics
- Computer graphics (particle systems)

**This Lab's Problem:**
Given N particles with positions `r₁, r₂, ..., rₙ` and masses `m₁, m₂, ..., mₙ`, calculate gravitational forces and update positions using Newton's law:

```
F_ij = G × m_i × m_j × (r_j - r_i) / |r_j - r_i|³
```

**Core data structure (starting point):**
```cpp
struct Particle {
    real_type pos[3];  // x, y, z position
    real_type vel[3];  // velocity
    real_type acc[3];  // acceleration
    real_type mass;    // particle mass
};
```

**Hot loop (computational kernel):**
```cpp
for (i = 0; i < n; i++) {              // For each particle i
    for (j = 0; j < n; j++) {          // Calculate force from particle j
        dx = particles[j].pos[0] - particles[i].pos[0];
        dy = particles[j].pos[1] - particles[i].pos[1];
        dz = particles[j].pos[2] - particles[i].pos[2];
        
        distanceSqr = dx*dx + dy*dy + dz*dz + softeningSquared;
        distanceInv = 1.0 / sqrt(distanceSqr);
        
        particles[i].acc[0] += dx * G * particles[j].mass * distanceInv³;
        particles[i].acc[1] += dy * G * particles[j].mass * distanceInv³;
        particles[i].acc[2] += dz * G * particles[j].mass * distanceInv³;
    }
}
```

**Optimization Challenges:**
- **Memory access patterns:** Array-of-Structures (AoS) causes gather/scatter operations
- **Loop dependencies:** Accumulation into `particles[i].acc[]` 
- **Floating-point precision:** Mixed float/double types
- **Cache utilization:** Large datasets exceed cache capacity
- **Parallelization:** Data dependencies and load balancing

---

## Setup

```bash
source setup_icx.sh
icpx --version
```

**Quick Start (automated):**
```bash
./build_all.sh      # Build all versions (ver0-ver8)
./benchmark_all.sh  # Run performance comparison
./clean_all.sh      # Clean all build artifacts
```

**Manual Mode:** Follow activities below for step-by-step learning

---

## Activity 1: Baseline vs Optimized Compiler Flags

### Understanding Compiler Flags

**All versions use these base flags:**
```bash
-g -std=c++11 -O2 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13
```

**Flag explanations:**
- `-g` - Debug symbols (optional, useful for profiling and better opt reports)
- `-std=c++11` - C++11 standard
- `-O2` - Moderate optimization with auto-vectorization
- `--gcc-install-dir=...` - Tell ICX where to find C++ headers, may be required on some systems

**Additional flags used in ver1-ver8:**
- `-xCORE-AVX512` - Target AVX-512 instruction set (Skylake-X and newer)
- `-qopt-zmm-usage=high` - Aggressively use 512-bit ZMM registers
- `-qopt-report=3` - Generate detailed optimization reports (creates `.optrpt` files)
- `-qopt-report-phase=vec`
- `-qopenmp` - Enable OpenMP threading (ver7-ver8 only)

---

### Step 1: Baseline Performance (ver0)

**Goal:** Establish baseline with `-O2` optimization only

**Compile and run:**
```bash
cd ver0
icpx -g -std=c++11 -O2 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13 \
     GSimulation.cpp main.cpp -o nbody.x
./nbody.x
```

or execute `make && make run`

**Example of the output:**
```
===============================
 Initialize Gravity Simulation
 nPart = 16000; nSteps = 10; dt = 0.1
------------------------------------------------
 s       dt      kenergy     time (s)    GFlops
------------------------------------------------
 1       0.1     26.405      1.9571      3.7935
 2       0.2     313.77      1.9574      3.793
 3       0.3     926.56      1.9574      3.793
 4       0.4     1866.4      1.957       3.7937
 5       0.5     3135.6      1.9572      3.7933
 6       0.6     4737.6      1.957       3.7937
 7       0.7     6676.6      1.9572      3.7933
 8       0.8     8957.7      1.9571      3.7935
 9       0.9     11587       1.9572      3.7934
 10      1       14572       1.9568      3.794

# Number Threads     : 1
# Total Time (s)     : 19.572
# Average Perfomance : 3.7935 +- 0.00030204
===============================
```

- **Record baseline GFLOPS:** ________ (expected ~3.8)

**Generate optimization report:**
```bash
icpx -g -std=c++11 -O2 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13 \
     -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout GSimulation.cpp -c
```

Even when limited to vectorization analysis using `-qopt-report-phase=vec`, the report remains very lengthy. The critical loops we aim to optimize are located in `GSimulation::start()`. We can focus the report on specific functions using: `-qopt-report-names=unmangled -qopt-report-routine=GSimulation::start`.

```cpp
   132        for (j = 0; j < n; j++)
   133        {
   134            real_type dx, dy, dz;
   135            real_type distanceSqr = 0.0;
   136            real_type distanceInv = 0.0;
   137
   138            dx = particles[j].pos[0] - particles[i].pos[0];       //1flop
   139            dy = particles[j].pos[1] - particles[i].pos[1];       //1flop
   140            dz = particles[j].pos[2] - particles[i].pos[2];       //1flop
   141
   142            distanceSqr = dx*dx + dy*dy + dz*dz + softeningSquared;       //6flops
   143            distanceInv = 1.0 / sqrt(distanceSqr);                        //1div+1sqrt
   144
   145            particles[i].acc[0] += dx * G * particles[j].mass * distanceInv * distanceInv * distanceInv;  //6flops
   146            particles[i].acc[1] += dy * G * particles[j].mass * distanceInv * distanceInv * distanceInv;  //6flops
   147            particles[i].acc[2] += dz * G * particles[j].mass * distanceInv * distanceInv * distanceInv;  //6flops
   148
   149        }
```

Therefore, the optimization report is more effectively generated using: 

```bash
icpx -g -std=c++11 -O2 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13 \
     -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout \
	 -qopt-report-names=unmangled -qopt-report-routine=GSimulation::start GSimulation.cpp -c
```

This capability is also integrated into the Makefile, and can be invoked directly by executing: `make FILTER=yes`. This option generates filtered optimization reports. You can find the report in `GSimulation.optrpt`.

**What to look for:**
```
LOOP BEGIN at GSimulation.cpp(132,7)
    remark #15300: LOOP WAS VECTORIZED
    remark #15305: vectorization support: vector length 2
    remark #15328: vectorization support: unmasked gather load
```

**Analysis Questions:**
1. Was the inner loop vectorized?
2. What vector length was used?
3. What type of memory access?
4. Why is performance modest?

<details>
<summary>Click to reveal answers</summary>

1. **YES** - Look for `remark #15300: LOOP WAS VECTORIZED`
2. **Vector length 2** for doubles (conservative choice)
3. **Gather load** - `remark #15328: vectorization support: unmasked gather load` (inefficient for scattered memory in AoS layout)
4. **Gather operations + short vector length** limit performance gains despite vectorization

</details>

✅ **Checkpoint:** Baseline established, auto-vectorization observed but limited by data structure

---

### Step 2: Enable AVX-512 with ZMM Registers (ver1)

**Goal:** Explicitly target AVX-512 and enable wide vector registers

**Compile and run:**
```bash
cd ../ver1
make clean && make FILTER=yes
make run
```

**Makefile differences from ver0:**
```diff
diff Makefile ../ver0/Makefile
3c3
< OPTFLAGS = -xCORE-AVX512 -qopt-zmm-usage=high
---
> OPTFLAGS =
```

The example output is: 
```
./nbody.x
===============================
 Initialize Gravity Simulation
 nPart = 16000; nSteps = 10; dt = 0.1
------------------------------------------------
 s       dt      kenergy     time (s)    GFlops
------------------------------------------------
 1       0.1     26.405      0.95228     7.7964
 2       0.2     313.77      0.95165     7.8015
 3       0.3     926.56      0.95168     7.8013
 4       0.4     1866.4      0.95176     7.8006
 5       0.5     3135.6      0.95213     7.7976
 6       0.6     4737.6      0.9517      7.8011
 7       0.7     6676.6      0.95167     7.8014
 8       0.8     8957.7      0.95163     7.8017
 9       0.9     11587       0.95245     7.795
 10      1       14572       0.95183     7.8

# Number Threads     : 1
# Total Time (s)     : 9.5189
# Average Perfomance : 7.7998 +- 0.0022002
===============================
```

- **Record GFLOPS:** ________ (expected ~7.8, **2x improvement**)

**Check optimization report (automatically generated):**
```bash
cat GSimulation.optrpt
```

**Questions:**
1. Did performance improve?
2. Did vector length increase?
3. Are gather operations still present?

<details>
<summary>Click to reveal answers</summary>

1. **YES** - Approximately 2x faster than ver0
2. **Check your GSimulation.optrpt** - Look for `remark #15305: vectorization support: vector length` (should see larger vector length with AVX-512)
3. **YES** - Gather operations remain because the AoS data structure issue persists. Look for `remark #15328: vectorization support: unmasked gather load`

</details>

**Key Insight:** Compiler flags improve performance, but data layout still limits vectorization efficiency.

✅ **Checkpoint:** AVX-512 enabled, performance doubled, optimization reports now generated automatically

---

## Activity 2: Code-Level Optimizations (ver2-ver6)

**Important Note:** From ver2 through ver6, **compiler flags remain unchanged**. All performance improvements come from **code modifications**, not new compiler flags.

**Flags used in ver2-ver6 (same as ver1):**
```bash
icpx -g -std=c++11 -O2 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13 \
     -xCORE-AVX512 -qopt-zmm-usage=high -qopt-report=3 \
     GSimulation.cpp main.cpp -o nbody.x
```

---

### Step 1: Floating Point Precision Fixes (ver2)

**Goal:** Eliminate float/double conversions

**Code changes:**
```cpp
diff ver1/GSimulation.cpp ver2/GSimulation.cpp
114c114
<   const double softeningSquared = 1e-3;
---
>   const float softeningSquared = 1e-3f;
116c116
<   const double G = 6.67259e-11;
---
>   const float G = 6.67259e-11f;
135,136c135,136
<         real_type distanceSqr = 0.0;
<         real_type distanceInv = 0.0;
---
>         real_type distanceSqr = 0.0f;
>         real_type distanceInv = 0.0f;
```

**Compile and run:**
```bash
cd ../ver2
make clean && make FILTER=yes
make run
```

- **Record GFLOPS:** ________ (expected ~11.5, **3x from baseline**)

**Questions:**
1. Why does consistent precision help?
2. Did compiler flags change?
3. What's the trade-off?

<details>
<summary>Click to reveal answers</summary>

1. **Avoids conversion instructions** - Mixing `float` and `double` requires costly conversion operations. Consistent `float` usage eliminates these.
2. **NO** - Compiler flags remain identical to ver1
3. **Precision vs Performance** - `float` provides ~7 significant digits vs `double`'s ~15 digits. For physics simulations, single precision is often sufficient and enables better SIMD utilization (16 floats vs 8 doubles per ZMM register).

</details>

✅ **Checkpoint:** FP precision fixed through code changes, 50% improvement over ver1

---

### Step 2: Data Structure Transformation - AoS to SoA (ver3)

**Goal:** Enable efficient unit-stride memory access

**Understanding the transformation:**

This version introduces a major difference in the code structure. 

**Current (AoS - Array of Structures):**
```cpp
struct Particle {
    real_type pos[3], vel[3], acc[3], mass;
};
Particle particles[n];

// Memory: [x0 y0 z0 ...m0] [x1 y1 z1 ...m1] [x2 ...]
//         |<-particle 0->| |<-particle 1->|
```

**Problem for vectorization:**
```cpp
for (j = 0; j < n; j++) {
    dx = particles[j].pos[0] - particles[i].pos[0];
    //   ^^^^^^^^^^^^^^^^^^
}
```
Accessing `pos[0]` for `j=0,1,2,3` requires:
- `&particles[0].pos[0]`, `&particles[1].pos[0]`, `&particles[2].pos[0]`
- Separated by sizeof(Particle) bytes = GATHER OPERATION (slow on SIMD hardware!)
- Accesses are strided (non-contiguous)

**New (SoA - Structure of Arrays):**
```cpp
struct ParticleSoA {
    real_type *pos_x, *pos_y, *pos_z;
    real_type *vel_x, *vel_y, *vel_z;
    real_type *acc_x, *acc_y, *acc_z;
    real_type *mass;
};
```

- pos_x[j], pos_x[j+1], pos_x[j+2]... are contiguous:
```cpp
pos_x: [x0 x1 x2 x3 x4 ...] 
pos_y: [y0 y1 y2 y3 y4 ...]
pos_z: [z0 z1 z2 z3 z4 ...]
```
- Enables unit-stride memory access
```cpp
for (j = 0; j < n; j++) {
    dx = particles->pos_x[j] - particles->pos_x[i];
    //   ^^^^^^^^^^^^^^^^^^^
    //   Now pos_x[0], pos_x[1], pos_x[2], pos_x[3] are ADJACENT
    //   = UNIT STRIDE ACCESS (efficient SIMD load!)
}
```
- Ideal for SIMD vector loads

**Review code changes:**
```bash
cd ../ver3
diff ../ver2/Particle.hpp Particle.hpp
diff ../ver2/GSimulation.cpp GSimulation.cpp | head -50
```

After we rewrite the code, the loop that we are working on starts from line 145: 
```cpp
   145       for (j = 0; j < n; j++)
   146       {
   147           real_type dx, dy, dz;
   148           real_type distanceSqr = 0.0f;
   149           real_type distanceInv = 0.0f;
   150
   151           dx = particles->pos_x[j] - particles->pos_x[i];        //1flop
   152           dy = particles->pos_y[j] - particles->pos_y[i];        //1flop
   153           dz = particles->pos_z[j] - particles->pos_z[i];        //1flop
   154
   155           distanceSqr = dx*dx + dy*dy + dz*dz + softeningSquared;        //6flops
   156           distanceInv = 1.0f / sqrtf(distanceSqr);                       //1div+1sqrt
   157
   158           particles->acc_x[i] += dx * G * particles->mass[j] * distanceInv * distanceInv * distanceInv; //6flops
   159           particles->acc_y[i] += dy * G * particles->mass[j] * distanceInv * distanceInv * distanceInv; //6flops
   160           particles->acc_z[i] += dz * G * particles->mass[j] * distanceInv * distanceInv * distanceInv; //6flops
   161       }
   162     }
```

**Compile and run:**
```bash
make clean && make FILTER=yes
make run
```

- **Record GFLOPS:** ________ (expected ~5.1)

**⚠️ Performance Anomaly:**
Expected improvement, but performance **decreased** from ver2! This requires investigation - likely the SoA implementation is incomplete or has other bottlenecks.

**Verify optimization report:**
```bash
cat GSimulation.optrpt 
```

Can you spot the root cause? 

<details>
<summary>Click to reveal answer</summary>

```bash
cat GSimulation.optrpt  | grep "LOOP BEGIN at GSimulation.cpp (145, 6)" -A 3
```

Output:
```
LOOP BEGIN at GSimulation.cpp (145, 6)
	remark #15344: Loop was not vectorized: vector dependence prevents vectorization
	remark #15346: vector dependence: assumed FLOW dependence between [ GSimulation.cpp (158, 3) ] and [ GSimulation.cpp (151, 8) ]
	remark #15346: vector dependence: assumed FLOW dependence between [ GSimulation.cpp (158, 3) ] and [ GSimulation.cpp (151, 30) ]
```

**Root Cause:** The inner loop (line 145) **was not vectorized** due to detected dependencies:
- Line 158: `particles->acc_x[i] += ...` (write to accumulator)
- Lines 151-153: `particles->pos_x[j] - particles->pos_x[i]` (reads)

The compiler conservatively assumes these operations may have dependencies and refuses vectorization. Despite SoA's better memory layout (unit stride access), the accumulation pattern prevents vectorization.

**Why ver2 was faster:** ver2 used gather operations (expensive but vectorized), while ver3 has efficient memory access patterns but **no vectorization at all** - scalar execution is slower than vectorized gathers.

</details>

**We can attempt SIMD vectorization (Optional Exercise):**

The solution is already hinned in the code and quarded by the macro:
```cpp
	142  #ifdef SIMD
   143  #pragma omp simd
   144  #endif
   145       for (j = 0; j < n; j++)
   146       {
   147           real_type dx, dy, dz;
   148           real_type distanceSqr = 0.0f;
   149           real_type distanceInv = 0.0f;
   ...
```
What #pragma omp simd does
- Instructs the compiler to vectorize the loop
- Executes multiple iterations in parallel using SIMD
- Assumes no data dependencies between iterations

⚠️ Forcing SIMD may break correctness

However, you may try by using the same makefile: 

```bash 
make clean && make FORCE_SIMD=yes
make run
```

The expected result is that the compiler refuses to vectorize: 

```bash 
icpx -g -std=c++11 -O2 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13 -xCORE-AVX512 -qopt-zmm-usage=high -qopt-report=3 -qopenmp -DSIMD  -c GSimulation.cpp -o GSimulation.o
GSimulation.cpp:143:1: warning: loop not vectorized: the optimizer was unable to perform the requested transformation; the
      transformation might be disabled or specified as part of an unsupported transformation ordering [-Wpass-failed=transform-warning]
  143 | #pragma omp simd
      | ^
1 warning generated.
```

and the performance results is still the same, ~5 GFlops. We will discuss the correct implementation of openMP SIMD on the next step. Before going to it, we still have on open question: the assumed FLOW dependence identified by the compiler. 

**Fixing the Dependence Issue (Optional Exercise):**

The file `GSimulation-moveout.cpp` demonstrates a solution: move the accumulation outside the inner loop using scalar temporaries. Explore the difference yourself!

**Try it yourself:**
```bash
# Use the alternative implementation (already added to Makefile)
make clean && make moveout FILTER=yes
make run-moveout
```

Check the optimization report - the inner loop should now vectorize! Compare:
```bash
# Original (dependency issue):
cat GSimulation.optrpt  | grep "LOOP BEGIN at GSimulation.cpp (145, 6)" -A 20

# After moveout fix - look for vectorization success:
cat GSimulation-moveout.optrpt  | grep "LOOP BEGIN at GSimulation-moveout.cpp (145, 6)" -A 20
```

**Note:** Ver3 offers TWO ways to fix the vectorization issue:
1. **Scalar temporaries** (GSimulation-moveout.cpp) - demonstrated in ver3's moveout target above
2. **Loop interchange** (swap i/j loops) - adopted in ver4 onward

Ver4+ demonstrate approach #2 (loop interchange) with explicit SIMD pragmas.

✅ **Checkpoint:** SoA structure implemented, dependency issue identified and solution demonstrated

---

### Step 3: SIMD Pragmas (ver4)

**Goal:** Force vectorization with explicit directives

```bash
cd ../ver4
diff ../ver3/GSimulation.cpp GSimulation.cpp
```


**Code changes:**
```cpp
<    for (i = 0; i < n; i++)// update acceleration
---
>    for (j = 0; j < n; j++)// update acceleration
142,145c142,143
< #ifdef SIMD
< #pragma omp simd
< #endif
<      for (j = 0; j < n; j++)
---
> #pragma omp simd
>     for (i = 0; i < n; i++)
```

**Compile and run:**
```bash
make clean && make FILTER=yes
make run
```

- **Record GFLOPS:** ________ (expected ~53, similar to ver3)

**Check for SIMD directive in report:**
```bash
cat GSimulation.optrpt | grep "LOOP BEGIN at GSimulation.cpp (142, 1)" -A 10 | grep "SIMD"
```

Expected: `remark #15301: SIMD LOOP WAS VECTORIZED`

Performance improved significantly however there is still a room for further improvements, for example, unaligned loads and stores. 

✅ **Checkpoint:** SIMD pragmas applied, compiler confirms vectorization

---

### Step 4: Memory Alignment (ver5)

**Goal:** Enable aligned loads/stores. 

**Code changes:**
```cpp
// Replace standard allocation:
particles->pos_x = new real_type[n];

// With aligned allocation:
particles->pos_x = (real_type*)_mm_malloc(n * sizeof(real_type), 64);

// And add alignment hints:
particles->pos_x = (real_type*)__assume_aligned(particles->pos_x, 64);

// Deallocation:
_mm_free(particles->pos_x);  // NOT delete[]!
```

**Why 64-byte alignment?**
- AVX-512 ZMM registers: 512 bits = 64 bytes
- 8 doubles per vector operation
- Aligned loads (`vmovapd`) are faster than unaligned (`vmovupd`)

**Compile and run:**
```bash
cd ../ver5
make clean &&  make FILTER=yes
make run 
```

- **Record GFLOPS:** ________ (expected ~73, **19x from baseline!** ⭐)

**This is the major performance breakthrough!**

**Verify aligned access:**
```bash
cat GSimulation.optrpt | grep "LOOP BEGIN at GSimulation.cpp (155, 6)" -A 15
```

Before (ver4): `remark #15389: vectorization support: unmasked unaligned unit stride load:  
After  (ver5): `remark #15388: vectorization support: unmasked aligned unit stride load`

✅ **Checkpoint:** Memory alignment achieved, major performance gain (~14x improvement from ver4)

**Note:** Ver5 removes the `#pragma omp simd` from ver4. Why?
- Scalar temporaries eliminate loop-carried dependencies
- Aligned memory provides compiler with perfect conditions
- When dependencies are truly resolved, compiler auto-vectorizes effectively
- This demonstrates that removing optimization barriers > forcing with pragmas

This concludes the basic vectorization part of the demo. At this point, only two topics are missing:

- advanced cache optimization (loop-tiling) (ver6)
- enabling OpenMP (ver7)

---

### Step 5: Cache Optimization - Loop Tiling (ver6)

**Goal:** Improve cache reuse for large datasets

**The Problem:**
- 16,000 particles × 10 fields × 4 bytes = 640 KB >> L2 cache
- Original nested loop processes particles sequentially
- By the time we return to particle 0, its data is evicted from cache

**The Solution (loop tiling with local accumulation):**

Instead of processing one particle at a time across all interactions:
```cpp
// Original (ver5):
for (i = 0; i < n; i++) {        // One particle
    ax_i = 0;
    for (j = 0; j < n; j++) {     // All interactions
        ax_i += force(i,j);
    }
    acc_x[i] = ax_i;
}
```

Ver6 processes a TILE of particles together:
```cpp
// Tiled (ver6):
for (ii = 0; ii < n; ii += tileSize) {     // Tile start
    acc_tile[0..tileSize-1] = 0;           // Local accumulator
    for (j = 0; j < n; j++) {              // All interactions
        for (i = ii; i < ii+tileSize; i++) { // Process tile
            acc_tile[i-ii] += force(i,j);  // Accumulate locally
        }
    }
    acc_x[ii..ii+tileSize-1] = acc_tile;   // Write back tile
}
```

**Benefits:**
- `tileSize` particles stay in registers/L1 cache during j-loop
- Reduces memory traffic: N writes → N/tileSize write-backs
- Better vectorization: compiler can optimize tile operations

**Note:** This is strip mining with local accumulation, not full 2D block tiling.
```

**Compile and run:**
```bash
cd ../ver6
make clean && make FILTER=yes
make run
```

- **Record GFLOPS:** ________ (expected ~48)

**⚠️ Unexpected Result:** Performance **decreased** from ver5!

**Possible reasons:**
- Tile size may not be optimal for this hardware
- Additional loop overhead
- Compiler may have automatically done blocking in ver5

**Experiment:** Modify `tileSize` in GSimulation.cpp and rebuild.

<details>
<summary>Click to reveal answer</summary>
Try 16 and check if the results improve.
</details>

✅ **Checkpoint:** Cache tiling implemented, demonstrates that not all optimizations improve performance

---

## Activity 3: OpenMP Threading (ver7-ver8)

**Compiler flags change - OpenMP added without any conditions:**
```bash
cd ../ver7
$ diff ../ver3/Makefile Makefile
5,7c5
< ifeq ($(FORCE_SIMD), yes)
<       OMPFLAGS = -qopenmp -DSIMD
< endif
---
> OMPFLAGS = -qopenmp -DSIMD
```

---

### Step 1: Basic OpenMP Parallelization (ver7)

**Goal:** Parallelize outer loop across multiple threads

**Code changes:**
```cpp
   141  #pragma omp parallel for
   142     for (i = 0; i < n; i++)// update acceleration
   143     {
...
   157       for (j = 0; j < n; j++)
   158       {
...
   173       }   
   177     }
   178     energy = 0;
   179  #pragma omp parallel for reduction(+:energy)
```

**Why parallelize the outer loop?**
- Each particle i can be processed independently
- Inner loop accumulates to `particles[i]` (data dependency)

**Compile and run:**
```bash
cd ../ver7
make clean && make FILTER=yes 
make run
```

**Threading Recommendation:**

Set OMP_NUM_THREADS to match your hardware threads for best performance:
```bash
# Auto-detect your system's thread count:
export OMP_NUM_THREADS=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
make run
```

For optimal results:
- Start with physical cores only (best per-thread performance)
- Then enable hyperthreading (typically adds 20-40% more throughput)
- N-body is embarrassingly parallel → expect near-linear scaling up to physical cores

**Check thread count:**
```bash
export OMP_NUM_THREADS=224
make run
```

- **Record GFLOPS:** ________ (expected ~6000-7000, **1700x+ from baseline!** ⭐⭐)

**Test thread scaling:**
```bash
./test_scaling.sh ver7
```

✅ **Checkpoint:** OpenMP threading enabled, massive multi-core speedup achieved

---

### Step 2: Combined Optimizations (ver8)

**Goal:** Combine cache tiling with OpenMP threading

**This version includes:**
- Memory alignment (`_mm_malloc`)
- Loop tiling
- OpenMP parallelization

**Compile and run:**
```bash
cd ../ver8
export OMP_NUM_THREADS=224
make clean && make FILTER=yes
make run
```

- **Record GFLOPS (224 threads):** ________ (expected ~10,000+, **2700x+ from baseline!** ⭐⭐⭐)

**Questions:**
1. **Is speedup linear with thread count up to physical cores?**
   - Expected: Near-linear for embarrassingly parallel workload
   - Physical cores typically show 80-95% scaling efficiency
   
2. **What limits perfect linear scaling?**
   - Memory bandwidth saturation at high core counts
   - NUMA effects when crossing socket boundaries
   - Cache coherency traffic between cores

3. **Does hyperthreading help this workload?**
   - Test: Compare physical cores only vs. full hardware threads
   - Expected: 20-40% additional throughput from hyperthreading
   - N-body benefits from HT: memory latency hiding + FP unit sharing
   
   ```bash
   # Physical cores only:
   PHYSICAL=$(( $(lscpu | grep "Core(s) per socket" | awk '{print $2}') * $(lscpu | grep "Socket(s)" | awk '{print $2}') ))
   export OMP_NUM_THREADS=$PHYSICAL
   ./nbody.x
   
   # With hyperthreading:
   export OMP_NUM_THREADS=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
   ./nbody.x
   ```

4. **For your system:** Run `./test_scaling.sh ver8` to see the full scaling curve

✅ **Checkpoint:** Ultimate optimization achieved, combining vectorization + threading

---

## Performance Summary

**Actual benchmark results:**

Version    | GFLOPS       | Speedup
-----------|--------------|------------
ver0       | 3.7933       | 1.00x
ver1       | 7.7957       | 2.06x
ver2       | 11.504       | 3.03x
ver3       | 5.0946       | 1.34x
ver4       | 53.951       | 14.22x
ver5       | 73.011       | 19.25x
ver6       | 48.163       | 12.70x
ver7       | 6466.6       | 1704.74x   (224 threads)
ver8       | 10568        | 2785.96x   (224 threads)

**Key milestones:**

1. **Ver2: Floating-Point Consistency (2.7x)** - ~3.7 → 11.5 GFLOPS
   - Issue: Mixed float/double operations prevented vectorization
   - Fix: Consistent `real_type` usage + avoid double-precision intermediates
   - Lesson: Data type consistency matters for SIMD

2. **Ver5: Memory Alignment (19.7x total, 13.8x from ver2)** - ~11.5 → 73 GFLOPS ⭐
   - Issue: Unaligned memory prevented efficient AVX-512 vector loads
   - Fix: `_mm_malloc(64)` + `__builtin_assume_aligned` + scalar temporaries
   - Lesson: **This is the single biggest single-threaded optimization** - proper memory layout + alignment unlock full SIMD potential
   - Technical: Enabled `vmovapd` (aligned load) vs `vmovupd` (unaligned), removed loop dependencies

3. **Ver7: OpenMP Threading (2700x total, 82x from ver5)** - ~73 → 6000+ GFLOPS ⭐⭐
   - Issue: Single-threaded performance maxed out
   - Fix: `#pragma omp parallel for` on outer loop
   - Lesson: After maximizing single-thread performance, **threading provides massive scaling**
   - On modern many-core systems: Near-linear scaling for embarrassingly parallel workload

**Why ver6 (tiling) decreased performance:**
- Tile size (8) too small for this hardware/problem size
- Added loop overhead without cache benefits
- Ver5 already had excellent cache behavior for 16K particles
- Tiling helps more with 100K+ particles or smaller caches

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

**Test Thread Scaling:**  
```bash
./test_scaling.sh ver8
```

---

## Advanced Experiments

### 1. Tune Cache Tile Size (ver6)

**Modify** `tileSize` in `ver6/GSimulation.cpp`. Try: 32, 64, 128, 256, 512

**Rebuild and test:**
```bash
cd ver6
# Edit GSimulation.cpp
make clean && make
make run
```

**Question:** What tile size is optimal for your hardware?

---

### 2. Problem Size Scaling

**Test** with different particle counts:
```bash
./nbody.x 4000    # Small (fits in L2)
./nbody.x 8000    # Medium
./nbody.x 16000   # Default
./nbody.x 32000   # Large (exceeds L3)
```

**Questions:**
1. Does ver6 (tiling) help more with larger problem sizes?
2. At what size does memory bandwidth become the bottleneck?

---

### 3. Floating-Point Optimization for ver8

**Goal:** Explore how floating-point compilation flags affect performance

**Current ver8 configuration:**
```bash
cd ver8
cat Makefile | grep COMPFLAGS
# COMPFLAGS = -g -std=c++11 -O2 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13
```

#### Step 1: Baseline Measurement

Record current ver8 performance:
```bash
cd ver8
export OMP_NUM_THREADS=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
make clean && make
make run
```
- **Baseline GFLOPS:** ________ (write down for comparison)

#### Step 2: Try Fast Math Optimizations

**Option A: `-ffast-math` (aggressive, may change results)**

Edit `ver8/Makefile`, change COMPFLAGS:
```makefile
COMPFLAGS = -g -std=c++11 -O2 -ffast-math --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13
```

Rebuild and test:
```bash
make clean && make
make run
```
- **GFLOPS with -ffast-math:** ________
- **Speedup:** ________

**What `-ffast-math` does:**
- Disables IEEE 754 strict compliance
- Allows reassociation: `(a+b)+c` → `a+(b+c)`
- Assumes no NaN/Inf values
- Enables reciprocal approximations: `x/y` → `x * (1/y)`

**Trade-off:** May change numerical results slightly

#### Step 3: Try Individual Fast-Math Components (Safer)

If full `-ffast-math` is too aggressive, try individual flags:

**Option B: `-fno-math-errno` (safe, no side effects)**
```makefile
COMPFLAGS = -g -std=c++11 -O2 -fno-math-errno --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13
```
- Removes errno setting for math functions like `sqrt()`
- Allows inlining and vectorization of math calls
- No accuracy impact

**Option C: `-ffinite-math-only` (assumes no NaN/Inf)**
```makefile
COMPFLAGS = -g -std=c++11 -O2 -ffinite-math-only --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13
```
- Assumes inputs/outputs are always finite
- Enables aggressive optimizations
- Safe for N-body (no NaN expected)

**Option D: Combined safe flags**
```makefile
COMPFLAGS = -g -std=c++11 -O2 -fno-math-errno -ffinite-math-only --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13
```

Test each and record GFLOPS.

#### Step 4: Try -O3 Optimization Level

```makefile
COMPFLAGS = -g -std=c++11 -O3 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13
```

**What `-O3` adds over `-O2`:**
- More aggressive loop transformations
- Function inlining (larger binaries)
- Predictive commoning
- Loop unrolling

May help or hurt depending on cache behavior.
 
#### Step 5: Results Table

Fill in your measurements:

| Configuration | GFLOPS | vs Baseline | Notes |
|---------------|---------|-------------|-------|
| Baseline (-O2) | _____ | 1.00x | Original |
| -ffast-math | _____ | _____ | Most aggressive |
| -fno-math-errno | _____ | _____ | Safe, no side effects |
| -ffinite-math-only | _____ | _____ | Assumes no NaN/Inf |
| Combined safe | _____ | _____ | errno + finite |
| -O3 | _____ | _____ | Higher optimization |

#### Analysis Questions:

1. **Which flag gave the best performance?**

2. **Did `-ffast-math` improve performance?** If yes, by how much?
   - Expected: 0-10% for this workload (mostly memory-bound)
   - FP optimizations help more in compute-bound code

3. **Check numerical correctness:**
   ```bash
   # Run both versions and compare kinetic energy values
   grep "kenergy" baseline_output.txt
   grep "kenergy" fastmath_output.txt
   ```
   Are results identical? Close enough?

4. **Why might FP optimizations have limited impact on ver8?**
   <details>
   <summary>Click for answer</summary>
   
   Ver8 with many threads is primarily **memory-bandwidth bound**, not compute-bound:
   - Many threads × GFLOPS/thread = theoretical peak exceeds achieved
   - Gap indicates: Memory system can't feed all cores fast enough
   - FP optimizations reduce compute time, but memory time dominates
   
   To see FP optimization benefits:
   - Test with fewer threads (where compute matters more)
   - Try larger problems (more compute per byte loaded)
   - Profile with VTune to confirm memory vs compute bottleneck
   </details>

#### Recommendation:

For production N-body code:
```makefile
# Best balance of safety and performance:
COMPFLAGS = -g -std=c++11 -O2 -fno-math-errno -ffinite-math-only --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13
```
These flags are safe for N-body physics (no NaN/Inf expected) and provide modest gains without accuracy concerns.

---
 
## Troubleshooting

**Problem:** "icpx: command not found"  
**Solution:** Run `source setup_icx.sh` to load compiler environment

**Problem:** "C++ header location not resolved; check installed C++ dependencies"  
**Solution:** This is why all Makefiles include `--gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13`.

If you still see this error, check your GCC installation:
```bash
# Find installed GCC versions
ls /usr/lib/gcc/x86_64-linux-gnu/

# Update Makefile if you have different GCC version (e.g., GCC 12):
COMPFLAGS = -g -std=c++11 -O2 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/12
```

---
 