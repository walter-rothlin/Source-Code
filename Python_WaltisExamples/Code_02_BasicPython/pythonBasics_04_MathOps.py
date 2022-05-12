#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_04_MathOps.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_04_MathOps.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 03-Aug-2017  Walter Rothlin        Initial Version
# 19-Sep-2017  Walter Rothlin        Added math
# ------------------------------------------------------------------

import math      # https://docs.python.org/2/library/math.html

print("\n\n")
print("# Math-Operations ")
print("# --------------- ")


print("\n\n")
print("# Math")
print("# ----")
print("Additon        : 17 + 3.0 = ",17 + 3.0)
print("Subtraction    : 17 - 3.0 = ",17 - 3.0)
print("Multiplication : 17 * 3.0 = ",17 * 3.0)
print("Division       : 17/3     = ",17/3," ",end=''); print("python3! In python2 it would return 5!!!")
print("Division       : 17/3.0   = ",17/3.0)
print("Floor          : 17//3    = ",17 // 3)
print("Modulo         : 17%3     = ",17%3)
print("Power          : 2**4     = ",2**4)

radius = 5.0
print("Radius =",radius,"  ",end="", flush=True)
print("Kreisfläche = ",end="")
flaeche= radius*radius*3.1415926
print(flaeche)

flaeche= math.pow(radius,2) * math.pi
print("%10.2f::%10.3f::"  % (flaeche,radius))
print("%-10.2f::%10.3f::" % (flaeche,radius))
print("123456789012345678901234567890")

# runden, truncate
for ix in range(0,10):
    fx = ix / 10
    print(fx,int(fx),"{roundX:10.0f}".format(roundX=fx),round(fx),round(fx,1))

