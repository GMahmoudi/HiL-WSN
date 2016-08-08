
_get_MODE:

;nRF24L01_lib.c,21 :: 		unsigned char get_MODE(){
;nRF24L01_lib.c,22 :: 		return MODE;
	MOVF       _MODE+0, 0
	MOVWF      R0+0
;nRF24L01_lib.c,23 :: 		}
L_end_get_MODE:
	RETURN
; end of _get_MODE

_init_spi:

;nRF24L01_lib.c,26 :: 		void init_spi(){
;nRF24L01_lib.c,28 :: 		MISO_Dir=1;
	BSF        TRISC4_bit+0, BitPos(TRISC4_bit+0)
;nRF24L01_lib.c,29 :: 		MOSI_Dir=0;
	BCF        TRISC5_bit+0, BitPos(TRISC5_bit+0)
;nRF24L01_lib.c,30 :: 		CSN_Dir=0;
	BCF        TRISE2_bit+0, BitPos(TRISE2_bit+0)
;nRF24L01_lib.c,31 :: 		CE_Dir=0;
	BCF        TRISC2_bit+0, BitPos(TRISC2_bit+0)
;nRF24L01_lib.c,32 :: 		SCLK_Dir=0;
	BCF        TRISC3_bit+0, BitPos(TRISC3_bit+0)
;nRF24L01_lib.c,33 :: 		SPI1_Init();
	CALL       _SPI1_Init+0
;nRF24L01_lib.c,35 :: 		}
L_end_init_spi:
	RETURN
; end of _init_spi

_toggle:

;nRF24L01_lib.c,37 :: 		void toggle(){
;nRF24L01_lib.c,38 :: 		CE_PIN=0;         //standbyI mode
	BCF        RC2_bit+0, BitPos(RC2_bit+0)
;nRF24L01_lib.c,39 :: 		delay_us(GLOBAL_DELAY*50);
	MOVLW      34
	MOVWF      R12+0
	MOVLW      28
	MOVWF      R13+0
L_toggle0:
	DECFSZ     R13+0, 1
	GOTO       L_toggle0
	DECFSZ     R12+0, 1
	GOTO       L_toggle0
	NOP
;nRF24L01_lib.c,40 :: 		CSN_PIN=1;
	BSF        RE2_bit+0, BitPos(RE2_bit+0)
;nRF24L01_lib.c,41 :: 		Delay_us(GLOBAL_DELAY*50);
	MOVLW      34
	MOVWF      R12+0
	MOVLW      28
	MOVWF      R13+0
L_toggle1:
	DECFSZ     R13+0, 1
	GOTO       L_toggle1
	DECFSZ     R12+0, 1
	GOTO       L_toggle1
	NOP
;nRF24L01_lib.c,42 :: 		CSN_PIN=0;
	BCF        RE2_bit+0, BitPos(RE2_bit+0)
;nRF24L01_lib.c,43 :: 		}
L_end_toggle:
	RETURN
; end of _toggle

_toggle_CSN:

;nRF24L01_lib.c,45 :: 		void toggle_CSN(){
;nRF24L01_lib.c,46 :: 		delay_us(GLOBAL_DELAY*50);
	MOVLW      34
	MOVWF      R12+0
	MOVLW      28
	MOVWF      R13+0
L_toggle_CSN2:
	DECFSZ     R13+0, 1
	GOTO       L_toggle_CSN2
	DECFSZ     R12+0, 1
	GOTO       L_toggle_CSN2
	NOP
;nRF24L01_lib.c,47 :: 		CSN_PIN=1;
	BSF        RE2_bit+0, BitPos(RE2_bit+0)
;nRF24L01_lib.c,48 :: 		Delay_us(GLOBAL_DELAY*50);
	MOVLW      34
	MOVWF      R12+0
	MOVLW      28
	MOVWF      R13+0
L_toggle_CSN3:
	DECFSZ     R13+0, 1
	GOTO       L_toggle_CSN3
	DECFSZ     R12+0, 1
	GOTO       L_toggle_CSN3
	NOP
;nRF24L01_lib.c,49 :: 		CSN_PIN=0;
	BCF        RE2_bit+0, BitPos(RE2_bit+0)
;nRF24L01_lib.c,50 :: 		}
L_end_toggle_CSN:
	RETURN
