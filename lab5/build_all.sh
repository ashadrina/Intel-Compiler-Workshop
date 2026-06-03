#!/bin/bash
# Build all N-body simulation versions (ver0-ver8)

set -e  # Exit on error

echo "======================================"
echo "Building all N-Body simulation versions"
echo "======================================"
echo ""

# Check if compiler is available
if ! command -v icx &> /dev/null; then
    echo "Error: ICX compiler not found!"
    echo "Please run: source setup_icx.sh"
    exit 1
fi

# Array of versions to build
VERSIONS=(ver0 ver1 ver2 ver3 ver4 ver5 ver6 ver7 ver8)

# Build each version
for ver in "${VERSIONS[@]}"; do
    echo "----------------------------------------"
    echo "Building $ver..."
    echo "----------------------------------------"

    if [ -d "$ver" ]; then
        cd "$ver"
        make clean > /dev/null 2>&1 || true
        if make; then
            echo "✓ $ver built successfully"
        else
            echo "✗ $ver build failed"
            cd ..
            exit 1
        fi
        cd ..
    else
        echo "⚠ Directory $ver not found, skipping..."
    fi
    echo ""
done

echo "======================================"
echo "All versions built successfully!"
echo "======================================"
echo ""
echo "Next steps:"
echo "  ./benchmark_all.sh    # Run performance comparison"
echo "  cd ver0 && ./nbody.x  # Run a specific version"
