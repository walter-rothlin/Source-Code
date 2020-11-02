#!/usr/bin/python3

from threading import Timer
import time

def hello(firstName, lastName, anz):
    for i in range(anz):
        print(i, "hello,", firstName, lastName)
        time.sleep(1)

delayTime = float(input("Delay-Time [s]:"))
fName = input("Vorname :")
lName = input("Nachname:")
anzahl = int(input("Wieviele Durchgänge:"))
print("Timer set to {dT:3.1f}".format(dT=delayTime))

t = Timer(delayTime, hello, args=[fName, lName, anzahl])
t.start() # after 30 seconds, "hello, firstName lastName" will be printed

print("... main waiting for timer off")
t.join()
print("... main finished!!!!")


