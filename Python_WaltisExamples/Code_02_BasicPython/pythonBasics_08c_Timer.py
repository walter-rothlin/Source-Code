#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_08c_Timer.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08c_Timer.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from threading import Timer


def hello(firstname="No", lastName="Name"):
    print("Hello", firstname, lastName)

# Main
# ====
wake_up_time = float(input("Wakeup-Time [s]:"))
fName = input("Vorname :")
lName = input("Nachname:")

hello("Felix", "Muster")
hello(fName, lName)
hello()

t = Timer(wake_up_time, hello, args=[fName, lName])
t.start()

hello("Felix_1", "Muster")
print("\n")
