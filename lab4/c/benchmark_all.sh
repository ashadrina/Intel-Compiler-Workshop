#!/bin/bash

# Lab 4: Benchmark All Variants
# Runs all variants and compares performance

echo "=============================================="
echo "Lab 4: Matrix-Vector Multiplication Benchmark"
echo "=============================================="
echo ""
echo "Solution                | Time (s) | GFLOPS | Speedup | Category"
echo "------------------------|----------|--------|---------|------------------"

# Store baseline time for speedup calculation
baseline_time=0
baseline_gflops=0

dirs=("00-baseline" "01-unit-stride" "02-ivdep" "03-fargument-noalias"
      "04-restrict" "05-alignment-declspec" "06-alignment-assume"
      "07-alignment-pragma" "08-padding" "09-combined" "10-ipo")

for dir in "${dirs[@]}"; do
    # Special handling for baseline - test both no-vec and vec versions
    if [ "$dir" = "00-baseline" ]; then
        # Test no-vec version
        exe="${dir}/matvec-no-vec"
        if [ -f "$exe" ]; then
            output=$(./"$exe" 2>&1)
            time=$(echo "$output" | grep "Elapsed time" | awk '{print $4}')
            gflops=$(echo "$output" | grep "GigaFlops" | awk '{print $3}')

            if [ -z "$time" ] || [ -z "$gflops" ]; then
                printf "%-23s | ERROR: Could not parse output\n" "00-baseline (no-vec)"
            else
                baseline_time=$time
                baseline_gflops=$gflops
                printf "%-23s | %8s | %6s | %7s | Not vectorized\n" "00-baseline (no-vec)" "$time" "$gflops" "1.00x"
            fi
        else
            printf "%-23s | NOT BUILT - run ./build_all.sh first\n" "00-baseline (no-vec)"
        fi

        # Test vec-enabled version (will fail to vectorize but show same perf)
        exe="${dir}/matvec"
        if [ -f "$exe" ]; then
            output=$(./"$exe" 2>&1)
            time=$(echo "$output" | grep "Elapsed time" | awk '{print $4}')
            gflops=$(echo "$output" | grep "GigaFlops" | awk '{print $3}')

            if [ -z "$time" ] || [ -z "$gflops" ]; then
                printf "%-23s | ERROR: Could not parse output\n" "00-baseline (vec on)"
            else
                speedup=$(echo "scale=2; $baseline_time / $time" | bc)
                printf "%-23s | %8s | %6s | %6sx | Failed (runtime vars)\n" "00-baseline (vec on)" "$time" "$gflops" "$speedup"
            fi
        else
            printf "%-23s | NOT BUILT - run ./build_all.sh first\n" "00-baseline (vec on)"
        fi
        continue
    fi

    # Handle all other solutions - use full directory name
    exe="${dir}/matvec"
    if [ -f "$exe" ]; then
        # Run and capture output
        output=$(./"$exe" 2>&1)
        time=$(echo "$output" | grep "Elapsed time" | awk '{print $4}')
        gflops=$(echo "$output" | grep "GigaFlops" | awk '{print $3}')

        if [ -z "$time" ] || [ -z "$gflops" ]; then
            printf "%-23s | ERROR: Could not parse output\n" "$variant"
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
            "03-fargument-noalias")
                category="Flag + ivdep"
                ;;
            "04-restrict")
                category="Keyword + ivdep"
                ;;
            "05-alignment-declspec")
                category="Aligned allocation"
                ;;
            "06-alignment-assume")
                category="Pointer trap ⚠"
                ;;
            "07-alignment-pragma")
                category="Aligned pragma"
                ;;
            "08-padding")
                category="Best automatic ★"
                ;;
            "09-combined")
                category="Manual best ★★"
                ;;
            "10-ipo")
                category="Ultimate ★★★"
                ;;
            *)
                category=""
                ;;
        esac

        printf "%-23s | %8s | %6s | %7s | %s\n" "$dir" "$time" "$gflops" "$speedup" "$category"
    else
        printf "%-23s | NOT BUILT - run ./build_all.sh first\n" "$dir"
    fi
done

echo ""
echo "=============================================="
echo "Notes:"
echo "  - Speedup is relative to baseline (1.00x)"
echo "  - Higher GFLOPS = better performance"
echo "  - Top solutions typically within 2-5% variance"
echo "=============================================="
