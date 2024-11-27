#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_08a_SleepSimple.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08a_SleepSimple.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

from time import sleep

delayTime = float(input("Delay [s]:"))
zaehler = 0
while True:
    print("{n:10d}: Hallo HWZ".format(n=zaehler))
    zaehler += 1     # zaehler = zaehler + 1

    # busy wait
    # for i in range(10000):
    #    tmp = 4.5 * 2.1

    # timer-Event (Scheduler Anfrage)
    sleep(delayTime)



