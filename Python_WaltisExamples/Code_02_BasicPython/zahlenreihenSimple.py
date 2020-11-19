#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: zahlenreihenSimple.py
#
# Description: Generiert Zahlenreihen
#
# Autor: Walter Rothlin
#
# History:
# 12-Dec-2019   Walter Rothlin      Initial Version

# ------------------------------------------------------------------
import math
from waltisLibrary import *

print("Zahlenreihen")

#for i in (1,4,5,8,12):
#    print(i)

#for name in ("Walti","Max","Fritz"):
#    print(name)


print("+------+--------+-----------+")
print("|   i  | i*i    |      2^i  |")
print("+------+--------+-----------+")

for i in range(21):
    print("|{i:5d} | {ii:6d} | {iii:10.0f}|".format(i=i,ii=i*i,iii=math.pow(2,i)))

print("+------+--------+-----------+")


print("\n\n")

for i in range(10):        # 0,1,2,3,4,5,6,7,8,9,
    print(i,end=",",flush=True)
print("\n\n")


for i in range(5,20):      # 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,
    print(i,end=",",flush=True)
print("\n\n")


for i in range(5,20,2):    # 5,7,9,11,13,15,17,19,
    print(i,end=",",flush=True)
print("\n\n")


for i in range(-5,-12,-3):    # -5,-8,-11,
    print(i,end=",",flush=True)
print("\n\n")


