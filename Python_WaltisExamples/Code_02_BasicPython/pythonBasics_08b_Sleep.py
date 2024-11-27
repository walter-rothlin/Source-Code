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
from time import sleep

doLoop = True

def hello(msg, text1):
    i = 0
    while doLoop:
        print(i, msg, text1)
        i += 1
        sleep(loopWaitTime)
    print("Thread terminated!!!!")

if __name__ == '__main__':
    wakeup_time = float(input("Wakeup-Time [s]:"))
    loopWaitTime = float(input("Loop Wait-Time [s]:"))
    message = input("Meldung :")
    print("Timer set to {dT:3.1f}".format(dT=wakeup_time))

    t = Timer(wakeup_time, hello, args=[message, "Studenten"])
    t.start()

    print("... main waiting for timer off")

    for i in range(10):
        print(f'main-Thread: {i}')
        sleep(0.5)

    doStop = input("Press any key to stop?")
    doLoop = False
    # t.join()
    print("... main finished!!!!")


