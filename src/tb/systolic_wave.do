onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_systolic/clk
add wave -noupdate /tb_systolic/reset
add wave -noupdate /tb_systolic/load_en
add wave -noupdate /tb_systolic/mult_en
add wave -noupdate /tb_systolic/acc_en
add wave -noupdate -radix unsigned /tb_systolic/a_in
add wave -noupdate -radix unsigned /tb_systolic/b_in
add wave -noupdate -radix unsigned -childformat {{{/tb_systolic/out[0]} -radix unsigned} {{/tb_systolic/out[1]} -radix unsigned} {{/tb_systolic/out[2]} -radix unsigned}} -expand -subitemconfig {{/tb_systolic/out[0]} {-height 17 -radix unsigned} {/tb_systolic/out[1]} {-height 17 -radix unsigned} {/tb_systolic/out[2]} {-height 17 -radix unsigned}} /tb_systolic/out
add wave -noupdate /tb_systolic/err
add wave -noupdate -divider topleft
add wave -noupdate -label a_in_tl /tb_systolic/dut/topLeft/a_in
add wave -noupdate -label b_in_tl /tb_systolic/dut/topLeft/b_in
add wave -noupdate -label load_en /tb_systolic/dut/topLeft/load_en
add wave -noupdate -label mult_en /tb_systolic/dut/topLeft/mult_en
add wave -noupdate -label acc_en /tb_systolic/dut/topLeft/acc_en
add wave -noupdate /tb_systolic/dut/topLeft/a_out
add wave -noupdate /tb_systolic/dut/topLeft/b_out
add wave -noupdate /tb_systolic/dut/topLeft/acc_out
add wave -noupdate /tb_systolic/dut/topLeft/a
add wave -noupdate /tb_systolic/dut/topLeft/b
add wave -noupdate /tb_systolic/dut/topLeft/x
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20 ps} 0}
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
WaveRestoreZoom {0 ps} {64 ps}
