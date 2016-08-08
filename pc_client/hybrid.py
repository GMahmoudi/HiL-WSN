from nrf24l01 import *
import thread
import time
from socket import *
import sys

hybrid=nrf24l01_pc_base(sys.argv[1],128000,0,PW=32)

client=socket(AF_INET,SOCK_STREAM)
client.connect(("127.0.0.1",12345))
print "connected"
client.setblocking(0)
simData=''
HWData=''
loop=1
while(1):
    #print "loop number" ,loop
    try:
        simData=client.recv(32)
    except:
        pass
    #print "recvd"
    if simData<>'':
        print "simData not empty"
        hybrid.transmit(simData)
        time.sleep(2)
        print "transmitted to HW"
        simData=''
    HWData=hybrid.recv()
    if HWData<>'':
        print "hw data ... recvd"
        hybrid.parse(HWData)
        client.send(HWData)
        HWData=''
    loop+=1
