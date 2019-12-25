submodules = blinky.v PL_L0_BCD7.v PL_L0_BCD7_if.v PL_L0_BCD7_unsimp.v PL_L0_BCD7_hybrid.v PL_L0_BCD7_hybrid2.v
alldeps = top.v $(submodules)
testdeps = top_test.v $(submodules)
all: top.bin
test: top_test.fst
include Makefile.icestorm
