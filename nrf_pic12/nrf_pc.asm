
_my_UART1_Read:

;nrf_pc.c,17 :: 		unsigned char my_UART1_Read(){
;nrf_pc.c,19 :: 		while (!UART1_Data_Ready()){}
L_my_UART1_Read0:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_my_UART1_Read1
	GOTO       L_my_UART1_Read0
L_my_UART1_Read1:
;nrf_pc.c,20 :: 		res=UART1_Read();
	CALL       _UART1_Read+0
;nrf_pc.c,21 :: 		return res;
;nrf_pc.c,22 :: 		}
L_end_my_UART1_Read:
	RETURN
; end of _my_UART1_Read

_my_UART1_Read_buffer:

;nrf_pc.c,23 :: 		void my_UART1_Read_buffer(unsigned char * buffer,unsigned char dat_width){
;nrf_pc.c,25 :: 		for (i=0;i<dat_width;i++){
	CLRF       my_UART1_Read_buffer_i_L0+0
L_my_UART1_Read_buffer2:
	MOVF       FARG_my_UART1_Read_buffer_dat_width+0, 0
	SUBWF      my_UART1_Read_buffer_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_my_UART1_Read_buffer3
;nrf_pc.c,26 :: 		buffer[i]=my_UART1_Read();
	MOVF       my_UART1_Read_buffer_i_L0+0, 0
	ADDWF      FARG_my_UART1_Read_buffer_buffer+0, 0
	MOVWF      FLOC__my_UART1_Read_buffer+0
	CALL       _my_UART1_Read+0
	MOVF       FLOC__my_UART1_Read_buffer+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;nrf_pc.c,25 :: 		for (i=0;i<dat_width;i++){
	INCF       my_UART1_Read_buffer_i_L0+0, 1
;nrf_pc.c,27 :: 		}
	GOTO       L_my_UART1_Read_buffer2
L_my_UART1_Read_buffer3:
;nrf_pc.c,28 :: 		}
L_end_my_UART1_Read_buffer:
	RETURN
; end of _my_UART1_Read_buffer

_rx_start_simple:

;nrf_pc.c,31 :: 		void rx_start_simple(){
;nrf_pc.c,33 :: 		init_SPI();
	CALL       _init_spi+0
;nrf_pc.c,36 :: 		RX_set_static_payload(RX_PW_P0,1);
	MOVLW      17
	MOVWF      FARG_RX_set_static_payload_reg+0
	MOVLW      1
	MOVWF      FARG_RX_set_static_payload_length+0
	CALL       _RX_set_static_payload+0
;nrf_pc.c,37 :: 		RX_mode();
	CALL       _RX_mode+0
;nrf_pc.c,38 :: 		power_mode(1);
	MOVLW      1
	MOVWF      FARG_power_mode_down+0
	CALL       _power_mode+0
;nrf_pc.c,39 :: 		CE_PIN=1;
	BSF        RC2_bit+0, BitPos(RC2_bit+0)
;nrf_pc.c,40 :: 		}
L_end_rx_start_simple:
	RETURN
; end of _rx_start_simple

_tx_start_simple:

;nrf_pc.c,41 :: 		void tx_start_simple(){
;nrf_pc.c,42 :: 		unsigned char dat[1]={0xA5};
	MOVLW      165
	MOVWF      tx_start_simple_dat_L0+0
;nrf_pc.c,44 :: 		init_SPI();
	CALL       _init_spi+0
;nrf_pc.c,49 :: 		TX_mode();
	CALL       _TX_mode+0
;nrf_pc.c,50 :: 		power_mode(1);
	MOVLW      1
	MOVWF      FARG_power_mode_down+0
	CALL       _power_mode+0
;nrf_pc.c,51 :: 		CE_PIN=1;
	BSF        RC2_bit+0, BitPos(RC2_bit+0)
;nrf_pc.c,52 :: 		TX_write_buffer(dat,1);
	MOVLW      tx_start_simple_dat_L0+0
	MOVWF      FARG_TX_write_buffer_dat_width+0
	MOVLW      1
	MOVWF      FARG_TX_write_buffer_dat+0
	CALL       _TX_write_buffer+0
;nrf_pc.c,53 :: 		}
L_end_tx_start_simple:
	RETURN
; end of _tx_start_simple

_main:

;nrf_pc.c,56 :: 		void main() {
;nrf_pc.c,58 :: 		unsigned char * buffer[5]={0};
	CLRF       main_buffer_L0+0
	CLRF       main_buffer_L0+1
	CLRF       main_buffer_L0+2
	CLRF       main_buffer_L0+3
	CLRF       main_buffer_L0+4
;nrf_pc.c,60 :: 		ADCON1 = 0x04;// digital not analog
	MOVLW      4
	MOVWF      ADCON1+0
;nrf_pc.c,61 :: 		CMCON = 7;//comparators off
	MOVLW      7
	MOVWF      CMCON+0
;nrf_pc.c,63 :: 		TRISD.RD3=0;//for debugging purposes
	BCF        TRISD+0, 3
;nrf_pc.c,64 :: 		PORTD.RD3=1;
	BSF        PORTD+0, 3
;nrf_pc.c,66 :: 		UART1_init(128000);
	MOVLW      3
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;nrf_pc.c,67 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	DECFSZ     R11+0, 1
	GOTO       L_main5
	NOP
;nrf_pc.c,68 :: 		UART1_Write(0xBC);
	MOVLW      188
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;nrf_pc.c,69 :: 		UART1_Write(0xCB);
	MOVLW      203
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;nrf_pc.c,71 :: 		while(1){
L_main6:
;nrf_pc.c,72 :: 		command=my_UART1_Read();
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_command_L0+0
;nrf_pc.c,73 :: 		switch (command){
	GOTO       L_main8
;nrf_pc.c,75 :: 		case '1':arg1=my_UART1_Read();
L_main10:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,76 :: 		SPI1_Write(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;nrf_pc.c,77 :: 		break;
	GOTO       L_main9
;nrf_pc.c,78 :: 		case '2':arg1=my_UART1_Read();
L_main11:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,79 :: 		res=SPI1_Read(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_SPI1_Read_buffer+0
	CALL       _SPI1_Read+0
;nrf_pc.c,80 :: 		UART1_Write(res);
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;nrf_pc.c,81 :: 		break;
	GOTO       L_main9
;nrf_pc.c,82 :: 		case '3':CE_PIN=0;
L_main12:
	BCF        RC2_bit+0, BitPos(RC2_bit+0)
;nrf_pc.c,83 :: 		break;
	GOTO       L_main9
;nrf_pc.c,84 :: 		case '4':CE_PIN=1;
L_main13:
	BSF        RC2_bit+0, BitPos(RC2_bit+0)
;nrf_pc.c,85 :: 		break;
	GOTO       L_main9
;nrf_pc.c,86 :: 		case '5':toggle();
L_main14:
	CALL       _toggle+0
;nrf_pc.c,87 :: 		break;
	GOTO       L_main9
;nrf_pc.c,88 :: 		case '6':toggle_CSN();
L_main15:
	CALL       _toggle_CSN+0
;nrf_pc.c,89 :: 		break;
	GOTO       L_main9
;nrf_pc.c,91 :: 		case 'a':init_spi();        //init_spi
L_main16:
	CALL       _init_spi+0
;nrf_pc.c,92 :: 		break;
	GOTO       L_main9
;nrf_pc.c,93 :: 		case 'b':res=get_STATUS();  //get_STATUS
L_main17:
	CALL       _get_STATUS+0
;nrf_pc.c,94 :: 		UART1_Write(res);
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;nrf_pc.c,95 :: 		break;
	GOTO       L_main9
;nrf_pc.c,96 :: 		case 'c':arg1=my_UART1_Read(); //NRF_RW
L_main18:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,97 :: 		arg2=my_UART1_Read();
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg2_L0+0
;nrf_pc.c,98 :: 		res=NRF_RW(arg1,arg2);
	MOVF       main_arg1_L0+0, 0
	MOVWF      FARG_NRF_RW_command+0
	MOVF       R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nrf_pc.c,99 :: 		CE_PIN=1;
	BSF        RC2_bit+0, BitPos(RC2_bit+0)
;nrf_pc.c,100 :: 		UART1_Write(res);
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;nrf_pc.c,101 :: 		break;
	GOTO       L_main9
;nrf_pc.c,102 :: 		case 'd':arg1=my_UART1_Read(); //power_mode
L_main19:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,103 :: 		power_mode(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_power_mode_down+0
	CALL       _power_mode+0
;nrf_pc.c,104 :: 		break;
	GOTO       L_main9
;nrf_pc.c,105 :: 		case 'e':arg1=my_UART1_Read(); //set data rate
L_main20:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,106 :: 		set_data_rate(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_set_data_rate_rate+0
	CALL       _set_data_rate+0
;nrf_pc.c,107 :: 		break;
	GOTO       L_main9
;nrf_pc.c,108 :: 		case 'f':arg1=my_UART1_Read(); //set channel
L_main21:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,109 :: 		set_RF_CH(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_set_RF_CH_ch+0
	CALL       _set_RF_CH+0
;nrf_pc.c,110 :: 		break;
	GOTO       L_main9
;nrf_pc.c,111 :: 		case 'g':arg1=my_UART1_Read();
L_main22:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,112 :: 		CRC_config(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_CRC_config_crc+0
	CALL       _CRC_config+0
;nrf_pc.c,113 :: 		break;
	GOTO       L_main9
;nrf_pc.c,114 :: 		case 'h':arg1=my_UART1_Read();
L_main23:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,115 :: 		enable_dynamic_payload(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_enable_dynamic_payload_pipe+0
	CALL       _enable_dynamic_payload+0
;nrf_pc.c,116 :: 		break;
	GOTO       L_main9
;nrf_pc.c,117 :: 		case 'i':arg1=my_UART1_Read();
L_main24:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,118 :: 		set_address_width(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_set_address_width_width+0
	CALL       _set_address_width+0
;nrf_pc.c,119 :: 		break;
	GOTO       L_main9
;nrf_pc.c,120 :: 		case 'j':arg1=my_UART1_Read();
L_main25:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,121 :: 		arg2=my_UART1_Read();
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg2_L0+0
;nrf_pc.c,122 :: 		my_UART1_Read_buffer(buffer,arg2);
	MOVLW      main_buffer_L0+0
	MOVWF      FARG_my_UART1_Read_buffer_buffer+0
	MOVF       R0+0, 0
	MOVWF      FARG_my_UART1_Read_buffer_dat_width+0
	CALL       _my_UART1_Read_buffer+0
;nrf_pc.c,123 :: 		set_pipe_address(arg1,arg2,buffer);
	MOVF       main_arg1_L0+0, 0
	MOVWF      FARG_set_pipe_address_pipe+0
	MOVF       main_arg2_L0+0, 0
	MOVWF      FARG_set_pipe_address_width+0
	MOVLW      main_buffer_L0+0
	MOVWF      FARG_set_pipe_address_address+0
	CALL       _set_pipe_address+0
;nrf_pc.c,124 :: 		break;
	GOTO       L_main9
;nrf_pc.c,125 :: 		case 'k':RX_mode();
L_main26:
	CALL       _RX_mode+0
;nrf_pc.c,126 :: 		break;
	GOTO       L_main9
;nrf_pc.c,127 :: 		case 'l':arg1=my_UART1_Read();
L_main27:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,128 :: 		RX_LNA_gain(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_RX_LNA_gain_gain+0
	CALL       _RX_LNA_gain+0
;nrf_pc.c,129 :: 		break;
	GOTO       L_main9
;nrf_pc.c,130 :: 		case 'm':arg1=my_UART1_Read();
L_main28:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,131 :: 		arg2=my_UART1_Read();
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg2_L0+0
;nrf_pc.c,132 :: 		my_UART1_Read_buffer(buffer,arg2);
	MOVLW      main_buffer_L0+0
	MOVWF      FARG_my_UART1_Read_buffer_buffer+0
	MOVF       R0+0, 0
	MOVWF      FARG_my_UART1_Read_buffer_dat_width+0
	CALL       _my_UART1_Read_buffer+0
;nrf_pc.c,133 :: 		RX_ack_with_payload(arg1,arg2,buffer);
	MOVF       main_arg1_L0+0, 0
	MOVWF      FARG_RX_ack_with_payload_pipe+0
	MOVF       main_arg2_L0+0, 0
	MOVWF      FARG_RX_ack_with_payload_dat_width+0
	MOVLW      main_buffer_L0+0
	MOVWF      FARG_RX_ack_with_payload_dat+0
	CALL       _RX_ack_with_payload+0
;nrf_pc.c,134 :: 		break;
	GOTO       L_main9
;nrf_pc.c,135 :: 		case 'n':arg1=my_UART1_Read();
L_main29:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,136 :: 		arg2=my_UART1_Read();
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg2_L0+0
;nrf_pc.c,137 :: 		RX_set_static_payload(arg1,arg2);
	MOVF       main_arg1_L0+0, 0
	MOVWF      FARG_RX_set_static_payload_reg+0
	MOVF       R0+0, 0
	MOVWF      FARG_RX_set_static_payload_length+0
	CALL       _RX_set_static_payload+0
;nrf_pc.c,138 :: 		break;
	GOTO       L_main9
;nrf_pc.c,139 :: 		case 'o':TX_mode();
L_main30:
	CALL       _TX_mode+0
;nrf_pc.c,140 :: 		break;
	GOTO       L_main9
;nrf_pc.c,141 :: 		case 'p':arg1=my_UART1_Read();
L_main31:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,142 :: 		my_UART1_Read_buffer(buffer,arg1);
	MOVLW      main_buffer_L0+0
	MOVWF      FARG_my_UART1_Read_buffer_buffer+0
	MOVF       R0+0, 0
	MOVWF      FARG_my_UART1_Read_buffer_dat_width+0
	CALL       _my_UART1_Read_buffer+0
;nrf_pc.c,143 :: 		TX_write_buffer(arg1,buffer);
	MOVF       main_arg1_L0+0, 0
	MOVWF      FARG_TX_write_buffer_dat_width+0
	MOVLW      main_buffer_L0+0
	MOVWF      FARG_TX_write_buffer_dat+0
	CALL       _TX_write_buffer+0
;nrf_pc.c,144 :: 		break;
	GOTO       L_main9
;nrf_pc.c,145 :: 		case 'q':arg1=my_UART1_Read();
L_main32:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,146 :: 		arg2=my_UART1_Read();
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg2_L0+0
;nrf_pc.c,147 :: 		TX_auto_retransmit(arg1,arg2);
	MOVF       main_arg1_L0+0, 0
	MOVWF      FARG_TX_auto_retransmit_delay+0
	MOVF       R0+0, 0
	MOVWF      FARG_TX_auto_retransmit_count+0
	CALL       _TX_auto_retransmit+0
;nrf_pc.c,148 :: 		break;
	GOTO       L_main9
;nrf_pc.c,149 :: 		case 'r':arg1=my_UART1_Read();
L_main33:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,150 :: 		TX_disable_auto_ack(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_TX_disable_auto_ack_pipe+0
	CALL       _TX_disable_auto_ack+0
;nrf_pc.c,151 :: 		break;
	GOTO       L_main9
;nrf_pc.c,152 :: 		case 's':arg1=my_UART1_Read();
L_main34:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,153 :: 		TX_enable_auto_ack(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_TX_enable_auto_ack_pipe+0
	CALL       _TX_enable_auto_ack+0
;nrf_pc.c,154 :: 		break;
	GOTO       L_main9
;nrf_pc.c,155 :: 		case 't':arg1=my_UART1_Read();
L_main35:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,156 :: 		my_UART1_Read_buffer(buffer,arg1);
	MOVLW      main_buffer_L0+0
	MOVWF      FARG_my_UART1_Read_buffer_buffer+0
	MOVF       R0+0, 0
	MOVWF      FARG_my_UART1_Read_buffer_dat_width+0
	CALL       _my_UART1_Read_buffer+0
;nrf_pc.c,157 :: 		TX_set_address(arg1,buffer);
	MOVF       main_arg1_L0+0, 0
	MOVWF      FARG_TX_set_address_addr_width+0
	MOVLW      main_buffer_L0+0
	MOVWF      FARG_TX_set_address_addr+0
	CALL       _TX_set_address+0
;nrf_pc.c,158 :: 		break;
	GOTO       L_main9
;nrf_pc.c,159 :: 		case 'u':arg1=my_UART1_Read();
L_main36:
	CALL       _my_UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_arg1_L0+0
;nrf_pc.c,160 :: 		TX_output_power_control(arg1);
	MOVF       R0+0, 0
	MOVWF      FARG_TX_output_power_control_pwr+0
	CALL       _TX_output_power_control+0
;nrf_pc.c,161 :: 		break;
	GOTO       L_main9
;nrf_pc.c,162 :: 		case 'v':rx_start_simple();
L_main37:
	CALL       _rx_start_simple+0
;nrf_pc.c,163 :: 		break;
	GOTO       L_main9
;nrf_pc.c,164 :: 		case 'w':tx_start_simple();
L_main38:
	CALL       _tx_start_simple+0
;nrf_pc.c,165 :: 		break;
	GOTO       L_main9
;nrf_pc.c,166 :: 		}
L_main8:
	MOVF       main_command_L0+0, 0
	XORLW      49
	BTFSC      STATUS+0, 2
	GOTO       L_main10
	MOVF       main_command_L0+0, 0
	XORLW      50
	BTFSC      STATUS+0, 2
	GOTO       L_main11
	MOVF       main_command_L0+0, 0
	XORLW      51
	BTFSC      STATUS+0, 2
	GOTO       L_main12
	MOVF       main_command_L0+0, 0
	XORLW      52
	BTFSC      STATUS+0, 2
	GOTO       L_main13
	MOVF       main_command_L0+0, 0
	XORLW      53
	BTFSC      STATUS+0, 2
	GOTO       L_main14
	MOVF       main_command_L0+0, 0
	XORLW      54
	BTFSC      STATUS+0, 2
	GOTO       L_main15
	MOVF       main_command_L0+0, 0
	XORLW      97
	BTFSC      STATUS+0, 2
	GOTO       L_main16
	MOVF       main_command_L0+0, 0
	XORLW      98
	BTFSC      STATUS+0, 2
	GOTO       L_main17
	MOVF       main_command_L0+0, 0
	XORLW      99
	BTFSC      STATUS+0, 2
	GOTO       L_main18
	MOVF       main_command_L0+0, 0
	XORLW      100
	BTFSC      STATUS+0, 2
	GOTO       L_main19
	MOVF       main_command_L0+0, 0
	XORLW      101
	BTFSC      STATUS+0, 2
	GOTO       L_main20
	MOVF       main_command_L0+0, 0
	XORLW      102
	BTFSC      STATUS+0, 2
	GOTO       L_main21
	MOVF       main_command_L0+0, 0
	XORLW      103
	BTFSC      STATUS+0, 2
	GOTO       L_main22
	MOVF       main_command_L0+0, 0
	XORLW      104
	BTFSC      STATUS+0, 2
	GOTO       L_main23
	MOVF       main_command_L0+0, 0
	XORLW      105
	BTFSC      STATUS+0, 2
	GOTO       L_main24
	MOVF       main_command_L0+0, 0
	XORLW      106
	BTFSC      STATUS+0, 2
	GOTO       L_main25
	MOVF       main_command_L0+0, 0
	XORLW      107
	BTFSC      STATUS+0, 2
	GOTO       L_main26
	MOVF       main_command_L0+0, 0
	XORLW      108
	BTFSC      STATUS+0, 2
	GOTO       L_main27
	MOVF       main_command_L0+0, 0
	XORLW      109
	BTFSC      STATUS+0, 2
	GOTO       L_main28
	MOVF       main_command_L0+0, 0
	XORLW      110
	BTFSC      STATUS+0, 2
	GOTO       L_main29
	MOVF       main_command_L0+0, 0
	XORLW      111
	BTFSC      STATUS+0, 2
	GOTO       L_main30
	MOVF       main_command_L0+0, 0
	XORLW      112
	BTFSC      STATUS+0, 2
	GOTO       L_main31
	MOVF       main_command_L0+0, 0
	XORLW      113
	BTFSC      STATUS+0, 2
	GOTO       L_main32
	MOVF       main_command_L0+0, 0
	XORLW      114
	BTFSC      STATUS+0, 2
	GOTO       L_main33
	MOVF       main_command_L0+0, 0
	XORLW      115
	BTFSC      STATUS+0, 2
	GOTO       L_main34
	MOVF       main_command_L0+0, 0
	XORLW      116
	BTFSC      STATUS+0, 2
	GOTO       L_main35
	MOVF       main_command_L0+0, 0
	XORLW      117
	BTFSC      STATUS+0, 2
	GOTO       L_main36
	MOVF       main_command_L0+0, 0
	XORLW      118
	BTFSC      STATUS+0, 2
	GOTO       L_main37
	MOVF       main_command_L0+0, 0
	XORLW      119
	BTFSC      STATUS+0, 2
	GOTO       L_main38
L_main9:
;nrf_pc.c,167 :: 		UART1_Write(command);
	MOVF       main_command_L0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;nrf_pc.c,168 :: 		command=0;
	CLRF       main_command_L0+0
;nrf_pc.c,169 :: 		}
	GOTO       L_main6
;nrf_pc.c,170 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
