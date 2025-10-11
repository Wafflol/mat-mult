onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_1d_systolic/clk
add wave -noupdate /tb_1d_systolic/reset
add wave -noupdate /tb_1d_systolic/err
add wave -noupdate -radix unsigned /tb_1d_systolic/a_in
add wave -noupdate -radix unsigned /tb_1d_systolic/b_in
add wave -noupdate /tb_1d_systolic/valid_a
add wave -noupdate /tb_1d_systolic/valid_b
add wave -noupdate -radix unsigned /tb_1d_systolic/out
add wave -noupdate -divider top_right
add wave -noupdate -label clk /tb_1d_systolic/clk
add wave -noupdate -label valid_A /tb_1d_systolic/dut/topRight/valid_a
add wave -noupdate -label valid_b /tb_1d_systolic/dut/topRight/valid_b
add wave -noupdate -label a_in -radix unsigned /tb_1d_systolic/dut/topRight/a_in
add wave -noupdate -label b_in -radix unsigned /tb_1d_systolic/dut/topRight/b_in
add wave -noupdate -label x -radix unsigned /tb_1d_systolic/dut/topRight/x
add wave -noupdate -label a -radix unsigned /tb_1d_systolic/dut/topRight/a
add wave -noupdate -label b -radix unsigned /tb_1d_systolic/dut/topRight/b
add wave -noupdate -label acc_out -radix unsigned /tb_1d_systolic/dut/topRight/acc_out
add wave -noupdate -divider top_left
add wave -noupdate -label clk /tb_1d_systolic/clk
add wave -noupdate -label valid_a /tb_1d_systolic/dut/topLeft/valid_a
add wave -noupdate -label valid_b /tb_1d_systolic/dut/topLeft/valid_b
add wave -noupdate -label a_in -radix unsigned /tb_1d_systolic/dut/topLeft/a_in
add wave -noupdate -label b_in -radix unsigned /tb_1d_systolic/dut/topLeft/b_in
add wave -noupdate -label x -radix unsigned /tb_1d_systolic/dut/topLeft/x
add wave -noupdate -label a -radix unsigned /tb_1d_systolic/dut/topLeft/a
add wave -noupdate -label b -radix unsigned /tb_1d_systolic/dut/topLeft/b
add wave -noupdate -label acc_out -radix unsigned /tb_1d_systolic/dut/topLeft/acc_out
add wave -noupdate -label valid_a_out /tb_1d_systolic/dut/topLeft/valid_a_out
add wave -noupdate -label valid_b_out /tb_1d_systolic/dut/topLeft/valid_b_out
add wave -noupdate -label a_out /tb_1d_systolic/dut/topLeft/a_out
add wave -noupdate -label b_out /tb_1d_systolic/dut/topLeft/b_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {74 ps}
