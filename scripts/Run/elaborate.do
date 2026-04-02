# QuestaSim Elaborate Script for UVM-template
# Usage: vsim -c -do elaborate.do
# Run from scripts/Run directory

cd ../..

vopt +acc=npr +cover=bcesft -o tb_top_opt work.tb_top

quit -force
