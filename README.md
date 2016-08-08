# HiL-WSN Simulation: Hardware-in-the-Loop Simulation of Wireless Sensor Networks
Bachelor project at Tishreen university, Latakia, Syria
Supervisor: Dr.-Ing. Ghadi MAHMOUDI
Students: Ammar RAJAB, Fares ALHAMED

## Introduction

Hardware-in-the-loop simulation simplifies the design process of complicated costly systems. Wireless Sensor networks represent an example of such systems: a lot of nodes, which must be designed and tested individually and then integrated in a single network. The whole network can be simulated normally using one of the available simulators, while the design of the individual nodes is a matter of hardware/firmware development.
Using HiL-WSN, a big Wireless Sensor Network can be designed and simulated, both as a virtual model (OMNET++) and as a hardware (here a combination of NRF24L01 transceiver module and PIC12LF1552 microcontroller, adapted from the project http://libstock.mikroe.com/projects/view/195/nordic-semi-nrf24l01-example).

The example given here shows how a routing protocol can be simulated using OMNET++ and implemented in real HW/firmware nodes. The HiL-simulation considers all nodes as a WSN and enables a realistic test of the real nodes within lot of surrounding virtual counterparts.

The user can also change the real hardware nodes parameters like the data rate , power mode , operating channel frequency and many other parameters , all this can be done with simple API explained later in this file.

## How it works
A hybrid node gathers the simulated network (OMNET++) and real nodes (NRF24L01 transceiver module and PIC12LF1552). The hybrid node is connected to the PC running OMNET++ through USB, and to the real nodes using NRF24L01 tranciever module.

## Usage

### To run the project follow these instructions:
    - Install OMNET++ (the project has been tested using OMNET++ v4.6)
    - Import the OMNET++ project located in the directory called "omnet" following these steps:
        - Launch the OMNET++.
        - File -> import -> Existing Projects into Workspace -> Select archive file -> Browse
        - Select the file called "wsn_nrf.zip" from the "omnet" directory.
    - In the OMNET++ simulator , from Project Explorer , open the imported project "wsn_nrf".
    - Open the file "src/omnetpp.ini"
    - Click on Run (or Ctrl+F11)
    - You can select the desired network file, by default (in this project) there're three networks:
        - Simple : a pure virtual network (not connected to external hardware) , it's used to test or visualize the routing protocol on simulated nodes.
        - hw2sink : a pure hardware network (consisting of two hardware nodes and a sink) , it's used to test the hybrid node (which connects the two environments).
        - net : the main network which consists of simulated and real nodes .
    


- When selecting ***any network*** , and ***before*** starting the simulation, ***start the server*** that connects the simulator to the Internet so that you can view the data of the nodes from any device on your network.
        - the server is located in the "server" directory , the file name is "server.py".
    - Connect the real hybrid node (the circuit which has the USB cable) to PC.
    - Get the COM port number (On windows from the Device Manager).
    - Start the file located in "pc_client" directory called "hybrid.py" with the port number as the first argument , this script connects the OMNET++ simulator to the real hybrid node (the circuit which is connected to the PC with the USB cable).
        - to run the script (On windows) in the "pc_client" directory press Shift+Right Click , and from the menu choose "open command window here", the Command window shows up , type "hybrid.py comx" where x is the com port number.
    - Switch on the hardware nodes.
    - Start the simulator now , and put your CPU on "high performance" energy profile and put the simulator on the fastest animation speed (so that the simulator time is closer to the real time).
    - In the simulator log you can see the messages ,that is delivered to the sink node, printed.
    - To use the internet server , start your Internet browser , navigate to "http://127.0.0.1/static/index.html" in the "uri" field of the page type "/ws/x" where x is the node address.

## Usage (simplified)
    - Switch on the hardware nodes and connect the hybrid node to the PC.
    - Run the simulator.
    - Run "/server/server.py".
    - Run "/pc_client/hybrid.py".
    - Start the simulation.

## Contributing
### Editing the routing protocol:
#### In the simulator:
    - edit "src/packet.msg" to define the network layer packet fields.
    - in "src/routingProtocol.cc" edit the following functions:
        - sendNewPacket(float data):
            this function is called on the "scheduledEvent" event which represents the interval of data sending process, this interval is defined in the "src/GLOBALS.h" called "RETRANSMIT".
            the parameter data is the return of the ApplicationLayer function called "generateData()" located in "/src/ApplicationLayer.cc".
        - handleMyPacket(Packet *pkt):
            this function is called when a node receives a message that is addressed to it.The parameter pkt is the message received.
        - handleOverHeard(Packet *pkt):
            this function is called when a node receives a message that is not addressed to it (from a node in the same range).The parameter pkt is the message received.
    - If you changed the "/src/packet.msg" file (if you changed the protocol fields) you have to change the following functions (located in "/src/HybridNode.cc") for the hybrid node to work properly:
        - SendRawPacket(Packet *pkt):
            this function is used to convert the packet from the simulator (from Packet object) to a stream of raw bytes (array of bytes) that can be sent outside the simulator (in this project the raw packet is sent to the client file "hybrid.py" which sends it to the real hardware node).
        - parsePacket(Packet *pkt):
            this function is used to convert the raw packet received from the outside of the simulator to a Packet object that can be used in the simulator.
#### In the real nodes:
    The functions of the network layer are the same as in the simulator.
    Launch mikroC IDE project file located in "nrf_pic12" directory , the file name is called "nrf_pic12.mcppi"
    - In the "NetworkLayer.c" the variable array dat[32] is used as a buffer for reading and writing the packet.
    - NetworkLayer functions are called from the "main" function in the file "nrf_pic12.c".
    - Edit the functions in the "NetworkLayer.c" in the same logic of the "routingProtocol.cc" functions in the simulator.
    - Compile the program and burn the chips.
### editing the application layer:
#### In the simulator:
    - From the file "src/ApplicationLayer.cc" edit the function "generateData()".
    - Retransmitting time can be edited from the "src/GLOBALS.h" by the variable "RETRANSMIT".
#### In the real nodes:
    - The application layer is the "main" function so you can use the desired PIC MCU code as long as you call the following functions : nrf_init(32) (32 refers to the payload width - 32 is the maximum paylpoad width in the NRF24L01 module) and the network layer functions (handleMyPacket,handleOverHeard).


## Installation
### Requirements
    - Python (we used Python 2.7.10)
        - pySerial library (used for the real hybrid node connection to PC).
        - tornado library (used for the web server).
    - OMNET++ 4
    - mikroC PRO (we used v6.6.2)


## Contact
    ghadi.mahmoudi@gmail.com , ammar.rajab1@gmail.com , oknighto2@gmail.com
## License



