`ifndef DEFINE_STATE

// This defines the states
typedef enum logic [1:0] {
	S_IDLE,
	S_ENABLE_UART_RX,
	S_WAIT_UART_RX
} top_state_type;

typedef enum logic [1:0] {
	S_RXC_IDLE,
	S_RXC_SYNC,
	S_RXC_ASSEMBLE_DATA,
	S_RXC_STOP_BIT
} RX_Controller_state_type;

typedef enum logic [2:0] {
	S_US_IDLE,
	S_US_STRIP_FILE_HEADER_1,
	S_US_STRIP_FILE_HEADER_2,
	S_US_START_FIRST_BYTE_RECEIVE,
	S_US_WRITE_FIRST_BYTE,
	S_US_START_SECOND_BYTE_RECEIVE,
	S_US_WRITE_SECOND_BYTE
} UART_SRAM_state_type;

typedef enum logic [3:0] {
	S_VS_WAIT_NEW_PIXEL_ROW,
	S_VS_NEW_PIXEL_ROW_DELAY_1,
	S_VS_NEW_PIXEL_ROW_DELAY_2,
	S_VS_NEW_PIXEL_ROW_DELAY_3,
	S_VS_NEW_PIXEL_ROW_DELAY_4,
	S_VS_NEW_PIXEL_ROW_DELAY_5,
	S_VS_FETCH_PIXEL_DATA_0,
	S_VS_FETCH_PIXEL_DATA_1,
	S_VS_FETCH_PIXEL_DATA_2,
	S_VS_FETCH_PIXEL_DATA_3
} VGA_SRAM_state_type;

typedef enum logic [3:0]{
	//lEAD IN STATES
	S_M1_LI_FIRST_READ,
	S_M1_LI_V1,
	S_M1_LI_U1,
	S_M1_LI_Y1,
	S_M1_LI_CALC_V,
	//REPEATING STATES
	S_M1_IDLE,
	S_M1_CALC_V_PRIME,
	S_M1_CALC_U_PRIME,
	S_M1_CALC_FIRST_RB,
	S_M1_CALC_FIRST_G,
	S_M1_CALC_SECOND_RB,
	S_M1_CALC_SECOND_G,
	// S_M1_
	// S_M1_
	// S_M1_
	// S_M1_
	//LEAD OUT STATES
} Milestone1_state_type;
/*
typedef enum logic [3:0]{
	S_M2_IDLE,
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
	S_M2_
} Milestone2_state_type;
*/
`define DEFINE_STATE 1
`endif
