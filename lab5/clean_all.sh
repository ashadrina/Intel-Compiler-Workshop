#!/bin/bash
# Clean all build artifacts from all versions

echo "Cleaning all N-Body simulation build artifacts..."
echo ""

# Array of versions
VERSIONS=(ver0 ver1 ver2 ver3 ver4 ver5 ver6 ver7 ver8)

for ver in "${VERSIONS[@]}"; do
    if [ -d "$ver" ]; then
        echo "Cleaning $ver..."
        cd "$ver"
        make clean > /dev/null 2>&1 || true
        # Also remove any leftover files
        rm -f *.o *.x *.optrpt *.s 2>/dev/null || true
        cd ..
    fi
done

# Clean benchmark results
rm -f benchmark_results.txt 2>/dev/null || true

echo ""
echo "✓ All build artifacts cleaned"
echo ""
echo "To rebuild: ./build_all.sh"
