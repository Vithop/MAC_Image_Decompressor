

# add waves to waveform
add wave uut/M1_unit/Enable
add wave Clock_50
add wave uut/top_state
add wave uut/M1_unit/M1_state
add wave -divider {SRAM states}
add wave uut/SRAM_we_n
add wave -unsigned uut/SRAM_address
add wave -decimal uut/SRAM_write_data
add wave -decimal uut/SRAM_read_data
# Milestone 2 waves 
add wave -divider {state of milestone 2}
add wave uut/M2_unit/M2_FS_state
add wave uut/M2_unit/M2_WS_state
add wave uut/M2_unit/M2_CTCS_state
add wave uut/M2_unit/FS_done
add wave uut/M2_unit/CS_done
add wave uut/M2_unit/CT_done
add wave uut/M2_unit/CS_start
add wave uut/M2_unit/CT_start

# add wave -divider {Fetch S values}
# add wave -unsigned uut/M2_unit/block_index
# add wave -decimal uut/M2_unit/preIDCT_i
# add wave -decimal uut/M2_unit/preIDCT_j
# add wave -decimal uut/M2_unit/row_address
# add wave -decimal uut/M2_unit/Reading_Y_flag

add wave -divider {DP RAM 0}
# add wave -unsigned uut/M2_unit/DP_address0_a
# add wave -unsigned uut/M2_unit/DP_address0_b
# add wave uut/M2_unit/write_enable0_a
# add wave uut/M2_unit/write_enable0_b
add wave -decimal uut/M2_unit/write_data0_a
add wave -decimal uut/M2_unit/write_data0_b
# add wave -decimal uut/M2_unit/read_data0_a
# add wave -decimal uut/M2_unit/read_data0_b

# add wave -divider {DP RAM 1}
# add wave -unsigned uut/M2_unit/DP_address1_a
# add wave -unsigned uut/M2_unit/DP_address1_b
# add wave uut/M2_unit/write_enable1_a
# add wave uut/M2_unit/write_enable1_b
add wave -decimal uut/M2_unit/write_data1_a
# add wave -decimal uut/M2_unit/write_data1_b
# add wave -decimal uut/M2_unit/read_data1_a
# add wave -decimal uut/M2_unit/read_data1_b

add wave -divider {Calculations}
add wave -decimal uut/M2_unit/CTCS_B_write_data
add wave -decimal uut/M2_unit/CTCS_A0_read_data
add wave -decimal uut/M2_unit/matrix_A_row
add wave -decimal uut/M2_unit/nxt_matrix_A_row
add wave -decimal uut/M2_unit/temp_B_val_0
add wave -decimal uut/M2_unit/result_a
add wave -decimal uut/M2_unit/result_b
add wave -decimal uut/M2_unit/temp_a
add wave -decimal uut/M2_unit/temp_b
add wave -decimal uut/M2_unit/Op1
add wave -decimal uut/M2_unit/Op2
add wave -decimal uut/M2_unit/Op3
add wave -decimal uut/M2_unit/Op4
add wave -decimal uut/M2_unit/A_i
# add wave -decimal uut/M2_unit/A_j
add wave -decimal uut/M2_unit/Ic0
add wave -decimal uut/M2_unit/Jc0
add wave -decimal uut/M2_unit/Ic1
add wave -decimal uut/M2_unit/Jc1
add wave -decimal uut/M2_unit/B_i
add wave -decimal uut/M2_unit/B_j



# Milestone 1 waves 
#add wave -divider {state of milestone 1}
# add wave uut/M1_unit/M1_state
# add wave -unsigned uut/SRAM_address
# add wave -divider {counters for milestone 1}
# add wave -unsigned uut/M1_unit/RGB_count
# add wave -unsigned uut/M1_unit/Y_count
# add wave -unsigned uut/M1_unit/UV_count
# add wave uut/M1_unit/read_UV_flag
# add wave -divider {some label for my divider}

# add wave -decimal uut/M1_unit/Read_byte1
# add wave -decimal uut/M1_unit/Read_byte2
# add wave -divider {Calculated Values}
# add wave -decimal uut/M1_unit/V_buffer
# add wave -decimal uut/M1_unit/U_buffer
# add wave -decimal uut/M1_unit/Y_buffer
# add wave -decimal uut/M1_unit/V_prime
# add wave -decimal uut/M1_unit/U_prime
# add wave -divider {Odd RGBs}
# add wave -decimal uut/M1_unit/R_odd
# add wave -decimal uut/M1_unit/G_odd
# add wave -decimal uut/M1_unit/B_odd
# add wave -divider {Even RGBs}
# add wave -decimal uut/M1_unit/R_even
# add wave -decimal uut/M1_unit/G_even
# add wave -decimal uut/M1_unit/B_even
# add wave -divider {Multiplier Results}
# add wave -decimal uut/M1_unit/result_a
# add wave -decimal uut/M1_unit/result_b
# add wave -decimal uut/M1_unit/result_c
# add wave -decimal uut/M1_unit/R_temp
# add wave -decimal uut/M1_unit/G_temp
# add wave -decimal uut/M1_unit/B_temp
# add wave -decimal uut/M1_unit/Op1
# add wave -decimal uut/M1_unit/Op2
# add wave -decimal uut/M1_unit/Op3
# add wave -decimal uut/M1_unit/Op4
# add wave -decimal uut/M1_unit/Op5
# add wave -decimal uut/M1_unit/Op6