; end of _toggle_CSN

_get_STATUS:

;nRF24L01_lib.c,52 :: 		unsigned char get_STATUS(){
;nRF24L01_lib.c,54 :: 		toggle_CSN();
	CALL       _toggle_CSN+0
;nRF24L01_lib.c,55 :: 		res=SPI1_Read(NOP);
	MOVLW      255
	MOVWF      FARG_SPI1_Read_buffer+0
	CALL       _SPI1_Read+0
;nRF24L01_lib.c,57 :: 		return res;
;nRF24L01_lib.c,58 :: 		}
L_end_get_STATUS:
	RETURN
; end of _get_STATUS

_NRF_RW:

;nRF24L01_lib.c,60 :: 		unsigned char NRF_RW(unsigned char command,unsigned char dat){
;nRF24L01_lib.c,62 :: 		toggle();
	CALL       _toggle+0
;nRF24L01_lib.c,63 :: 		SPI1_Write(command);
	MOVF       FARG_NRF_RW_command+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;nRF24L01_lib.c,64 :: 		delay_us(GLOBAL_DELAY*50);
	MOVLW      34
	MOVWF      R12+0
	MOVLW      28
	MOVWF      R13+0
L_NRF_RW4:
	DECFSZ     R13+0, 1
	GOTO       L_NRF_RW4
	DECFSZ     R12+0, 1
	GOTO       L_NRF_RW4
	NOP
;nRF24L01_lib.c,65 :: 		res=SPI1_Read(dat);
	MOVF       FARG_NRF_RW_dat+0, 0
	MOVWF      FARG_SPI1_Read_buffer+0
	CALL       _SPI1_Read+0
;nRF24L01_lib.c,66 :: 		return res;
;nRF24L01_lib.c,67 :: 		}
L_end_NRF_RW:
	RETURN
; end of _NRF_RW

_merge:

;nRF24L01_lib.c,69 :: 		unsigned char merge(unsigned char target,unsigned char value,unsigned char shift,unsigned char mask){
;nRF24L01_lib.c,70 :: 		target&=mask;
	MOVF       FARG_merge_mask+0, 0
	ANDWF      FARG_merge_target+0, 0
	MOVWF      R2+0
	MOVF       R2+0, 0
	MOVWF      FARG_merge_target+0
;nRF24L01_lib.c,71 :: 		value=value<<shift;
	MOVF       FARG_merge_shift+0, 0
	MOVWF      R1+0
	MOVF       FARG_merge_value+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
L__merge37:
	BTFSC      STATUS+0, 2
	GOTO       L__merge38
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__merge37
L__merge38:
	MOVF       R0+0, 0
	MOVWF      FARG_merge_value+0
;nRF24L01_lib.c,72 :: 		target|=value;
	MOVF       R2+0, 0
	IORWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      FARG_merge_target+0
;nRF24L01_lib.c,73 :: 		return target;
;nRF24L01_lib.c,74 :: 		}
L_end_merge:
	RETURN
; end of _merge

_power_mode:

;nRF24L01_lib.c,77 :: 		void power_mode(unsigned char down){
;nRF24L01_lib.c,79 :: 		res=NRF_RW(CONFIG | R_REGISTER,NOP);
	CLRF       FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
	MOVF       R0+0, 0
	MOVWF      power_mode_res_L0+0
;nRF24L01_lib.c,80 :: 		if (down==0){
	MOVF       FARG_power_mode_down+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_power_mode5
;nRF24L01_lib.c,81 :: 		NRF_RW(CONFIG | W_REGISTER,res & 0b11111101);
	MOVLW      32
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      253
	ANDWF      power_mode_res_L0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,82 :: 		MODE='D';
	MOVLW      68
	MOVWF      _MODE+0
;nRF24L01_lib.c,83 :: 		}
	GOTO       L_power_mode6
L_power_mode5:
;nRF24L01_lib.c,85 :: 		NRF_RW(CONFIG | W_REGISTER,res | 0b00000010);
	MOVLW      32
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      2
	IORWF      power_mode_res_L0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,86 :: 		MODE='U';
	MOVLW      85
	MOVWF      _MODE+0
;nRF24L01_lib.c,87 :: 		}
L_power_mode6:
;nRF24L01_lib.c,89 :: 		}
L_end_power_mode:
	RETURN
