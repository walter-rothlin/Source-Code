#!/usr/bin/python3

from threading import Timer

def hello(firstName,lastName):
    print("hello,",firstName,lastName)

delayTime = float(input("Delay-Time [s]:"))
fName = input("Vorname :")
lName = input("Nachname:")
print("Timer set to {dT:3.1f}".format(dT=delayTime))

t = Timer(delayTime, hello, args=[fName,lName])
t.start() # after 30 seconds, "hello, firstName lastName" will be printed

print("... main waiting for timer off")
t.join()
print("... main finished!!!!")


