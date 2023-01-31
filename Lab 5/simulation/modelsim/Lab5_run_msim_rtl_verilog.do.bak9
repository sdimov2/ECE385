transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab\ 5 {C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab 5/MEM.sv}
vlog -sv -work work +incdir+C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab\ 5 {C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab 5/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab\ 5 {C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab 5/Mem2IO.sv}
vlog -sv -work work +incdir+C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab\ 5 {C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab 5/ISDU.sv}
vlog -sv -work work +incdir+C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab\ 5 {C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab 5/datapath.sv}
vlog -sv -work work +incdir+C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab\ 5 {C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab 5/ProgramCounter.sv}
vlog -sv -work work +incdir+C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab\ 5 {C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab 5/slc3.sv}

vlog -sv -work work +incdir+C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab\ 5 {C:/Users/sdimo_000/OneDrive/Documents/Desktop/lab5/ECE-385/Lab 5/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 2000 ns
