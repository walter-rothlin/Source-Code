#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_08b_Sleep.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08b_Sleep.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from threading import Timer
import time

doLoop = True

def hello(msg, text1):
    i = 0
    while doLoop:
        print(i, msg, text1)
        i += 1
        time.sleep(loopWaitTime)
    print("Thread terminated!!!!")

if __name__ == '__main__':
    delayTime = float(input("Delay-Time [s]:"))
    loopWaitTime = float(input("Loop Wait-Time [s]:"))
    message = input("Meldung :")
    print("Timer set to {dT:3.1f}".format(dT=delayTime))

    t = Timer(delayTime, hello, args=[message, "HWZ"])
    t.start()

    print("... main waiting for timer off")
    doStop = input("Stop?")
    doLoop = False
    t.join()
    print("... main finished!!!!")


