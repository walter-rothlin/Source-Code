#!/usr/bin/python3

import math


basis     = 2
lowRange  = 0
highRange = 10

print("{exponent:10s}   {potenz:10s}".format(exponent="Exponent",potenz="Potenz"))
for i in range(lowRange,highRange+1):
    print("{exponent:10d}   {potenz:10.0f}".format(exponent=i,potenz=math.pow(basis,i)))
print("\n")

