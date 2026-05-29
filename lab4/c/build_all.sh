#!/bin/bash

# Lab 4: Build All Variants
# Compiles all optimization variants and generates optimization reports

source setup_icx.sh

echo "=============================================="
echo "Lab 4: Building All Optimization Variants"
echo "Compiler: Intel oneAPI ICX"
echo "Target: Intel CPU with AVX-512 support"
echo "Note: Using 64-byte alignment for AVX-512"
echo "=============================================="
echo ""

# Array of directory names (in execution order)
dirs=("00-baseline" "01-unit-stride" "02-ivdep" "03-fargument-noalias"
      "04-restrict" "05-alignment-declspec" "06-alignment-assume"
      "07-alignment-pragma" "08-padding" "09-combined" "10-ipo")

# Track successes
success_count=0
fail_count=0

for dir in "${dirs[@]}"; do
    echo "Building $dir..."
    cd "$dir" || continue

    # Special compile flags for specific solutions
    if [ "$dir" = "00-baseline" ]; then
        # Build baseline twice: with and without vectorization
        echo "  Building baseline (no-vec)..."
        COMPILE_CMD="icx -O2 -xHost -no-vec driver.c multiply.c -o matvec-no-vec"
        echo "    Compile: $COMPILE_CMD"
        if $COMPILE_CMD 2>&1 | grep -qi error; then
            echo "    ✗ Build FAILED (no-vec)"
            ((fail_count++))
        else
            echo "    ✓ Executable created (matvec-no-vec)"
            ((success_count++))
        fi

        # Generate opt-report for no-vec version
        OPT_REPORT_CMD="icx -g -O2 -no-vec -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c"
        echo "    Opt-report: $OPT_REPORT_CMD"
        $OPT_REPORT_CMD > opt-report-no-vec.txt 2>&1
        echo "    ✗ Loop NOT vectorized (by design: -no-vec)"
        echo ""

        echo "  Building baseline (vec enabled)..."
        COMPILE_CMD="icx -g -O2 -xHost driver.c multiply.c -o matvec"
        echo "    Compile: $COMPILE_CMD"
    elif [ "$dir" = "03-fargument-noalias" ]; then
        COMPILE_CMD="icx -g -O2 -xHost -fargument-noalias driver.c multiply.c -o matvec"
        echo "  Compile: $COMPILE_CMD (with -fargument-noalias)"
    elif [ "$dir" = "10-ipo" ]; then
        COMPILE_CMD="icx -g -O2 -xHost -ipo driver.c multiply.c -o matvec"
        echo "  Compile: $COMPILE_CMD (with -ipo)"
    else
        COMPILE_CMD="icx -g -O2 -xHost driver.c multiply.c -o matvec"
        echo "  Compile: $COMPILE_CMD"
    fi

    # Build executable
    if $COMPILE_CMD 2>&1 | grep -qi error; then
        echo "  ✗ Build FAILED"
        ((fail_count++))
    else
        echo "  ✓ Executable created"
        ((success_count++))
    fi

    # Generate optimization report
    if [ "$dir" = "10-ipo" ]; then
        OPT_REPORT_CMD="icx -g -O2 -xHost -ipo -qopt-report=3 -qopt-report-phase=vec,ipo -qopt-report-file=stdout multiply.c -c"
        echo "  Opt-report: $OPT_REPORT_CMD (with -ipo and IPO phase)"
    else
        OPT_REPORT_CMD="icx -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.c -c"
        echo "  Opt-report: $OPT_REPORT_CMD"
    fi
    $OPT_REPORT_CMD > opt-report.txt 2>&1

    # Check vectorization status
    if grep -q "LOOP WAS VECTORIZED" opt-report.txt; then
        echo "  ✓ Loop vectorized"
        # Get vector length
        vlen=$(grep "vector length" opt-report.txt | head -1 | awk '{print $5}')
        if [ -n "$vlen" ]; then
            echo "    Vector length: $vlen"
        fi
    else
        echo "  ✗ Loop NOT vectorized"
        # Show reason
        reason=$(grep "was not vectorized" opt-report.txt | head -1)
        if [ -n "$reason" ]; then
            echo "    Reason: $reason"
        fi
    fi

    # Check multiversioning
    if grep -q "MULTIVERSIONED" opt-report.txt; then
        echo "  ⚠  Multiversioned (runtime checks present)"
    fi

    cd ..
    echo ""
done

echo "=============================================="
echo "Build Summary:"
echo "  Successful: $success_count"
echo "  Failed:     $fail_count"
echo "=============================================="
echo ""
echo "Next step: Run ./benchmark_all.sh to measure performance"
