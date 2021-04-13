#!/usr/bin/python3

import time

delayTime = float(input("Delay [s]:"))
zaehler = 0
while True:
    print("{n:10d}: Hallo HWZ".format(n=zaehler))
    zaehler += 1     # zaehler = zaehler + 1

    # busy wait
    # for i in range(10000):
    #    tmp = 4.5 * 2.1

    # timer-Event (Scheduler Anfrage)
    time.sleep(delayTime)



