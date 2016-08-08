'''
    Copyright (c) 2007 Stefan Engelke <mbox@stefanengelke.de>


    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation
    files (the "Software"), to deal in the Software without
    restriction, including without limitation the rights to use, copy,
    modify, merge, publish, distribute, sublicense, and/or sell copies
    of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:


    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.


    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.

    Modified by Allen Mulvey 2014
    Under Bit Mnemonics pin numbers were replaced with pin values
'''

# Memory Map 
CONFIG  =    0x00
EN_AA   =    0x01
EN_RXADDR =  0x02
SETUP_AW   = 0x03
SETUP_RETR = 0x04
RF_CH      = 0x05
RF_SETUP   = 0x06
STATUS     = 0x07
OBSERVE_TX = 0x08
CD         = 0x09
RX_ADDR_P0 = 0x0A
RX_ADDR_P1 = 0x0B
RX_ADDR_P2 = 0x0C
RX_ADDR_P3 = 0x0D
RX_ADDR_P4 = 0x0E
RX_ADDR_P5 = 0x0F
TX_ADDR    = 0x10
RX_PW_P0   = 0x11
RX_PW_P1   = 0x12
RX_PW_P2   = 0x13
RX_PW_P3   = 0x14
RX_PW_P4   = 0x15
RX_PW_P5   = 0x16
FIFO_STATUS= 0x17
DYNPD      = 0x1C
FEATURE    = 0x1D


# Bit Mnemonics 
MASK_RX_DR = 0x40 #6
MASK_TX_DS = 0x20 #5
MASK_MAX_RT= 0x10 #4
EN_CRC     = 0x08 #3
CRCO       = 0x04 #2
PWR_UP     = 0x02 #1
PRIM_RX    = 0x01 #0
ENAA_P5    = 0x20 #5
ENAA_P4    = 0x10 #4
ENAA_P3    = 0x08 #3
ENAA_P2    = 0x04 #2
ENAA_P1    = 0x02 #1
ENAA_P0    = 0x01 #0
ERX_P5     = 0x20 #5
ERX_P4     = 0x10 #4
ERX_P3     = 0x08 #3
ERX_P2     = 0x04 #2
ERX_P1     = 0x02 #1
ERX_P0     = 0x01 #0
AW3        = 0x01 #0     3 bytes
AW4        = 0x02 #0     4 bytes
AW5        = 0x03 #0     5 bytes
ARD        = 0x10 #4
ARC        = 0x01 #0
PLL_LOCK   = 0x10 #4
RF_DR      = 0x08 #3
RF_PWR     = 0x06 #6
RX_DR      = 0x40 #6
TX_DS      = 0x20 #5
MAX_RT     = 0x10 #4
RX_P_NO    = 0x02 #1
TX_FULL    = 0x01 #0
PLOS_CNT   = 0x10 #4
ARC_CNT    = 0x01 #0
TX_REUSE   = 0x40 #6
FIFO_FULL  = 0x20 #5
TX_EMPTY   = 0x10 #4
RX_FULL    = 0x02 #1
RX_EMPTY   = 0x01 #0
DPL_P5     = 0x20 #5
DPL_P4     = 0x10 #4
DPL_P3     = 0x08 #3
DPL_P2     = 0x04 #2
DPL_P1     = 0x02 #1
DPL_P0     = 0x01 #0
EN_DPL     = 0x04 #2
EN_ACK_PAY = 0x02 #1
EN_DYN_ACK = 0x01 #0


# Instruction Mnemonics
R_REGISTER =   0x00
W_REGISTER =   0x20
REGISTER_MASK = 0x1F
ACTIVATE   =   0x50
R_RX_PL_WID =   0x60
R_RX_PAYLOAD =  0x61
W_TX_PAYLOAD = 0xA0
W_ACK_PAYLOAD = 0xA8     # and with ack pipe number
FLUSH_TX   =   0xE1
FLUSH_RX   =   0xE2
REUSE_TX_PL =   0xE3
W_TX_PAYLOAD_NOACK = 0xB0
NOP        =   0xFF


# Non-P omissions
LNA_HCURR  = 0x01 #0


# P model memory Map
RPD        = 0x09


# P model bit Mnemonics
RF_DR_LOW  = 0x10 #5
RF_DR_HIGH = 0x08 #3
RF_PWR_LOW = 0x02 #1
RF_PWR_HIGH = 0x06 #2

################# commands ######################

SPI_WRITE='1'
SPI_READ='2'
CE_PIN_LOW='3'
CE_PIN_HIGH='4'
TOGGLE='5'
TOGGLE_CSN='6'

INIT_SPI='a'
GET_STATUS='b'
NRF_RW='c'
POWER_MODE='d'
SET_DATA_RATE='e'
SET_RF_CH='f'
CRC_CONFIG='g'
ENABLE_DYNAMIC_PAYLOAD='h'
SET_ADDRESS_WIDTH='i'
SET_PIPE_ADDRESS='j'

RX_MODE='k'
RX_LNA_GAIN='l'
RX_ACK_WITH_PAYLOAD='m'
RX_SET_STATIC_PAYLOAD='n'

TX_MODE='o'
TX_WRITE_BUFFER='p'
TX_AUTO_RETRANSMIT='q'
TX_DISABLE_AUTO_ACK='r'
TX_ENABLE_AUTO_ACK='s'
TX_SET_ADDRESS='t'
TX_OUTPUT_POWER_CONTROL='u'
