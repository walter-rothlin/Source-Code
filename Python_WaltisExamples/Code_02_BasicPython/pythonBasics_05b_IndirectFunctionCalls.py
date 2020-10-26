#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_05b_IndirectFunctionCalls.py
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
        return "1:" + 'Hey you!!'


# =============
# Hauptprogramm
# =============
print(sayHelloTo())
print(eval("sayHelloTo('Meier')"))   # mittels eval

possibles = globals().copy()
possibles.update(locals())
# print(possibles)
method = possibles.get("sayHelloTo")
if not method:
    print("not found")
else:
    print(method("Rothlin"))
