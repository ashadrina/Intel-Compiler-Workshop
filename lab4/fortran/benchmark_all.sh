#!/bin/bash

# Lab 4 Fortran: Benchmark All Variants
# Runs all Fortran variants and compares performance

# Source compiler environment
source setup_ifx.sh > /dev/null 2>&1

echo "=============================================="
echo "Lab 4 Fortran: Matrix-Vector Multiplication Benchmark"
echo "=============================================="
echo ""
echo "Solution             | Time (s) | GFLOPS | Speedup | Category"
echo "---------------------|----------|--------|---------|------------------"

# Store baseline time for speedup calculation
baseline_time=0
baseline_gflops=0

dirs=("00-baseline" "01-unit-stride" "02-ivdep" "03-contiguous"
      "04-alignment" "05-assume-aligned" "06-padding" "07-alignment-pragma"
      "08-openmp-simd" "09-openmp-simd-best"
      "10-arraynotation" "11-arraynotation-alignment" "12-arraynotation-padding" "13-arraynotation-best"
      "14-combined" "15-ipo")

for dir in "${dirs[@]}"; do
    # Special handling for baseline - test both no-vec and vec versions
    if [ "$dir" = "00-baseline" ]; then
        # Test no-vec version
        exe="${dir}/matvec-no-vec"
        if [ -f "$exe" ]; then
            output=$(./"$exe" 2>&1)
            time=$(echo "$output" | grep "Elapsed time" | sed 's/.*=\s*\([0-9.]*\).*/\1/')
            gflops=$(echo "$output" | grep "GigaFlops" | sed 's/.*=\s*\([0-9.]*\).*/\1/')

            if [ -z "$time" ] || [ -z "$gflops" ]; then
                printf "%-20s | ERROR: Could not parse output\n" "00-baseline (no-vec)"
            else
                baseline_time=$time
                baseline_gflops=$gflops
                printf "%-20s | %8s | %6s | %7s | Not vectorized\n" "00-baseline (no-vec)" "$time" "$gflops" "1.00x"
            fi
        else
            printf "%-20s | NOT BUILT - run ./build_all.sh first\n" "00-baseline (no-vec)"
        fi

        # Test vec-enabled version (will fail to vectorize but show same perf)
        exe="${dir}/matvec"
        if [ -f "$exe" ]; then
            output=$(./"$exe" 2>&1)
            time=$(echo "$output" | grep "Elapsed time" | sed 's/.*=\s*\([0-9.]*\).*/\1/')
            gflops=$(echo "$output" | grep "GigaFlops" | sed 's/.*=\s*\([0-9.]*\).*/\1/')

            if [ -z "$time" ] || [ -z "$gflops" ]; then
                printf "%-20s | ERROR: Could not parse output\n" "00-baseline (vec on)"
            else
                speedup=$(echo "scale=2; $baseline_time / $time" | bc)
                printf "%-20s | %8s | %6s | %6sx | Failed (module vars)\n" "00-baseline (vec on)" "$time" "$gflops" "$speedup"
            fi
        else
            printf "%-20s | NOT BUILT - run ./build_all.sh first\n" "00-baseline (vec on)"
        fi
        continue
    fi

    # Handle all other solutions - use full directory name
    exe="${dir}/matvec"
    if [ -f "$exe" ]; then
        # Run and capture output
        output=$(./"$exe" 2>&1)
        time=$(echo "$output" | grep "Elapsed time" | sed 's/.*=\s*\([0-9.]*\).*/\1/')
        gflops=$(echo "$output" | grep "GigaFlops" | sed 's/.*=\s*\([0-9.]*\).*/\1/')

        if [ -z "$time" ] || [ -z "$gflops" ]; then
            printf "%-20s | ERROR: Could not parse output\n" "$dir"
            continue
        fi

        # Calculate speedup
        if [ "$baseline_time" != "0" ]; then
            speedup=$(echo "scale=2; $baseline_time / $time" | bc)
            speedup="${speedup}x"
        else
            speedup="N/A"
        fi

        # Determine category
        case "$dir" in
            "01-unit-stride")
                category="First success ★"
                ;;
            "02-ivdep")
                category="Break dependencies"
                ;;
            "03-contiguous")
                category="Contiguous attr"
                ;;
            "04-alignment")
                category="Enforced alignment"
                ;;
            "05-assume-aligned")
                category="Alignment assertion"
                ;;
            "06-padding")
                category="Padding"
                ;;
            "07-alignment-pragma")
                category="Alignment pragma"
                ;;
            "08-openmp-simd")
                category="OpenMP SIMD"
                ;;
            "09-openmp-simd-best")
                category="OpenMP + alignment"
                ;;
            "10-arraynotation")
                category="Array notation base"
                ;;
            "11-arraynotation-alignment")
                category="Array + alignment"
                ;;
            "12-arraynotation-padding")
                category="Array + padding"
                ;;
            "13-arraynotation-best")
                category="Array notation best"
                ;;
            "14-combined")
                category="Manual optimization"
                ;;
            "15-ipo")
                category="IPO (best) ★★★"
                ;;
            *)
                category=""
                ;;
        esac

        printf "%-20s | %8s | %6s | %7s | %s\n" "$dir" "$time" "$gflops" "$speedup" "$category"
    else
        printf "%-20s | NOT BUILT - run ./build_all.sh first\n" "$dir"
    fi
done

echo ""
echo "=============================================="
echo "Notes:"
echo "  - Speedup is relative to baseline (1.00x)"
echo "  - Higher GFLOPS = better performance"
echo "  - Best: 07-alignment-pragma, 09-arraynotation-best, or 11-openmp-simd-best"
echo "  - Top solutions typically within 2% variance"
echo "=============================================="
