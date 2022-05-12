#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_06_Input.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_06_Input.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

print("\n\n")
print("# read from stty")
print("# --------------")

# python3 is input instead of raw_input
name = input("What's your name? ")
print("Nice to meet you " + name + "!")
age = int(input("What is your age? "))
print("So " + name + ", you are already " + str(age) + " years old!")
print("name:   value:", name, "    type:", type(name))
print("age :   value:", age , "    type:", type(age))
print("\n")

calcStr = input("Rechnung (z.B. 5*6-2): ")
print(calcStr, " = ", eval(calcStr))

