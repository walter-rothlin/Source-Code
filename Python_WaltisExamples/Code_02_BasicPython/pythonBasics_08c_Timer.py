#!/usr/bin/python3

from threading import Timer


def hello(firstname="No", lastName="Name"):
    print("Hello", firstname, lastName)

# Main
# ====
delayTime = float(input("Delay-Time [s]:"))
fName = input("Vorname :")
lName = input("Nachname:")

hello("Felix", "Muster")
hello(fName, lName)
hello()

t = Timer(2.4, hello, args=[fName, lName])
t.start()

hello("Felix_1", "Muster")
print("\n")
