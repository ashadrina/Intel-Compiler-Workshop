CXX = icpx
COMPFLAGS = -g -std=c++11 -O2 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13
OPTFLAGS = -xCORE-AVX512 -qopt-zmm-usage=high
REPFLAGS = -qopt-report=3
ifeq ($(FORCE_SIMD), yes)
	OMPFLAGS = -qopenmp -DSIMD
endif

ifeq ($(FILTER), yes)
        REPFLAGS+=-qopt-report-phase=vec -qopt-report-names=unmangled  -qopt-report-routine=GSimulation::start
endif

INCLUDES =

CXXFLAGS = $(COMPFLAGS) $(OPTFLAGS) $(REPFLAGS) $(OMPFLAGS)

SOURCES = GSimulation.cpp main.cpp

.SUFFIXES: .o .cpp

##########################################
OBJSC = $(SOURCES:.cpp=.o)
##########################################

EXEC=nbody.x

all: cpu

%.o: %.cpp
	$(info )
	$(info Compiling the object file for CPU: )
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

cpu: $(OBJSC)
	$(info )
	$(info Linking the CPU executable:)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(EXEC) $(OBJSC)

run:
	$(info )
	$(info Run the default test case on CPU:)
	./nbody.x

asm:GSimulation.cpp
	$(info)
	$(info Generate assembly code: )
	$(CXX) $(COMPFLAGS) $(OPTFLAGS) $^ -S

# Alternative implementation with scalar temporaries (fixes vectorization)
GSimulation-moveout.o: GSimulation-moveout.cpp
	$(info )
	$(info Compiling with scalar accumulation fix:)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o GSimulation.o

moveout: GSimulation-moveout.o main.o
	$(info )
	$(info Linking:)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(EXEC) GSimulation.o main.o

run-moveout: moveout
	$(info )
	$(info Running with fixed implementation:)
	./nbody.x

clean:
	rm -f $(OBJSC) nbody.x *.optrpt *.s

.PHONY: all cpu run asm moveout run-moveout clean