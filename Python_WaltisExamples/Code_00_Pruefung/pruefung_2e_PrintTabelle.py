#!/usr/bin/python3

'''pruefung_2e_PrintTabelle.py'''

''' Expected Result:
123456789012345678901234567890
Exponent     Potenz
         0            1
         1            2
         2            4
         3            8
         4           16
         5           32
         6           64
         7          128
         8          256
         9          512
        10         1024
'''

import math


basis     = 2
lowRange  = 0
highRange = 10

print("123456789012345678901234567890")
print("{exponent:10s}   {potenz:10s}".format(exponent="Exponent",potenz="Potenz"))
for i in range(lowRange, highRange+1):
    print("{exponent:10d}   {potenz:10.0f}".format(exponent=i,potenz=math.pow(basis,i)))
print("\n")

