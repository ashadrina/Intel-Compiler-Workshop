#!/bin/bash

# Lab 4 Fortran: Build All Variants
# Compiles all Fortran optimization variants and generates optimization reports

source setup_ifx.sh

echo "=============================================="
echo "Lab 4 Fortran: Building All Optimization Variants"
echo "Compiler: Intel Fortran Compiler (IFX)"
echo "Target: Intel CPU with AVX-512 support"
echo "Note: Using 64-byte alignment for AVX-512"
echo "=============================================="
echo ""

# Array of directory names (in execution order)
dirs=("00-baseline" "01-unit-stride" "02-ivdep" "03-contiguous"
      "04-alignment" "05-assume-aligned" "06-padding" "07-alignment-pragma"
      "08-openmp-simd" "09-openmp-simd-best"
      "10-arraynotation" "11-arraynotation-alignment" "12-arraynotation-padding" "13-arraynotation-best"
      "14-combined" "15-ipo")

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
        COMPILE_CMD="ifx -fpp -O2 -xHost -no-vec driver.f90 multiply.f90 -o matvec-no-vec"
        echo "    Compile: $COMPILE_CMD"
        if $COMPILE_CMD 2>&1 | grep -qi error; then
            echo "    ✗ Build FAILED (no-vec)"
            ((fail_count++))
        else
            echo "    ✓ Executable created (matvec-no-vec)"
            ((success_count++))
        fi

        # Generate opt-report for no-vec version
        OPT_REPORT_CMD="ifx -fpp -g -O2 -no-vec -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c"
        echo "    Opt-report: $OPT_REPORT_CMD"
        $OPT_REPORT_CMD > opt-report-no-vec.txt 2>&1
        echo "    ✗ Loop NOT vectorized (by design: -no-vec)"
        echo ""

        echo "  Building baseline (vec enabled)..."
        COMPILE_CMD="ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec"
        echo "    Compile: $COMPILE_CMD"
    elif [ "$dir" = "08-openmp-simd" ] || [ "$dir" = "09-openmp-simd-best" ]; then
        COMPILE_CMD="ifx -fpp -O2 -xHost -qopenmp driver.f90 multiply.f90 -o matvec"
        echo "  Compile: $COMPILE_CMD (with -qopenmp)"
    elif [ "$dir" = "15-ipo" ]; then
        COMPILE_CMD="ifx -fpp -O2 -xHost -ipo driver.f90 multiply.f90 -o matvec"
        echo "  Compile: $COMPILE_CMD (with -ipo)"
    else
        COMPILE_CMD="ifx -fpp -O2 -xHost driver.f90 multiply.f90 -o matvec"
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
    if [ "$dir" = "08-openmp-simd" ] || [ "$dir" = "09-openmp-simd-best" ]; then
        OPT_REPORT_CMD="ifx -fpp -g -O2 -xHost -qopenmp -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c"
        echo "  Opt-report: $OPT_REPORT_CMD (with -qopenmp)"
    elif [ "$dir" = "15-ipo" ]; then
        OPT_REPORT_CMD="ifx -fpp -g -O2 -xHost -ipo -qopt-report=3 -qopt-report-phase=ipo,vec -qopt-report-file=stdout multiply.f90 -c"
        echo "  Opt-report: $OPT_REPORT_CMD (with -ipo and IPO phase)"
    else
        OPT_REPORT_CMD="ifx -fpp -g -O2 -xHost -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c"
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
