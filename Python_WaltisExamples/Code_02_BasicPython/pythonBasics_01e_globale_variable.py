#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_01e_globale_variable.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01e_globale_variable.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 26-Nov-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

counter = 0

counter += 2

def inc():
    global counter
    print(counter)
    counter += 5
    print(counter)



inc()

