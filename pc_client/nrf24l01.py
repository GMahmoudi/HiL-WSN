import serial
import time
import struct
from constants import *


class nrf24l01_pc_base:
    def __init__(self,serial_com_port,serial_baud_rate=9600,serial_debug=0,PW=1):
        self.serial_debug=serial_debug
        self.serial_com=serial.Serial(serial_com_port,serial_baud_rate)
        self.serial_com.flushInput()
        self.serial_com.write(INIT_SPI)
        debug_data=self.serial_com.read()
        if self.serial_debug:
            print debug_data
        self.PW=PW #payload width
        #enter recv mode
        self.exe(NRF_RW,[W_REGISTER+STATUS,0xff],1)
        self.exe(TX_DISABLE_AUTO_ACK,[0])
        #self.exe(NRF_RW,[W_REGISTER | SETUP_RETR,0x01],1)
        self.exe(RX_SET_STATIC_PAYLOAD,[RX_PW_P0,self.PW])
        self.exe(POWER_MODE,[1])
        self.exe(RX_MODE,None)
        self.exe(CE_PIN_HIGH,None)
    def exe(self,command,args,have_result=0):
        self.serial_com.flushInput()
        self.serial_com.write(command)
        #time.sleep(0.5)
        if args:
            for arg in args:
                self.serial_com.write(chr(arg))
        res=""
        if have_result:
            res=self.serial_com.read()
        debug_data=self.serial_com.read()
        if self.serial_debug:
            print debug_data
        return res
    def transmit(self,data):
        dat=[]
        for char in data:
            dat.append(ord(char))
        self.exe(CE_PIN_LOW,None)
        self.exe(TX_DISABLE_AUTO_ACK,[0])
        self.exe(POWER_MODE,[1])
        self.exe(TX_MODE,None)
        self.exe(NRF_RW,[W_TX_PAYLOAD,dat[0]],1)
        for i in range(1,len(dat)):
            self.exe('1',[dat[i]])
        self.exe(CE_PIN_HIGH,None)
        #time.sleep(1)
        self.exe(CE_PIN_LOW,None)
        if self.serial_debug:
            print self.exe(GET_STATUS,None,1).encode('hex')
        else:
            self.exe(GET_STATUS,None,1)
        #re-enter recv mode
        self.exe(NRF_RW,[W_REGISTER+STATUS,0xff],1)
        self.exe(TX_DISABLE_AUTO_ACK,[0])
        self.exe(RX_SET_STATIC_PAYLOAD,[RX_PW_P0,self.PW])
        self.exe(POWER_MODE,[1])
        self.exe(RX_MODE,None)
        self.exe(CE_PIN_HIGH,None)
    #should be removed and implemented in mcu
    def __get_fifo_status__(self):
        self.exe(TOGGLE_CSN,None)
        self.exe(SPI_WRITE,[FIFO_STATUS])
        return self.exe(SPI_READ,[NOP],1)
    def recv(self):
        res=""
        if ord(self.__get_fifo_status__())&0b00000001==0b00000001:
            return res
        self.exe(CE_PIN_LOW,None)
        res+=self.exe(NRF_RW,[R_RX_PAYLOAD,NOP],1)
        for i in range(self.PW-1):
            res+=self.exe('2',[NOP],1)
        self.exe(CE_PIN_HIGH,None)
        return res
    def packet(self):
        addr=chr(101)
        hopCount=chr(3)
        parent=chr(90)
        data=chr(25)
        z=chr(0)
        zf=z+z+z+z
        dataSrc=addr
        msgCount=chr(1)
        packet=addr+parent+hopCount+msgCount+z+z+z+data+zf+zf+zf+zf+dataSrc+z+z+z+z+z+z+z
        print len(packet)
        t=time.time()
        self.transmit(packet)
        print time.time()-t
    def parse(self,packet):
        print ("addr: %i" %ord(packet[0]))
        print ("dst(parent) : %i" %ord(packet[1]))


#n=nrf24l01_pc_base('com5',128000,0,32)
'''
def cd():
    t=time.time()
    while (time.time()-t)<10:
        if ord(n.exe(NRF_RW,[CD,NOP],1))<>0:
            print ("carreir detected at %i" %time.time())
def jam():
    for i in range(20):
        n.packet()
'''
