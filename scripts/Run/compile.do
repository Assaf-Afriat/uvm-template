# QuestaSim Compile Script for UVM-template
# Usage: vsim -c -do compile.do
# Run from scripts/Run directory

cd ../..

vlib sim/work
vmap work sim/work

# Compile interface
vlog -sv -work work +incdir+interface interface/dut_if.sv

# Compile DUT with coverage
vlog -sv -work work +cover=bcesft +incdir+dut dut/dut.sv

# Compile SVA Assertions
vlog -sv -work work +incdir+sva sva/dut_assertions.sv

# UVM macros include path — built-in is 1.1d (mtiUvm in modelsim.ini)
set UVM_SRC "C:/questasim64_2025.1_2/verilog_src/uvm-1.1d/src"

# Compile testbench top (includes dut_pkg.sv which includes all UVM components)
vlog -sv -work work +incdir+$UVM_SRC +incdir+. +incdir+pkg +incdir+agent +incdir+env +incdir+scoreboard +incdir+coverage +incdir+sequences +incdir+test +incdir+transaction +incdir+config +incdir+callbacks +incdir+interface tb_top.sv

quit -force