; end of _power_mode

_RX_mode:

;nRF24L01_lib.c,92 :: 		void RX_mode(){
;nRF24L01_lib.c,94 :: 		res=NRF_RW(CONFIG | R_REGISTER,NOP);
	CLRF       FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,95 :: 		NRF_RW(CONFIG | W_REGISTER,res | 0b00000011);
	MOVLW      32
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      3
	IORWF      R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,96 :: 		delay_us(150);
	MOVLW      99
	MOVWF      R13+0
L_RX_mode7:
	DECFSZ     R13+0, 1
	GOTO       L_RX_mode7
	NOP
	NOP
;nRF24L01_lib.c,98 :: 		MODE='R';
	MOVLW      82
	MOVWF      _MODE+0
;nRF24L01_lib.c,99 :: 		}
L_end_RX_mode:
	RETURN
; end of _RX_mode

_TX_mode:

;nRF24L01_lib.c,101 :: 		void TX_mode(){
;nRF24L01_lib.c,103 :: 		res=NRF_RW(CONFIG | R_REGISTER,NOP);
	CLRF       FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,104 :: 		NRF_RW(CONFIG | W_REGISTER,res & 0b11111110);
	MOVLW      32
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      254
	ANDWF      R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,105 :: 		delay_us(150);
	MOVLW      99
	MOVWF      R13+0
L_TX_mode8:
	DECFSZ     R13+0, 1
	GOTO       L_TX_mode8
	NOP
	NOP
;nRF24L01_lib.c,107 :: 		MODE='T';
	MOVLW      84
	MOVWF      _MODE+0
;nRF24L01_lib.c,108 :: 		}
L_end_TX_mode:
	RETURN
; end of _TX_mode

_set_data_rate:

;nRF24L01_lib.c,112 :: 		void set_data_rate(unsigned char rate){
;nRF24L01_lib.c,114 :: 		res=NRF_RW(RF_SETUP | R_REGISTER,NOP);
	MOVLW      6
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
	MOVF       R0+0, 0
	MOVWF      set_data_rate_res_L0+0
;nRF24L01_lib.c,115 :: 		if (rate==2){NRF_RW(RF_SETUP | W_REGISTER,res | 0b00001000);}        //rate=2Mbps
	MOVF       FARG_set_data_rate_rate+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_set_data_rate9
	MOVLW      38
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      8
	IORWF      set_data_rate_res_L0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
	GOTO       L_set_data_rate10
L_set_data_rate9:
;nRF24L01_lib.c,116 :: 		else {NRF_RW(RF_SETUP | W_REGISTER,res & 0b11110111);}        //rate=1Mbps
	MOVLW      38
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      247
	ANDWF      set_data_rate_res_L0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
L_set_data_rate10:
;nRF24L01_lib.c,118 :: 		}
L_end_set_data_rate:
	RETURN
; end of _set_data_rate

_set_RF_CH:

;nRF24L01_lib.c,122 :: 		void set_RF_CH(unsigned char ch){
;nRF24L01_lib.c,123 :: 		if (ch<126){
	MOVLW      126
	SUBWF      FARG_set_RF_CH_ch+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_set_RF_CH11
;nRF24L01_lib.c,124 :: 		NRF_RW(RF_CH | W_REGISTER,ch);
	MOVLW      37
	MOVWF      FARG_NRF_RW_command+0
	MOVF       FARG_set_RF_CH_ch+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,126 :: 		}
L_set_RF_CH11:
;nRF24L01_lib.c,127 :: 		}
L_end_set_RF_CH:
	RETURN
; end of _set_RF_CH

_TX_output_power_control:

