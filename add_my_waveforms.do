

# add waves to waveform
add wave uut/M1_unit/Enable
add wave Clock_50
add wave -divider {state of milestone 1}
add wave uut/M1_unit/M1_state
add wave -decimal uut/SRAM_address
add wave -divider {counters for milestone 1}
add wave -decimal uut/M1_unit/RGB_count
add wave -decimal uut/M1_unit/Y_count
add wave -decimal uut/M1_unit/UV_count
add wave -divider {some label for my divider}
add wave uut/SRAM_we_n
add wave -decimal uut/SRAM_write_data
add wave -decimal uut/SRAM_read_data


