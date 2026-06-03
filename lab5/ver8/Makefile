CXX = icpx
COMPFLAGS = -g -std=c++11 -O2 --gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13
OPTFLAGS = -xCORE-AVX512 -qopt-zmm-usage=high
REPFLAGS = -qopt-report=3
OMPFLAGS = -qopenmp -DSIMD

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

clean:
	rm -f $(OBJSC) nbody.x *.optrpt *.s

.PHONY: all cpu run asm clean
