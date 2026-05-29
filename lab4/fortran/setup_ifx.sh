#!/bin/bash
# Setup script for IFX (Intel Fortran Compiler)

echo "Setting up IFX environment..."
  #module load intel-release/2026.0
  source /opt/intel/oneapi/setvars.sh

echo ""
echo "IFX environment loaded!"
echo "Compiler: $(which ifx)"
ifx --version | head -3
echo ""
echo "Usage: ifx [options] source.f90 -o output"
echo "Example: ifx -warn all test.f90 -o test"
