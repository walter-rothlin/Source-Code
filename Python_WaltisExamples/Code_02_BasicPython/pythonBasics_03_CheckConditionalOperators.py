#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_01c_ListDict.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01c_ListDict.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

testFunctionExecuted=False

def testFunction():
    testFunctionExecuted=True
    return True;

if (True or testFunction()):
    if (testFunctionExecuted):
        print("Test Function executed: working like Java '|' and '&'")
    else:
        print("Test Function not executed: working like Java '||' and '&&'")