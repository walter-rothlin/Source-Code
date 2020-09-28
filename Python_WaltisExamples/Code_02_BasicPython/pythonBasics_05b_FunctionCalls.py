#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_05b_FunctionCalls.py
#
# Description: Demo for function calls with optional arguments. By Name By Position
#
# Autor: Walter Rothlin
#
# History:
# 25-Sep-2020   Walter Rothlin      Initial Version
# 27-Sep-2020   Walter Rothlin      Added to GitHub
#
# ------------------------------------------------------------------
import math


# Optionale Parameters am Schluss anhängen. So wird overloading in Python gemacht!
def sayHelloTo(firstname=None, lastname="Unknown", hellostr="Guten Morgen"):
    if firstname is not None:
        return "1:" + hellostr + " " + firstname + " " + lastname
    else:
        return "1:" + 'Hey you!!'


# =============
# Hauptprogramm
# =============
print("Calls by Position")
print('sayHelloTo()                                   = ',sayHelloTo())
print('sayHelloTo("")                                 = ',sayHelloTo(""))
print('sayHelloTo("Walti")                            = ',sayHelloTo("Walti"))
print('sayHelloTo("Walti","Rothlin")                  = ',sayHelloTo("Walti","Rothlin"))
print('sayHelloTo("Walti","Rothlin", "Guten Abend")   = ',sayHelloTo("Walti","Rothlin", "Guten Abend"))

print("\nCalls by Name")
print('sayHelloTo(firstname="Walti", lastname="Rothlin", hellostr="Gute Tag")   = ', sayHelloTo(firstname="Walti", lastname="Rothlin", hellostr="Gute Nacht"))
print('sayHelloTo(hellostr="Gute Nacht", lastname="Rothlin", firstname="Walti") = ', sayHelloTo(hellostr="Gute Nacht", lastname="Rothlin", firstname="Walti"))
# print('sayHelloTo(lastname="Rothlin")                                           = ', sayHelloTo(lastname="Rothlin"))    # ERROR: required argument missing
print('sayHelloTo(firstname="Walti")                                            = ', sayHelloTo(firstname="Walti"))
print('sayHelloTo(lastname="Rothlin", firstname="Walti")                        = ', sayHelloTo(lastname="Rothlin", firstname="Walti"))

print("\nCalls by Position and Name")
print('sayHelloTo("Walti",lastname="Rothlin", hellostr="Gute Nacht")           = ', sayHelloTo("Walti",lastname="Rothlin", hellostr="Gute Nacht"))
print('sayHelloTo("Walti", "Rothlin", hellostr="Gute Nacht")                   = ', sayHelloTo("Walti","Rothlin", hellostr="Gute Nacht"))
# print('sayHelloTo(firstname="Walti",lastname="Rothlin", "Gute Nacht") = ',sayHelloTo(firstname="Walti",lastname="Rothlin", "Gute Nacht"))   # ERROR: positional argument follows keyword argument