;nRF24L01_lib.c,131 :: 		void TX_output_power_control(unsigned char pwr){
;nRF24L01_lib.c,133 :: 		if (pwr<4){
	MOVLW      4
	SUBWF      FARG_TX_output_power_control_pwr+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_TX_output_power_control12
;nRF24L01_lib.c,134 :: 		res=NRF_RW(RF_SETUP | R_REGISTER,NOP);
	MOVLW      6
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,135 :: 		res=merge(res,pwr,1,0xF9);
	MOVF       R0+0, 0
	MOVWF      FARG_merge_target+0
	MOVF       FARG_TX_output_power_control_pwr+0, 0
	MOVWF      FARG_merge_value+0
	MOVLW      1
	MOVWF      FARG_merge_shift+0
	MOVLW      249
	MOVWF      FARG_merge_mask+0
	CALL       _merge+0
;nRF24L01_lib.c,136 :: 		NRF_RW(RF_SETUP | W_REGISTER,res);
	MOVLW      38
	MOVWF      FARG_NRF_RW_command+0
	MOVF       R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,138 :: 		}
L_TX_output_power_control12:
;nRF24L01_lib.c,139 :: 		}
L_end_TX_output_power_control:
	RETURN
; end of _TX_output_power_control

_RX_LNA_gain:

;nRF24L01_lib.c,143 :: 		void RX_LNA_gain(unsigned char gain){
;nRF24L01_lib.c,145 :: 		res=NRF_RW(RF_SETUP | R_REGISTER,NOP);
	MOVLW      6
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,146 :: 		res=merge(res,gain,0,0xFE);
	MOVF       R0+0, 0
	MOVWF      FARG_merge_target+0
	MOVF       FARG_RX_LNA_gain_gain+0, 0
	MOVWF      FARG_merge_value+0
	CLRF       FARG_merge_shift+0
	MOVLW      254
	MOVWF      FARG_merge_mask+0
	CALL       _merge+0
;nRF24L01_lib.c,147 :: 		NRF_RW(RF_SETUP | W_REGISTER,res);
	MOVLW      38
	MOVWF      FARG_NRF_RW_command+0
	MOVF       R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,149 :: 		}
L_end_RX_LNA_gain:
	RETURN
; end of _RX_LNA_gain

_RX_set_static_payload:

;nRF24L01_lib.c,154 :: 		void RX_set_static_payload(char reg,char length){
;nRF24L01_lib.c,155 :: 		NRF_RW(reg | W_REGISTER,length);
	MOVLW      32
	IORWF      FARG_RX_set_static_payload_reg+0, 0
	MOVWF      FARG_NRF_RW_command+0
	MOVF       FARG_RX_set_static_payload_length+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,157 :: 		}
L_end_RX_set_static_payload:
	RETURN
; end of _RX_set_static_payload

_enable_dynamic_payload:

;nRF24L01_lib.c,161 :: 		void enable_dynamic_payload(char pipe){
;nRF24L01_lib.c,163 :: 		res=NRF_RW(FEATURE | R_REGISTER,NOP);
	MOVLW      29
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,164 :: 		NRF_RW(FEATURE | W_REGISTER,res | 0b00000100);
	MOVLW      61
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      4
	IORWF      R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,165 :: 		if (MODE=='T'){pipe=0;}
	MOVF       _MODE+0, 0
	XORLW      84
	BTFSS      STATUS+0, 2
	GOTO       L_enable_dynamic_payload13
	CLRF       FARG_enable_dynamic_payload_pipe+0
L_enable_dynamic_payload13:
;nRF24L01_lib.c,166 :: 		res=NRF_RW(DYNPD | R_REGISTER,NOP);
	MOVLW      28
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,167 :: 		NRF_RW(DYNPD | W_REGISTER,res | 0x01<<pipe);
	MOVLW      60
	MOVWF      FARG_NRF_RW_command+0
	MOVF       FARG_enable_dynamic_payload_pipe+0, 0
	MOVWF      R2+0
	MOVLW      1
	MOVWF      R1+0
	MOVF       R2+0, 0
L__enable_dynamic_payload48:
	BTFSC      STATUS+0, 2
	GOTO       L__enable_dynamic_payload49
	RLF        R1+0, 1
	BCF        R1+0, 0
	ADDLW      255
	GOTO       L__enable_dynamic_payload48
L__enable_dynamic_payload49:
	MOVF       R1+0, 0
	IORWF      R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,169 :: 		}
