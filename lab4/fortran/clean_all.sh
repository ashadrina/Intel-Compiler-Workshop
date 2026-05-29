#!/bin/bash
#
# clean_all.sh - Remove build artifacts from all Lab 4 Fortran solution directories
#
# This script cleans object files, binaries, module files, and optimization reports
# from all numbered solution directories
#
# Usage: ./clean_all.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Lab 4 Fortran - Cleaning All Build Artifacts             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Array of solution directories
SOLUTIONS=(
    "00-baseline"
    "01-unit-stride"
    "02-ivdep"
    "03-contiguous"
    "04-alignment"
    "05-assume-aligned"
    "06-padding"
    "07-alignment-pragma"
    "08-openmp-simd"
    "09-openmp-simd-best"
    "10-arraynotation"
    "11-arraynotation-alignment"
    "12-arraynotation-padding"
    "13-arraynotation-best"
    "14-combined"
    "15-ipo"
)

total_removed=0

for dir in "${SOLUTIONS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "⚠️  Warning: Directory $dir not found, skipping..."
        continue
    fi

    echo -n "Cleaning $dir... "

    removed_count=0

    # Count and remove object files
    if ls "$dir"/*.o 1> /dev/null 2>&1; then
        removed_count=$((removed_count + $(ls "$dir"/*.o 2>/dev/null | wc -l)))
        rm -f "$dir"/*.o
    fi

    # Count and remove Fortran module files
    if ls "$dir"/*.mod 1> /dev/null 2>&1; then
        removed_count=$((removed_count + $(ls "$dir"/*.mod 2>/dev/null | wc -l)))
        rm -f "$dir"/*.mod
    fi

    # Count and remove optimization reports
    if ls "$dir"/*.optrpt 1> /dev/null 2>&1; then
        removed_count=$((removed_count + $(ls "$dir"/*.optrpt 2>/dev/null | wc -l)))
        rm -f "$dir"/*.optrpt
    fi

    if ls "$dir"/opt-report*.txt 1> /dev/null 2>&1; then
        removed_count=$((removed_count + $(ls "$dir"/opt-report*.txt 2>/dev/null | wc -l)))
        rm -f "$dir"/opt-report*.txt
    fi

    # Count and remove binary executables
    if [ -f "$dir/matvec" ]; then
        removed_count=$((removed_count + 1))
        rm -f "$dir/matvec"
    fi

    # Count and remove baseline no-vec binary
    if [ -f "$dir/matvec-no-vec" ]; then
        removed_count=$((removed_count + 1))
        rm -f "$dir/matvec-no-vec"
    fi

    # Count and remove ZMM binary (from test_zmm.sh)
    if [ -f "$dir/matvec_zmm" ]; then
        removed_count=$((removed_count + 1))
        rm -f "$dir/matvec_zmm"
    fi

    # Count and remove a.out files
    if [ -f "$dir/a.out" ]; then
        removed_count=$((removed_count + 1))
        rm -f "$dir/a.out"
    fi

    # Count and remove IPO output files if they exist
    if ls "$dir"/ipo_out.optrpt 1> /dev/null 2>&1; then
        removed_count=$((removed_count + 1))
        rm -f "$dir"/ipo_out.optrpt
    fi

    # Count and remove ZMM opt-report files
    if ls "$dir"/opt-report-zmm*.txt 1> /dev/null 2>&1; then
        removed_count=$((removed_count + $(ls "$dir"/opt-report-zmm*.txt 2>/dev/null | wc -l)))
        rm -f "$dir"/opt-report-zmm*.txt
    fi

    total_removed=$((total_removed + removed_count))

    if [ $removed_count -gt 0 ]; then
        echo "✓ (removed $removed_count file(s))"
    else
        echo "✓ (already clean)"
    fi
done

echo ""
echo "────────────────────────────────────────────────────────────"
echo "Total files removed: $total_removed"
echo ""

if [ $total_removed -gt 0 ]; then
    echo "✅ Cleanup complete! All build artifacts removed."
    echo "   Run ./build_all.sh to rebuild all solutions."
else
    echo "✅ All directories were already clean."
fi

echo ""
