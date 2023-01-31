transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/owent/OneDrive/Documents/Academics/Fall\ 2021/ECE\ 385/ECE-385/Lab\ 4/8multiplier-sdimov2-owenjs2 {C:/Users/owent/OneDrive/Documents/Academics/Fall 2021/ECE 385/ECE-385/Lab 4/8multiplier-sdimov2-owenjs2/select_adder.sv}
vlog -sv -work work +incdir+C:/Users/owent/OneDrive/Documents/Academics/Fall\ 2021/ECE\ 385/ECE-385/Lab\ 4/8multiplier-sdimov2-owenjs2 {C:/Users/owent/OneDrive/Documents/Academics/Fall 2021/ECE 385/ECE-385/Lab 4/8multiplier-sdimov2-owenjs2/reg_17.sv}
vlog -sv -work work +incdir+C:/Users/owent/OneDrive/Documents/Academics/Fall\ 2021/ECE\ 385/ECE-385/Lab\ 4/8multiplier-sdimov2-owenjs2 {C:/Users/owent/OneDrive/Documents/Academics/Fall 2021/ECE 385/ECE-385/Lab 4/8multiplier-sdimov2-owenjs2/precomp_CRA.sv}
vlog -sv -work work +incdir+C:/Users/owent/OneDrive/Documents/Academics/Fall\ 2021/ECE\ 385/ECE-385/Lab\ 4/8multiplier-sdimov2-owenjs2 {C:/Users/owent/OneDrive/Documents/Academics/Fall 2021/ECE 385/ECE-385/Lab 4/8multiplier-sdimov2-owenjs2/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/owent/OneDrive/Documents/Academics/Fall\ 2021/ECE\ 385/ECE-385/Lab\ 4/8multiplier-sdimov2-owenjs2 {C:/Users/owent/OneDrive/Documents/Academics/Fall 2021/ECE 385/ECE-385/Lab 4/8multiplier-sdimov2-owenjs2/full_adder_4.sv}
vlog -sv -work work +incdir+C:/Users/owent/OneDrive/Documents/Academics/Fall\ 2021/ECE\ 385/ECE-385/Lab\ 4/8multiplier-sdimov2-owenjs2 {C:/Users/owent/OneDrive/Documents/Academics/Fall 2021/ECE 385/ECE-385/Lab 4/8multiplier-sdimov2-owenjs2/full_adder.sv}
vlog -sv -work work +incdir+C:/Users/owent/OneDrive/Documents/Academics/Fall\ 2021/ECE\ 385/ECE-385/Lab\ 4/8multiplier-sdimov2-owenjs2 {C:/Users/owent/OneDrive/Documents/Academics/Fall 2021/ECE 385/ECE-385/Lab 4/8multiplier-sdimov2-owenjs2/control.sv}
vlog -sv -work work +incdir+C:/Users/owent/OneDrive/Documents/Academics/Fall\ 2021/ECE\ 385/ECE-385/Lab\ 4/8multiplier-sdimov2-owenjs2 {C:/Users/owent/OneDrive/Documents/Academics/Fall 2021/ECE 385/ECE-385/Lab 4/8multiplier-sdimov2-owenjs2/adder2.sv}

