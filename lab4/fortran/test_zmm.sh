#!/bin/bash
source setup_ifx.sh 2>&1 >/dev/null

# Check if YMM versions exist, if not build them
echo "Checking for YMM versions..."
need_build=0
dirs=("01-unit-stride" "02-ivdep" "03-contiguous" "04-alignment"
      "05-assume-aligned" "06-padding" "07-alignment-pragma"
      "08-openmp-simd" "09-openmp-simd-best"
      "10-arraynotation" "11-arraynotation-alignment" "12-arraynotation-padding" "13-arraynotation-best"
      "14-combined" "15-ipo")

for dir in "${dirs[@]}"; do
    if [ ! -f "$dir/matvec" ]; then
        need_build=1
        break
    fi
done

if [ $need_build -eq 1 ]; then
    echo "YMM versions not found. Building with build_all.sh..."
    ./build_all.sh
    echo ""
fi

echo "=============================================="
echo "Building all solutions with ZMM (512-bit)..."
echo "=============================================="
echo ""

for dir in "${dirs[@]}"; do
    echo "Building $dir with ZMM..."
    cd "$dir"

    if [ "$dir" = "08-openmp-simd" ] || [ "$dir" = "09-openmp-simd-best" ]; then
        FLAGS="-qopenmp"
        FLAGS_DISPLAY="with -qopenmp and -qopt-zmm-usage=high"
    elif [ "$dir" = "15-ipo" ]; then
        FLAGS="-ipo"
        FLAGS_DISPLAY="with -ipo and -qopt-zmm-usage=high"
    else
        FLAGS=""
        FLAGS_DISPLAY="with -qopt-zmm-usage=high"
    fi

    # Build with ZMM
    COMPILE_CMD="ifx -fpp -O2 -xHost $FLAGS -qopt-zmm-usage=high driver.f90 multiply.f90 -o matvec_zmm"
    echo "  Compile: $COMPILE_CMD ($FLAGS_DISPLAY)"
    if $COMPILE_CMD 2>&1 | grep -qi error; then
        echo "  ✗ Build FAILED"
    else
        echo "  ✓ Executable created (matvec_zmm)"
    fi

    # Generate opt-report with ZMM
    OPT_REPORT_CMD="ifx -fpp -g -O2 -xHost $FLAGS -qopt-zmm-usage=high -qopt-report=3 -qopt-report-phase=vec -qopt-report-file=stdout multiply.f90 -c"
    echo "  Opt-report: $OPT_REPORT_CMD (ZMM)"
    $OPT_REPORT_CMD > opt-report-zmm.txt 2>&1

    # Check vectorization status
    if grep -q "LOOP WAS VECTORIZED" opt-report-zmm.txt; then
        echo "  ✓ Loop vectorized"
        # Get vector length
        vlen=$(grep "vector length" opt-report-zmm.txt | head -1 | awk '{print $5}')
        if [ -n "$vlen" ]; then
            echo "    Vector length: $vlen"
        fi
    else
        echo "  ✗ Loop NOT vectorized"
    fi

    cd ..
    echo ""
done

echo "=============================================="
echo "ZMM build complete!"
echo "=============================================="

echo ""
echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║  Performance Comparison: YMM (256-bit) vs ZMM (512-bit)                   ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""
printf "%-25s | %-12s | %-12s | %-10s\n" "Solution" "YMM (vec4)" "ZMM (vec8)" "Change"
echo "--------------------------------------------------------------------------------"

for dir in "${dirs[@]}"; do
    cd "$dir"

    # Run YMM version
    ymm=$(./matvec 2>&1 | grep "GigaFlops" | sed 's/.*=\s*\([0-9.]*\).*/\1/')

    # Run ZMM version
    zmm=$(./matvec_zmm 2>&1 | grep "GigaFlops" | sed 's/.*=\s*\([0-9.]*\).*/\1/')

    # Calculate change
    if [ -n "$ymm" ] && [ -n "$zmm" ] && [ "$ymm" != "0" ]; then
        change=$(echo "scale=1; ($zmm - $ymm) / $ymm * 100" | bc)
        printf "%-25s | %12.2f | %12.2f | %9.1f%%\n" "$dir" "$ymm" "$zmm" "$change"
    else
        printf "%-25s | %12s | %12s | %10s\n" "$dir" "ERROR" "ERROR" "N/A"
    fi

    cd ..
done

echo "--------------------------------------------------------------------------------"
