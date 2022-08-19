#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_05b_IndirectFunctionCalls.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_05b_IndirectFunctionCalls.py
#
# Description: How to call a function via a string Variable
#
# Autor: Walter Rothlin
#
# History:
# 26-Oct-2020   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
import math
import inspect
import sys


# Optionale Parameters am Schluss anhängen. So wird overloading in Python gemacht!
def sayHelloTo(firstname=None, lastname="Unknown", hellostr="Guten Morgen"):
    if firstname is not None:
        return "1:" + hellostr + " " + firstname + " " + lastname
    else:
        return "2:" + 'Hey you!!'


# =============
# Hauptprogramm
# =============
if __name__ == '__main__':
    print("# Eval")
    print("# ----")
    print("sayHelloTo()                                                  --> ", eval("sayHelloTo()"))
    print("sayHelloTo('Meier')                                           --> ", eval("sayHelloTo('Meier')"))
    print("sayHelloTo(lastname='Meier', firstname='Max', hellostr='Hi')  --> ", eval("sayHelloTo(lastname='Meier', firstname='Max', hellostr='Hi')"), "\n\n")


    print("# Reflection")
    print("# ----------")
    inspection = globals().copy()
    print("Globals :", inspection)
    inspection.update(locals())
    print("..Locals:", inspection, "\n\n")

    method = inspection.get("sayHelloTo")
    if not method:
        print("Function not found")
    else:
        print("# Calls via Reflection")
        print("# --------------------")
        print("sayHelloTo()                                                  --> ", method())
        print("sayHelloTo('Meier')                                           --> ", method('Meier'))
        print("sayHelloTo(lastname='Meier', firstname='Max', hellostr='Hi')  --> ", method(lastname='Meier', firstname='Max', hellostr='Hi'), "\n\n")
