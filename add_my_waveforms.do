

# add waves to waveform
add wave uut/M1_unit/Enable
add wave Clock_50
add wave -divider {state of milestone 1}
add wave uut/top_state
add wave uut/M1_unit/M1_state
add wave -unsigned uut/SRAM_address
add wave -divider {counters for milestone 1}
add wave -unsigned uut/M1_unit/RGB_count
add wave -unsigned uut/M1_unit/Y_count
add wave -unsigned uut/M1_unit/UV_count
add wave uut/M1_unit/read_UV_flag
add wave -divider {some label for my divider}
add wave uut/SRAM_we_n
add wave -decimal uut/SRAM_write_data
add wave -decimal uut/SRAM_read_data
add wave -divider {Calculated Values}
add wave -decimal uut/M1_unit/R_odd
add wave -decimal uut/M1_unit/G_odd
add wave -decimal uut/M1_unit/B_odd
add wave -decimal uut/M1_unit/result_c

