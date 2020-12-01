#!/usr/bin/python3

from threading import Timer
import time

delayTime = float(input("Delay-Time [s]:"))
doLoop = True
i = 0;
while doLoop:
    print(i, "hallo")
    i += 1
    time.sleep(delayTime)



