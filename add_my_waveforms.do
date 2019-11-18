

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
add wave -decimal uut/M1_unit/U_buffer
add wave -decimal uut/M1_unit/V_buffer
add wave -decimal uut/M1_unit/Y_buffer
add wave -decimal uut/M1_unit/U_prime
add wave -decimal uut/M1_unit/V_prime
add wave -divider {Odd RGBs}
add wave -decimal uut/M1_unit/R_odd
add wave -decimal uut/M1_unit/G_odd
add wave -decimal uut/M1_unit/B_odd
add wave -divider {Even RGBs}
add wave -decimal uut/M1_unit/R_even
add wave -decimal uut/M1_unit/G_even
add wave -decimal uut/M1_unit/B_even
add wave -divider {Multiplier Results}
add wave -decimal uut/M1_unit/result_a
add wave -decimal uut/M1_unit/result_b
add wave -decimal uut/M1_unit/result_c
add wave -decimal uut/M1_unit/temp_a

