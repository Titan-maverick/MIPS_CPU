transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/EnterExtend.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/EnterInteger.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/Output.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/ShiftLeft2.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/Mux2to1_5.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/Mux2to1.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/myPC.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/ControlUnit.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/SingleCycleCPU.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/RegFile.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/MyALU.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/InstructionMem.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/InstructionCut.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/Extend.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/DataMem.v}
vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test {E:/Project/QuartusProject/test/Add.v}

vlog -vlog01compat -work work +incdir+E:/Project/QuartusProject/test/simulation/modelsim {E:/Project/QuartusProject/test/simulation/modelsim/SingleCycleCPU.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  SingleCycleCPU_vlg_tst

add wave *
view structure
view signals
run 300 ns
