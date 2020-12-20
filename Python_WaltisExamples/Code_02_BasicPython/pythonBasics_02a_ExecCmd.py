#!/usr/bin/python3

#@author Walter Rothlin
#@version 1.0
#@since 03-Aug-2017
#@help
#Help of command pythonBasics_02a_ExecCmd
#
#
#
#@history:
#03-Aug-2017  Walter Rothlin        Initial Version
#
#End of help for command pythonBasics_02a_ExecCmd

import subprocess 

for ping in range(11,20): 
        address = "192.168.1." + str(ping) 
        res = subprocess.call(['ping', '-c', '3', address]) 
        if res == 0: 
            print( "ping to", address, "OK") 
        elif res == 2: 
            print("no response from", address) 
        else: 
            print("ping to", address, "failed!") 


