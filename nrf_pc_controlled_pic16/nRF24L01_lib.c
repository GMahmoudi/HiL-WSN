#include "nRF24L01.h"
#include "nrf24l01_lib.h"

sbit CSN_PIN at RE2_bit;    //Chip Select Not
sbit MOSI_PIN at RC5_bit;  //SDO
sbit MISO_PIN at RC4_bit; //SDI
sbit CE_PIN at RC2_bit;   //Chip enable (changable)
sbit SCLK_PIN at RC3_bit;  //Interrupt

sbit CSN_Dir at TRISE2_bit;
sbit MOSI_Dir at TRISC5_bit;
sbit MISO_Dir at TRISC4_bit;
sbit CE_Dir at TRISC2_bit;
sbit SCLK_Dir at TRISC3_bit;

unsigned char MODE='D';

const unsigned char GLOBAL_DELAY=255;

////
unsigned char get_MODE(){
   return MODE;
}
////

void init_spi(){
     //set I/O for SPI protocol .. PIC as master NRF as slave.
     MISO_Dir=1;
     MOSI_Dir=0;
     CSN_Dir=0;
     CE_Dir=0;
     SCLK_Dir=0;
     SPI1_Init();
     //SSPCON=0b00100010;
}

void toggle(){
     CE_PIN=0;         //standbyI mode
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
    res=SPI1_Read(NOP);
    //CE_PIN=1;
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

//down=0 >> power down , else power up
void power_mode(unsigned char down){
     unsigned char res;
     res=NRF_RW(CONFIG | R_REGISTER,NOP);
     if (down==0){
        NRF_RW(CONFIG | W_REGISTER,res & 0b11111101);
        MODE='D';
     }
     else{
        NRF_RW(CONFIG | W_REGISTER,res | 0b00000010);
        MODE='U';
     }
     //CE_PIN=1;
}

//PWR_UP=1 ; PRIM_RX=1 ; CE_PIN=1
void RX_mode(){
     unsigned char res;
     res=NRF_RW(CONFIG | R_REGISTER,NOP);
     NRF_RW(CONFIG | W_REGISTER,res | 0b00000011);
     delay_us(150);
     //CE_PIN=1;
     MODE='R';
}
//PWR_UP=1 ; PRIM_RX=0 ; CE_PIN=1
void TX_mode(){
     unsigned char res;
     res=NRF_RW(CONFIG | R_REGISTER,NOP);
     NRF_RW(CONFIG | W_REGISTER,res & 0b11111110);
     delay_us(150);
     //CE_PIN=1;
     MODE='T';
}

// transmitter and reciever should have the same data rate
//rate: 2 : 2Mbps, 1 : 1Mbps
void set_data_rate(unsigned char rate){
     unsigned char res;
     res=NRF_RW(RF_SETUP | R_REGISTER,NOP);
     if (rate==2){NRF_RW(RF_SETUP | W_REGISTER,res | 0b00001000);}        //rate=2Mbps
     else {NRF_RW(RF_SETUP | W_REGISTER,res & 0b11110111);}        //rate=1Mbps
     //CE_PIN=1;
}

// transmitter and reciever should have the same channel
//ch : 0 --> 125 (2400 + RF_CH MHz)
void set_RF_CH(unsigned char ch){
     if (ch<126){
        NRF_RW(RF_CH | W_REGISTER,ch);
        //CE_PIN=1;
     }
}

//set output power of transmitter
//pwr: 0 --> 3 , 0: low power low distance.
void TX_output_power_control(unsigned char pwr){
     unsigned char res;
     if (pwr<4){
        res=NRF_RW(RF_SETUP | R_REGISTER,NOP);
        res=merge(res,pwr,1,0xF9);
        NRF_RW(RF_SETUP | W_REGISTER,res);
        //CE_PIN=1;
     }
}

//LNA Gain
//gain : 0 or 1 , 1: high gain high current , 0: low gain low current.
void RX_LNA_gain(unsigned char gain){
     unsigned char res;
     res=NRF_RW(RF_SETUP | R_REGISTER,NOP);
     res=merge(res,gain,0,0xFE);
     NRF_RW(RF_SETUP | W_REGISTER,res);
     //CE_PIN=1;
}

//set payload to static mode and set payload length, length is 1 to 32 bytes. (In Reciever only).
//reg : RX_PW_Px  where x : pipe number
//length : 1 to 32 , length of payload.
void RX_set_static_payload(char reg,char length){
     NRF_RW(reg | W_REGISTER,length);
     //CE_PIN=1;
}

//enable dynamic payload  .
//pipe : 0-->5  if TX Mode pipe=0 else pipe=RX Mode pipe
void enable_dynamic_payload(char pipe){
     unsigned char res;
     res=NRF_RW(FEATURE | R_REGISTER,NOP);
     NRF_RW(FEATURE | W_REGISTER,res | 0b00000100);
     if (MODE=='T'){pipe=0;}
     res=NRF_RW(DYNPD | R_REGISTER,NOP);
     NRF_RW(DYNPD | W_REGISTER,res | 0x01<<pipe);
     //CE_PIN=1;
}

void set_address_width(unsigned char width){
    NRF_RW(SETUP_AW | W_REGISTER,width-2);
    //CE_PIN=1;
}

//width: 3 ,4 ,5 for 3bytes,4bytes,5bytes.
//addr:  address of reciever.
void TX_set_address(unsigned char addr_width,unsigned char * addr){
     unsigned char i ;
     NRF_RW(SETUP_AW | W_REGISTER,addr_width-2);
     toggle();
     SPI1_Write(TX_ADDR | W_REGISTER);
     for ( i = 0 ; i < addr_width ; i++ ){
         SPI1_Write(*addr);
         addr++;
     }
     //CE_PIN=1;

}


///enables auto ack on selected data pipe ( 0 TO 5 )
void TX_enable_auto_ack(unsigned char pipe){
     unsigned char res;
     res=NRF_RW(EN_AA | R_REGISTER,NOP);
     NRF_RW( EN_AA | W_REGISTER,res | 0x01<<pipe);
     //CE_PIN=1;
}
void TX_disable_auto_ack(unsigned char pipe){
     unsigned char res;
     res=NRF_RW(EN_AA | R_REGISTER,NOP);
     NRF_RW(EN_AA | W_REGISTER, res & ~(0x01<<pipe));
     //CE_PIN=1;
}

//crc: sets CRC encoding scheme to 1 byte (if 1) or 2 bytes (if 2).
void CRC_config(char crc){
     unsigned char res;
     res=NRF_RW(CONFIG | R_REGISTER,NOP);
     if (crc==1){NRF_RW(CONFIG | W_REGISTER,res & 0b11111011);}
     else {NRF_RW(CONFIG | W_REGISTER,res | 0b00000100);}
     //CE_PIN=1;
}

/// automatic retransmission on fail of Auto Acknoledgment
/// Delay defined from end of transmission to start of next transmission
/// delay : ( 0 to 15 ) ; 0 = 250us , 1 = 500us , 2 = 750us  ...... 15 = 4000us
///count : ( number of retransmission attempts ) ( 0 up to 15 ) ; 0 : no retransmission ..... 15 : up to 15 attempts
void TX_auto_retransmit(unsigned char delay, unsigned char count){
     delay = delay<<4;
     NRF_RW(SETUP_RETR | W_REGISTER, delay | count );
     //CE_PIN=1;
}

//enable payload for ack and set the data and pipe.
//pipe : 0-->5 .
//bytes: payload added to ack.
/////////ACTIVATE command should be executed first//////////////
void RX_ack_with_payload(unsigned char pipe,unsigned char dat_width,unsigned char * dat){
     unsigned char res,i;
     enable_dynamic_payload(pipe);
     res=NRF_RW(FEATURE | R_REGISTER,NOP);
     NRF_RW(FEATURE | W_REGISTER,res | 0b00000010);
     toggle();
     SPI1_Write(W_ACK_PAYLOAD | pipe);
     for ( i = 0 ; i < dat_width ; i++ ){
         SPI1_Write(*dat);
         dat++;
     }
     //CE_PIN=1;
}
void TX_write_buffer(unsigned char dat_width,unsigned char *dat ){
     unsigned char i ;
     toggle();
     SPI1_Write(W_TX_PAYLOAD);
     for ( i = 0 ; i < dat_width ; i++ ){
         SPI1_Write(*dat);
         dat++;
     }
     CE_PIN=1;
}

void set_pipe_address(unsigned char pipe,unsigned char width,unsigned char *address){
   unsigned char i;
   toggle();
   SPI1_Write(W_REGISTER | pipe);
   delay_us(GLOBAL_DELAY*50);
   for (i=0;i<width;i++){SPI1_Write(*address);address++;delay_us(GLOBAL_DELAY*50);}
   //CE_PIN=1;
}