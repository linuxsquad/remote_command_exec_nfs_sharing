#!/usr/bin/env python
#
#
#

import sys
import time
import socket
import hashlib

EXEC_COMMAND_IN = './nc_exec_command_in.log'
SERVER_IP_ADDRESS = '192.168.2.108'
SERVER_PORT = 54321
BUFFER_SIZE = 1024
counter = 0

def sendCommand(in_command):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((SERVER_IP_ADDRESS, SERVER_PORT))
    s.send(in_command.encode('utf-8'))
    s.close()


while True:
    print("Enter command for remote execution: ")
    for line in sys.stdin:
        m = hashlib.new('md5')
        counter+=1
        header="["+str(time.strftime("%y%m%d%H%M%S"))+"-"+str(counter)+"]"
        message = header+" "+str(line)
        # writting into log file
        logfile = open(EXEC_COMMAND_IN,'a')
        logfile.write(message)
        logfile.close()
        # calculating MD5SUM
        m.update(message.encode('utf-8'))
        sendCommand(str(header+" "+m.hexdigest()))
  