L_end_enable_dynamic_payload:
	RETURN
; end of _enable_dynamic_payload

_set_address_width:

;nRF24L01_lib.c,171 :: 		void set_address_width(unsigned char width){
;nRF24L01_lib.c,172 :: 		NRF_RW(SETUP_AW | W_REGISTER,width-2);
	MOVLW      35
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      2
	SUBWF      FARG_set_address_width_width+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,174 :: 		}
L_end_set_address_width:
	RETURN
; end of _set_address_width

_TX_set_address:

;nRF24L01_lib.c,178 :: 		void TX_set_address(unsigned char addr_width,unsigned char * addr){
;nRF24L01_lib.c,180 :: 		NRF_RW(SETUP_AW | W_REGISTER,addr_width-2);
	MOVLW      35
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      2
	SUBWF      FARG_TX_set_address_addr_width+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,181 :: 		toggle();
	CALL       _toggle+0
;nRF24L01_lib.c,182 :: 		SPI1_Write(TX_ADDR | W_REGISTER);
	MOVLW      48
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;nRF24L01_lib.c,183 :: 		for ( i = 0 ; i < addr_width ; i++ ){
	CLRF       TX_set_address_i_L0+0
L_TX_set_address14:
	MOVF       FARG_TX_set_address_addr_width+0, 0
	SUBWF      TX_set_address_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_TX_set_address15
;nRF24L01_lib.c,184 :: 		SPI1_Write(*addr);
	MOVF       FARG_TX_set_address_addr+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;nRF24L01_lib.c,185 :: 		addr++;
	INCF       FARG_TX_set_address_addr+0, 1
;nRF24L01_lib.c,183 :: 		for ( i = 0 ; i < addr_width ; i++ ){
	INCF       TX_set_address_i_L0+0, 1
;nRF24L01_lib.c,186 :: 		}
	GOTO       L_TX_set_address14
L_TX_set_address15:
;nRF24L01_lib.c,189 :: 		}
L_end_TX_set_address:
	RETURN
; end of _TX_set_address

_TX_enable_auto_ack:

;nRF24L01_lib.c,193 :: 		void TX_enable_auto_ack(unsigned char pipe){
;nRF24L01_lib.c,195 :: 		res=NRF_RW(EN_AA | R_REGISTER,NOP);
	MOVLW      1
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,196 :: 		NRF_RW( EN_AA | W_REGISTER,res | 0x01<<pipe);
	MOVLW      33
	MOVWF      FARG_NRF_RW_command+0
	MOVF       FARG_TX_enable_auto_ack_pipe+0, 0
	MOVWF      R2+0
	MOVLW      1
	MOVWF      R1+0
	MOVF       R2+0, 0
L__TX_enable_auto_ack53:
	BTFSC      STATUS+0, 2
	GOTO       L__TX_enable_auto_ack54
	RLF        R1+0, 1
	BCF        R1+0, 0
	ADDLW      255
	GOTO       L__TX_enable_auto_ack53
L__TX_enable_auto_ack54:
	MOVF       R1+0, 0
	IORWF      R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,198 :: 		}
L_end_TX_enable_auto_ack:
	RETURN
; end of _TX_enable_auto_ack

_TX_disable_auto_ack:

;nRF24L01_lib.c,199 :: 		void TX_disable_auto_ack(unsigned char pipe){
;nRF24L01_lib.c,201 :: 		res=NRF_RW(EN_AA | R_REGISTER,NOP);
	MOVLW      1
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,202 :: 		NRF_RW(EN_AA | W_REGISTER, res & ~(0x01<<pipe));
	MOVLW      33
	MOVWF      FARG_NRF_RW_command+0
	MOVF       FARG_TX_disable_auto_ack_pipe+0, 0
	MOVWF      R2+0
	MOVLW      1
	MOVWF      R1+0
	MOVF       R2+0, 0
L__TX_disable_auto_ack56:
	BTFSC      STATUS+0, 2
	GOTO       L__TX_disable_auto_ack57
	RLF        R1+0, 1
	BCF        R1+0, 0
	ADDLW      255
	GOTO       L__TX_disable_auto_ack56
L__TX_disable_auto_ack57:
	COMF       R1+0, 1
	MOVF       R1+0, 0
	ANDWF      R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,204 :: 		}
L_end_TX_disable_auto_ack:
	RETURN
; end of _TX_disable_auto_ack

_CRC_config:

;nRF24L01_lib.c,207 :: 		void CRC_config(char crc){
;nRF24L01_lib.c,209 :: 		res=NRF_RW(CONFIG | R_REGISTER,NOP);
	CLRF       FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
	MOVF       R0+0, 0
	MOVWF      CRC_config_res_L0+0
;nRF24L01_lib.c,210 :: 		if (crc==1){NRF_RW(CONFIG | W_REGISTER,res & 0b11111011);}
	MOVF       FARG_CRC_config_crc+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_CRC_config17
	MOVLW      32
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      251
	ANDWF      CRC_config_res_L0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
	GOTO       L_CRC_config18
L_CRC_config17:
;nRF24L01_lib.c,211 :: 		else {NRF_RW(CONFIG | W_REGISTER,res | 0b00000100);}
	MOVLW      32
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      4
	IORWF      CRC_config_res_L0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
L_CRC_config18:
;nRF24L01_lib.c,213 :: 		}
L_end_CRC_config:
	RETURN
; end of _CRC_config

_TX_auto_retransmit:

;nRF24L01_lib.c,219 :: 		void TX_auto_retransmit(unsigned char delay, unsigned char count){
;nRF24L01_lib.c,220 :: 		delay = delay<<4;
	MOVF       FARG_TX_auto_retransmit_delay+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	MOVWF      FARG_TX_auto_retransmit_delay+0
;nRF24L01_lib.c,221 :: 		NRF_RW(SETUP_RETR | W_REGISTER, delay | count );
	MOVLW      36
	MOVWF      FARG_NRF_RW_command+0
	MOVF       FARG_TX_auto_retransmit_count+0, 0
	IORWF      R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,223 :: 		}
L_end_TX_auto_retransmit:
	RETURN
; end of _TX_auto_retransmit

_RX_ack_with_payload:

;nRF24L01_lib.c,229 :: 		void RX_ack_with_payload(unsigned char pipe,unsigned char dat_width,unsigned char * dat){
;nRF24L01_lib.c,231 :: 		enable_dynamic_payload(pipe);
	MOVF       FARG_RX_ack_with_payload_pipe+0, 0
	MOVWF      FARG_enable_dynamic_payload_pipe+0
	CALL       _enable_dynamic_payload+0
;nRF24L01_lib.c,232 :: 		res=NRF_RW(FEATURE | R_REGISTER,NOP);
	MOVLW      29
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      255
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,233 :: 		NRF_RW(FEATURE | W_REGISTER,res | 0b00000010);
	MOVLW      61
	MOVWF      FARG_NRF_RW_command+0
	MOVLW      2
	IORWF      R0+0, 0
	MOVWF      FARG_NRF_RW_dat+0
	CALL       _NRF_RW+0
;nRF24L01_lib.c,234 :: 		toggle();
	CALL       _toggle+0
;nRF24L01_lib.c,235 :: 		SPI1_Write(W_ACK_PAYLOAD | pipe);
	MOVLW      168
	IORWF      FARG_RX_ack_with_payload_pipe+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;nRF24L01_lib.c,236 :: 		for ( i = 0 ; i < dat_width ; i++ ){
	CLRF       RX_ack_with_payload_i_L0+0
L_RX_ack_with_payload19:
	MOVF       FARG_RX_ack_with_payload_dat_width+0, 0
	SUBWF      RX_ack_with_payload_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_RX_ack_with_payload20
;nRF24L01_lib.c,237 :: 		SPI1_Write(*dat);
	MOVF       FARG_RX_ack_with_payload_dat+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;nRF24L01_lib.c,238 :: 		dat++;
	INCF       FARG_RX_ack_with_payload_dat+0, 1
;nRF24L01_lib.c,236 :: 		for ( i = 0 ; i < dat_width ; i++ ){
	INCF       RX_ack_with_payload_i_L0+0, 1
;nRF24L01_lib.c,239 :: 		}
	GOTO       L_RX_ack_with_payload19
L_RX_ack_with_payload20:
;nRF24L01_lib.c,241 :: 		}
L_end_RX_ack_with_payload:
	RETURN
; end of _RX_ack_with_payload

_TX_write_buffer:

;nRF24L01_lib.c,242 :: 		void TX_write_buffer(unsigned char dat_width,unsigned char *dat ){
;nRF24L01_lib.c,244 :: 		toggle();
	CALL       _toggle+0
;nRF24L01_lib.c,245 :: 		SPI1_Write(W_TX_PAYLOAD);
	MOVLW      160
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;nRF24L01_lib.c,246 :: 		for ( i = 0 ; i < dat_width ; i++ ){
	CLRF       TX_write_buffer_i_L0+0
L_TX_write_buffer22:
	MOVF       FARG_TX_write_buffer_dat_width+0, 0
	SUBWF      TX_write_buffer_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_TX_write_buffer23
;nRF24L01_lib.c,247 :: 		SPI1_Write(*dat);
	MOVF       FARG_TX_write_buffer_dat+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;nRF24L01_lib.c,248 :: 		dat++;
	INCF       FARG_TX_write_buffer_dat+0, 1
;nRF24L01_lib.c,246 :: 		for ( i = 0 ; i < dat_width ; i++ ){
	INCF       TX_write_buffer_i_L0+0, 1
;nRF24L01_lib.c,249 :: 		}
	GOTO       L_TX_write_buffer22
L_TX_write_buffer23:
;nRF24L01_lib.c,250 :: 		CE_PIN=1;
	BSF        RC2_bit+0, BitPos(RC2_bit+0)
;nRF24L01_lib.c,251 :: 		}
L_end_TX_write_buffer:
	RETURN
; end of _TX_write_buffer

_set_pipe_address:

;nRF24L01_lib.c,253 :: 		void set_pipe_address(unsigned char pipe,unsigned char width,unsigned char *address){
;nRF24L01_lib.c,255 :: 		toggle();
	CALL       _toggle+0
;nRF24L01_lib.c,256 :: 		SPI1_Write(W_REGISTER | pipe);
	MOVLW      32
	IORWF      FARG_set_pipe_address_pipe+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;nRF24L01_lib.c,257 :: 		delay_us(GLOBAL_DELAY*50);
	MOVLW      34
	MOVWF      R12+0
	MOVLW      28
	MOVWF      R13+0
L_set_pipe_address25:
	DECFSZ     R13+0, 1
	GOTO       L_set_pipe_address25
	DECFSZ     R12+0, 1
	GOTO       L_set_pipe_address25
	NOP
;nRF24L01_lib.c,258 :: 		for (i=0;i<width;i++){SPI1_Write(*address);address++;delay_us(GLOBAL_DELAY*50);}
	CLRF       set_pipe_address_i_L0+0
L_set_pipe_address26:
	MOVF       FARG_set_pipe_address_width+0, 0
	SUBWF      set_pipe_address_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_set_pipe_address27
	MOVF       FARG_set_pipe_address_address+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
	INCF       FARG_set_pipe_address_address+0, 1
	MOVLW      34
	MOVWF      R12+0
	MOVLW      28
	MOVWF      R13+0
L_set_pipe_address29:
	DECFSZ     R13+0, 1
	GOTO       L_set_pipe_address29
	DECFSZ     R12+0, 1
	GOTO       L_set_pipe_address29
	NOP
	INCF       set_pipe_address_i_L0+0, 1
	GOTO       L_set_pipe_address26
L_set_pipe_address27:
;nRF24L01_lib.c,260 :: 		}
L_end_set_pipe_address:
	RETURN
; end of _set_pipe_address
