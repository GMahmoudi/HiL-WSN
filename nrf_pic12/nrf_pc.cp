#line 1 "D:/grad_project/uC_proteus_py/nrf_pc_controlled_p16/nrf_pc.c"
#line 1 "d:/grad_project/uc_proteus_py/nrf_pc_controlled_p16/nrf24l01_lib.h"
void get_MODE();
void init_spi();
void toggle();
void toggle_CSN();
unsigned char get_STATUS();
unsigned char NRF_RW(unsigned char command,unsigned char dat);
unsigned char merge(unsigned char target,unsigned char value,unsigned char shift,unsigned char mask);
void power_mode(unsigned char down);
void RX_mode();
void TX_mode();
void set_data_rate(unsigned char rate);
void set_RF_CH(unsigned char ch);
void TX_output_power_control(unsigned char pwr);
void RX_LNA_gain(unsigned char gain);
void RX_set_static_payload(char reg,char length);
void enable_dynamic_payload(char pipe);
void set_address_width(unsigned char width);
void TX_set_address(unsigned char addr_width,unsigned char * addr);
void TX_enable_auto_ack(unsigned char pipe);
void TX_disable_auto_ack(unsigned char pipe);
void CRC_config(char crc);
void TX_auto_retransmit(unsigned char delay, unsigned char count);
void RX_ack_with_payload(unsigned char pipe,unsigned char dat_width,unsigned char * dat);
void TX_write_buffer(unsigned char dat_width,unsigned char *dat );
void set_pipe_address(unsigned char pipe,unsigned char width,unsigned char *address);
#line 1 "d:/grad_project/uc_proteus_py/nrf_pc_controlled_p16/nrf24l01.h"
#line 4 "D:/grad_project/uC_proteus_py/nrf_pc_controlled_p16/nrf_pc.c"
sbit CSN_PIN at RE2_bit;
sbit MOSI_PIN at RC5_bit;
sbit MISO_PIN at RC4_bit;
sbit CE_PIN at RC2_bit;
sbit SCLK_PIN at RC3_bit;

sbit CSN_Dir at TRISE2_bit;
sbit MOSI_Dir at TRISC5_bit;
sbit MISO_Dir at TRISC4_bit;
sbit CE_Dir at TRISC2_bit;
sbit SCLK_Dir at TRISC3_bit;


unsigned char my_UART1_Read(){
 unsigned char res;
 while (!UART1_Data_Ready()){}
 res=UART1_Read();
 return res;
}
void my_UART1_Read_buffer(unsigned char * buffer,unsigned char dat_width){
 unsigned char i;
 for (i=0;i<dat_width;i++){
 buffer[i]=my_UART1_Read();
 }
}


void rx_start_simple(){

 init_SPI();


 RX_set_static_payload( 0x11 ,1);
 RX_mode();
 power_mode(1);
 CE_PIN=1;
}
void tx_start_simple(){
 unsigned char dat[1]={0xA5};

 init_SPI();




 TX_mode();
 power_mode(1);
 CE_PIN=1;
 TX_write_buffer(dat,1);
}


void main() {
 unsigned char command,res,arg1,arg2;
 unsigned char * buffer[5]={0};

 ADCON1 = 0x04;
 CMCON = 7;

 TRISD.RD3=0;
 PORTD.RD3=1;

 UART1_init(128000);
 delay_ms(100);
 UART1_Write(0xBC);
 UART1_Write(0xCB);

 while(1){
 command=my_UART1_Read();
 switch (command){

 case '1':arg1=my_UART1_Read();
 SPI1_Write(arg1);
 break;
 case '2':arg1=my_UART1_Read();
 res=SPI1_Read(arg1);
 UART1_Write(res);
 break;
 case '3':CE_PIN=0;
 break;
 case '4':CE_PIN=1;
 break;
 case '5':toggle();
 break;
 case '6':toggle_CSN();
 break;

 case 'a':init_spi();
 break;
 case 'b':res=get_STATUS();
 UART1_Write(res);
 break;
 case 'c':arg1=my_UART1_Read();
 arg2=my_UART1_Read();
 res=NRF_RW(arg1,arg2);
 CE_PIN=1;
 UART1_Write(res);
 break;
 case 'd':arg1=my_UART1_Read();
 power_mode(arg1);
 break;
 case 'e':arg1=my_UART1_Read();
 set_data_rate(arg1);
 break;
 case 'f':arg1=my_UART1_Read();
 set_RF_CH(arg1);
 break;
 case 'g':arg1=my_UART1_Read();
 CRC_config(arg1);
 break;
 case 'h':arg1=my_UART1_Read();
 enable_dynamic_payload(arg1);
 break;
 case 'i':arg1=my_UART1_Read();
 set_address_width(arg1);
 break;
 case 'j':arg1=my_UART1_Read();
 arg2=my_UART1_Read();
 my_UART1_Read_buffer(buffer,arg2);
 set_pipe_address(arg1,arg2,buffer);
 break;
 case 'k':RX_mode();
 break;
 case 'l':arg1=my_UART1_Read();
 RX_LNA_gain(arg1);
 break;
 case 'm':arg1=my_UART1_Read();
 arg2=my_UART1_Read();
 my_UART1_Read_buffer(buffer,arg2);
 RX_ack_with_payload(arg1,arg2,buffer);
 break;
 case 'n':arg1=my_UART1_Read();
 arg2=my_UART1_Read();
 RX_set_static_payload(arg1,arg2);
 break;
 case 'o':TX_mode();
 break;
 case 'p':arg1=my_UART1_Read();
 my_UART1_Read_buffer(buffer,arg1);
 TX_write_buffer(arg1,buffer);
 break;
 case 'q':arg1=my_UART1_Read();
 arg2=my_UART1_Read();
 TX_auto_retransmit(arg1,arg2);
 break;
 case 'r':arg1=my_UART1_Read();
 TX_disable_auto_ack(arg1);
 break;
 case 's':arg1=my_UART1_Read();
 TX_enable_auto_ack(arg1);
 break;
 case 't':arg1=my_UART1_Read();
 my_UART1_Read_buffer(buffer,arg1);
 TX_set_address(arg1,buffer);
 break;
 case 'u':arg1=my_UART1_Read();
 TX_output_power_control(arg1);
 break;
 case 'v':rx_start_simple();
 break;
 case 'w':tx_start_simple();
 break;
 }
 UART1_Write(command);
 command=0;
 }
}
