import tornado.httpserver
import tornado.websocket
import tornado.ioloop
import tornado.web
import socket
import time
import thread
import struct

fromSink=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
fromSink.connect(("127.0.0.1",12346))
fromSink.send("ping")

class WSHandler(tornado.websocket.WebSocketHandler):
    def handleData(self,threadName):
        while (self.opened):
            #print "in thread"
            packet=fromSink.recv(32)
            for i in range(24,32):
                if str(ord(packet[i]))==self.node_id:
                    B1=packet[4+(i-24)*4]
                    B2=packet[5+(i-24)*4]
                    B3=packet[6+(i-24)*4]
                    B4=packet[7+(i-24)*4]
                    self.write_message(str(struct.unpack('f',B1+B2+B3+B4)))
                    break
            #time.sleep(1)
    def open(self,node_id):
        print 'new connection'
        self.opened=1
        self.node_id=node_id
        thread.start_new_thread(self.handleData,("handleData",))
    def on_message(self,message):
        print message
    def on_close(self):
        print 'connection closed'
        self.opened=0
    def check_origin(self,origin):
        return True
    

app=tornado.web.Application(
    [
        (r'/ws/([0-9]+)',WSHandler),
        (r'/static/(.*)', tornado.web.StaticFileHandler, {'path': '.\\static\\'})
    ]
)

if __name__=="__main__":
    http_server=tornado.httpserver.HTTPServer(app)
    http_server.listen(8080)
    tornado.ioloop.IOLoop.instance().start()
    
