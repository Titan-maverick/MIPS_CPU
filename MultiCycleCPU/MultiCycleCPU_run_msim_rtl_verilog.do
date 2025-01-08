transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/ROM1P.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/InputSignal.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/ClockDivider.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/PCAddr.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/Display.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/DataMemory.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/InstructionDecoder.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/InstructionMemory.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/MultiCycleCPU.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/SignZeroExtend.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/RegisterFile.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/PC.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/ControlUnit.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/ALU.v}
vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/CLKmode.v}

vlog -vlog01compat -work work +incdir+E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/simulation/modelsim {E:/Project/GitHubProject/MIPS_CPU/MultiCycleCPU/simulation/modelsim/MultiCycleCPU.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  MultiCycleCPU_vlg_tst

add wave *
view structure
view signals
run 2000 ps
