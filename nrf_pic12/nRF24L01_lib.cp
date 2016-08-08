#line 1 "D:/grad_project/uC_proteus_py/nrf_pc_controlled_p16/nRF24L01_lib.c"
#line 1 "d:/grad_project/uc_proteus_py/nrf_pc_controlled_p16/nrf24l01.h"
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
#line 4 "D:/grad_project/uC_proteus_py/nrf_pc_controlled_p16/nRF24L01_lib.c"
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

unsigned char MODE='D';

const unsigned char GLOBAL_DELAY=255;


unsigned char get_MODE(){
 return MODE;
}


void init_spi(){

 MISO_Dir=1;
 MOSI_Dir=0;
 CSN_Dir=0;
 CE_Dir=0;
 SCLK_Dir=0;
 SPI1_Init();

}

void toggle(){
 CE_PIN=0;
 delay_us(GLOBAL_DELAY*50);
 CSN_PIN=1;
 Delay_us(GLOBAL_DELAY*50);
 CSN_PIN=0;
}

void toggle_CSN(){
 delay_us(GLOBAL_DELAY*50);
 CSN_PIN=1;
 Delay_us(GLOBAL_DELAY*50);
 CSN_PIN=0;
}

unsigned char get_STATUS(){
 unsigned char res;
 toggle_CSN();
 res=SPI1_Read( 0xFF );

 return res;
}

unsigned char NRF_RW(unsigned char command,unsigned char dat){
 unsigned char res;
 toggle();
 SPI1_Write(command);
 delay_us(GLOBAL_DELAY*50);
 res=SPI1_Read(dat);
 return res;
}

unsigned char merge(unsigned char target,unsigned char value,unsigned char shift,unsigned char mask){
 target&=mask;
 value=value<<shift;
 target|=value;
 return target;
}


void power_mode(unsigned char down){
 unsigned char res;
 res=NRF_RW( 0x00  |  0x00 , 0xFF );
 if (down==0){
 NRF_RW( 0x00  |  0x20 ,res & 0b11111101);
 MODE='D';
 }
 else{
 NRF_RW( 0x00  |  0x20 ,res | 0b00000010);
 MODE='U';
 }

}


void RX_mode(){
 unsigned char res;
 res=NRF_RW( 0x00  |  0x00 , 0xFF );
 NRF_RW( 0x00  |  0x20 ,res | 0b00000011);
 delay_us(150);

 MODE='R';
}

void TX_mode(){
 unsigned char res;
 res=NRF_RW( 0x00  |  0x00 , 0xFF );
 NRF_RW( 0x00  |  0x20 ,res & 0b11111110);
 delay_us(150);

 MODE='T';
}



void set_data_rate(unsigned char rate){
 unsigned char res;
 res=NRF_RW( 0x06  |  0x00 , 0xFF );
 if (rate==2){NRF_RW( 0x06  |  0x20 ,res | 0b00001000);}
 else {NRF_RW( 0x06  |  0x20 ,res & 0b11110111);}

}



void set_RF_CH(unsigned char ch){
 if (ch<126){
 NRF_RW( 0x05  |  0x20 ,ch);

 }
}



void TX_output_power_control(unsigned char pwr){
 unsigned char res;
 if (pwr<4){
 res=NRF_RW( 0x06  |  0x00 , 0xFF );
 res=merge(res,pwr,1,0xF9);
 NRF_RW( 0x06  |  0x20 ,res);

 }
}



void RX_LNA_gain(unsigned char gain){
 unsigned char res;
 res=NRF_RW( 0x06  |  0x00 , 0xFF );
 res=merge(res,gain,0,0xFE);
 NRF_RW( 0x06  |  0x20 ,res);

}




void RX_set_static_payload(char reg,char length){
 NRF_RW(reg |  0x20 ,length);

}



void enable_dynamic_payload(char pipe){
 unsigned char res;
 res=NRF_RW( 0x1D  |  0x00 , 0xFF );
 NRF_RW( 0x1D  |  0x20 ,res | 0b00000100);
 if (MODE=='T'){pipe=0;}
 res=NRF_RW( 0x1C  |  0x00 , 0xFF );
 NRF_RW( 0x1C  |  0x20 ,res | 0x01<<pipe);

}

void set_address_width(unsigned char width){
 NRF_RW( 0x03  |  0x20 ,width-2);

}



void TX_set_address(unsigned char addr_width,unsigned char * addr){
 unsigned char i ;
 NRF_RW( 0x03  |  0x20 ,addr_width-2);
 toggle();
 SPI1_Write( 0x10  |  0x20 );
 for ( i = 0 ; i < addr_width ; i++ ){
 SPI1_Write(*addr);
 addr++;
 }


}



void TX_enable_auto_ack(unsigned char pipe){
 unsigned char res;
 res=NRF_RW( 0x01  |  0x00 , 0xFF );
 NRF_RW(  0x01  |  0x20 ,res | 0x01<<pipe);

}
void TX_disable_auto_ack(unsigned char pipe){
 unsigned char res;
 res=NRF_RW( 0x01  |  0x00 , 0xFF );
 NRF_RW( 0x01  |  0x20 , res & ~(0x01<<pipe));

}


void CRC_config(char crc){
 unsigned char res;
 res=NRF_RW( 0x00  |  0x00 , 0xFF );
 if (crc==1){NRF_RW( 0x00  |  0x20 ,res & 0b11111011);}
 else {NRF_RW( 0x00  |  0x20 ,res | 0b00000100);}

}





void TX_auto_retransmit(unsigned char delay, unsigned char count){
 delay = delay<<4;
 NRF_RW( 0x04  |  0x20 , delay | count );

}





void RX_ack_with_payload(unsigned char pipe,unsigned char dat_width,unsigned char * dat){
 unsigned char res,i;
 enable_dynamic_payload(pipe);
 res=NRF_RW( 0x1D  |  0x00 , 0xFF );
 NRF_RW( 0x1D  |  0x20 ,res | 0b00000010);
 toggle();
 SPI1_Write( 0xA8  | pipe);
 for ( i = 0 ; i < dat_width ; i++ ){
 SPI1_Write(*dat);
 dat++;
 }

}
void TX_write_buffer(unsigned char dat_width,unsigned char *dat ){
 unsigned char i ;
 toggle();
 SPI1_Write( 0xA0 );
 for ( i = 0 ; i < dat_width ; i++ ){
 SPI1_Write(*dat);
 dat++;
 }
 CE_PIN=1;
}

void set_pipe_address(unsigned char pipe,unsigned char width,unsigned char *address){
 unsigned char i;
 toggle();
 SPI1_Write( 0x20  | pipe);
 delay_us(GLOBAL_DELAY*50);
 for (i=0;i<width;i++){SPI1_Write(*address);address++;delay_us(GLOBAL_DELAY*50);}

}
