submodules = blinky.v PL_L0_BCD7.v PL_L0_BCD7_if.v
alldeps = top.v $(submodules)
testdeps = top_test.v $(submodules)
all: top.bin
test: top_test.fst
include Makefile.icestorm
