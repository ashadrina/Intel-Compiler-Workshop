#!/bin/bash
# Test OpenMP thread scaling for ver7 or ver8

VERSION=${1:-ver8}

if [ ! -f "$VERSION/nbody.x" ]; then
    echo "Error: $VERSION/nbody.x not found!"
    echo "Usage: $0 [ver7|ver8]"
    echo "Please run ./build_all.sh first"
    exit 1
fi

echo "======================================"
echo "OpenMP Thread Scaling Test"
echo "Version: $VERSION"
echo "======================================"
echo ""

# Detect hardware configuration
CORES=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
PHYSICAL=$(lscpu | grep "^Core(s) per socket:" | awk '{print $4}')
SOCKETS=$(lscpu | grep "^Socket(s):" | awk '{print $2}')
PHYSICAL_TOTAL=$((PHYSICAL * SOCKETS))

echo "Hardware: $SOCKETS socket(s) × $PHYSICAL cores = $PHYSICAL_TOTAL physical cores"
echo "Total hardware threads: $CORES (with hyperthreading)"
echo ""

# Build test array: powers of 2, physical cores, and full thread count
THREAD_COUNTS=(1 2 4 8)

# Add 16, 32, 64 if available
[ "$CORES" -ge 16 ] && THREAD_COUNTS+=(16)
[ "$CORES" -ge 32 ] && THREAD_COUNTS+=(32)
[ "$CORES" -ge 64 ] && THREAD_COUNTS+=(64)

# Add physical cores count if not already included
if ! printf '%s\n' "${THREAD_COUNTS[@]}" | grep -q "^${PHYSICAL_TOTAL}$"; then
    THREAD_COUNTS+=($PHYSICAL_TOTAL)
fi

# Add full thread count (with HT)
if [ "$CORES" -gt "$PHYSICAL_TOTAL" ]; then
    THREAD_COUNTS+=($CORES)
fi

# Sort thread counts
IFS=$'\n' THREAD_COUNTS=($(sort -n <<<"${THREAD_COUNTS[*]}"))

printf "%-10s | %-12s | %-10s\n" "Threads" "GFLOPS" "Scaling"
echo "-----------|--------------|------------"

BASELINE_GFLOPS=""

for t in "${THREAD_COUNTS[@]}"; do
    if [ "$t" -le "$CORES" ]; then
        export OMP_NUM_THREADS=$t

        # Run simulation and extract performance
        OUTPUT=$(./"$VERSION"/nbody.x 2>&1)
        GFLOPS=$(echo "$OUTPUT" | grep "Average Perfomance" | awk '{print $5}')

        # Calculate scaling
        if [ -z "$BASELINE_GFLOPS" ]; then
            BASELINE_GFLOPS=$GFLOPS
            SCALING="1.00x"
        else
            SCALING=$(awk "BEGIN {printf \"%.2fx\", $GFLOPS / $BASELINE_GFLOPS}")
        fi

        # Highlight physical vs hyperthreading boundary
        NOTE=""
        [ "$t" -eq "$PHYSICAL_TOTAL" ] && NOTE=" ← physical cores"
        [ "$t" -eq "$CORES" ] && NOTE=" ← with hyperthreading"

        printf "%-10s | %-12s | %-10s%s\n" "$t" "$GFLOPS" "$SCALING" "$NOTE"
    fi
done

echo ""
echo "Observations:"
echo "  - Near-linear scaling up to physical cores indicates excellent parallelization"
echo "  - Hyperthreading typically adds 20-40% additional throughput"
echo "  - Diminishing returns beyond physical cores is expected"
