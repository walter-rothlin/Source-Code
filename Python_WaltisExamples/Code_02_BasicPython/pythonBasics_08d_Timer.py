#!/usr/bin/python

# ------------------------------------------------------------------
# Name  : pythonBasics_08d_Timer.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08d_Timer.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# 07-Sep-2026   Walter Rothlin      Version developed with HFU Students
# ------------------------------------------------------------------
from time import sleep
from threading import Timer


do_loop = True

def hello(msg, text1):
    global loopWaitTime
    global do_loop
    i = 0
    while do_loop:
        print(i, msg, text1)
        i += 1
        sleep(loopWaitTime)
    print("Thread terminated!!!!")



if __name__ == '__main__':
    wakeup_time = float(input('Wakeup-Time [s]:'))
    loopWaitTime = float(input('Loop Wait-Time [s]:'))
    msg = input('Meldung:')

    print("Timer set to {dT:3.1f}".format(dT=wakeup_time))

    t  = Timer(wakeup_time, hello, args=[msg, "bei Nacht"])
    t1 = Timer(wakeup_time/2, hello, args=["HFU", "Studenten"])

    t.start()
    t1.start()

    print("... main waiting for timer off")
    for i in range(10):
        print(f'main-Thread: {i}')
        sleep(0.5)

    doStop = input("Press any key to stop?")
    do_loop = False

    print('waiting for t ....')
    t.join()
    print('... t.joined')

    t1.join()

    print('main thread stopped!')