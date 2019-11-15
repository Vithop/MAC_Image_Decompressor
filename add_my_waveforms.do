

# add waves to waveform
add wave Clock_50
add wave uut/M1_unit/M1_state
add wave uut/M1_unit/Enable
add wave -divider {some label for my divider}
add wave uut/SRAM_we_n
add wave -decimal uut/SRAM_write_data
add wave -decimal uut/SRAM_read_data
add wave -decimal uut/SRAM_address


