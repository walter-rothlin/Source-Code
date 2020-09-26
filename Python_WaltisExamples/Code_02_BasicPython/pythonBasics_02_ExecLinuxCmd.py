#!/usr/bin/python3

import os

#@author Walter Rothlin
#@version 1.0
#@since 03-Aug-2017
#@help
#Help of command 'pythonBasics_02'
#
#
#
#@history:
#03-Aug-2017  Walter Rothlin        Initial Version
#17-Apr-2018  Walter Rothlin        Redirect into a string
#			
#End of help for command 'pythonBasics_02'

print("\n\n")  # first statement
print("# Execute a LINUX command ")
print("# ----------------------- ")


dirStr = os.system("ls -al")
print(dirStr)

print(os.system("/home/pi/bin/showIP"))
print("\n")

ipArray = os.popen('/home/pi/bin/showIP').read().strip().split(" ")
print(ipArray)
print("\n")

