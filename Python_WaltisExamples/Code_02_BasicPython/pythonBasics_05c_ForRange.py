#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_05c_ForRange.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_05c_ForRange.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

for i in range(11):
    print(i,end=" ")  # 0 1 2 3 4 5 6 7 8 9 10
print()

for i in range(5,8):
    print(i,end=" ")  # 5 6 7
print()

for i in range(5,12,2):
    print(i,end=" ")  # 5 7 9 11
print()

for i in range(-5,12,2):
    print(i,end=" ")  # -5 -3 -1 1 3 5 7 9 11
print()

for i in range(-5,-12,-3):
    print(i,end=" ")  # 
print()



for i in (1,2,3,4,5,6):
    print(i,end=" ")  # 1 2 3 4 5 6
print()

for i in (-1,2,-3,-4,5,6):
    print(i,end=" ")  # -1 2 -3 -4 5 6
print()
