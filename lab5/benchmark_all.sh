#!/bin/bash
# Benchmark all N-body simulation versions and compare performance

echo "======================================"
echo "N-Body Simulation Performance Benchmark"
echo "======================================"
echo ""

# Check if binaries exist
if [ ! -f "ver0/nbody.x" ]; then
    echo "Error: Binaries not found!"
    echo "Please run: ./build_all.sh first"
    exit 1
fi

# Detect threading configuration
THREADS=${OMP_NUM_THREADS:-1}
PHYSICAL=$(( $(lscpu | grep "Core(s) per socket" | awk '{print $4}' 2>/dev/null || echo 1) * $(lscpu | grep "Socket(s)" | awk '{print $2}' 2>/dev/null || echo 1) ))

echo "Configuration:"
echo "  OMP_NUM_THREADS: $THREADS"
echo "  Physical cores: $PHYSICAL"
echo "  Compiler: $(icx --version 2>/dev/null | head -1 || echo 'icx not found')"
echo ""

# Table header
printf "%-10s | %-12s | %-10s\n" "Version" "GFLOPS" "Speedup"
echo "-----------|--------------|------------"

# Baseline for speedup calculation
BASELINE_GFLOPS=""

# Array of versions
VERSIONS=(ver0 ver1 ver2 ver3 ver4 ver5 ver6 ver7 ver8)

for ver in "${VERSIONS[@]}"; do
    if [ -f "$ver/nbody.x" ]; then
        # Set appropriate thread count for this version
        if [[ "$ver" =~ ^ver[0-6]$ ]]; then
            # Single-threaded for ver0-ver6
            export OMP_NUM_THREADS=1
        else
            # Multi-threaded for ver7-ver8 (restore user setting)
            export OMP_NUM_THREADS=$THREADS
        fi

        # Run the simulation and capture output
        OUTPUT=$(./"$ver"/nbody.x 2>&1)

        # Extract average performance (GFLOPS)
        GFLOPS=$(echo "$OUTPUT" | grep "# Average Perfomance" | awk '{print $5}')

        # Set baseline
        if [ -z "$BASELINE_GFLOPS" ]; then
            BASELINE_GFLOPS=$GFLOPS
            SPEEDUP="1.00x"
        else
            # Calculate speedup
            SPEEDUP=$(awk "BEGIN {printf \"%.2fx\", $GFLOPS / $BASELINE_GFLOPS}")
        fi

        # Print results
        THREAD_NOTE=""
        [[ "$ver" =~ ^ver[78]$ ]] && THREAD_NOTE=" ($THREADS threads)"
        printf "%-10s | %-12s | %-10s%s\n" "$ver" "$GFLOPS" "$SPEEDUP" "$THREAD_NOTE"
    else
        echo "$ver: Binary not found, skipping..."
    fi
done

echo ""
echo "======================================"
echo "Benchmark complete!"
echo "======================================"
