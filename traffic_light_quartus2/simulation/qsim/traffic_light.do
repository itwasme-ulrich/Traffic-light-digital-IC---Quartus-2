onerror {quit -f}
vlib work
vlog -work work traffic_light.vo
vlog -work work traffic_light.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.traffic_light_vlg_vec_tst
vcd file -direction traffic_light.msim.vcd
vcd add -internal traffic_light_vlg_vec_tst/*
vcd add -internal traffic_light_vlg_vec_tst/i1/*
add wave /*
run -all
