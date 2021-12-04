#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_05b_FunctionArguments.py
#
# Description: Demo for function calls with named parameter arguments as dicts
#
# Autor: Walter Rothlin
#
# History:
# 28-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
def func1(a):
    print("1) func1(a)                       -> func1(5)                       ===> a = ", a)


def func2(*values):
    print("2) func2(*values)                 -> func2(1, 2, 3, 4, 5, 6)        ===> values    = ", values)


def func3(**keyValues):
    print("3) func3(**keyValues)             -> func3(a=5, b=6, c=7)           ===> keyValues = ", keyValues)


def func4(a, *values):
    print("4) func4(a, *values)              -> func4(5, 6, 7, 8, 9, 10)       ===> a = ", a, "values = ", values)


def func5(*values, **keyValues):
    print("5) func5(*values, **keyValues)    -> func5(5, 8, a=5, b=3)          ===> values = ", values, "keyValues = ", keyValues)


def func6(a, *values, **keyValues):
    print("6) func6(a, *values, **keyValues) -> func6(2, 5, 6, 7, 8, b=6, c=7) ===> a = ", a, "values = ", values, "keyValues = ", keyValues)


def func7(**keyValues):
    print()
    print("  7a) ", end="")
    for key in [*keyValues]:
        print(key, sep=";", end="")

    print()
    print("  7b) ", end="")
    for key in keyValues.keys():
        print(key, sep=";", end="")


func1(5)
func2(1, 2, 3, 4, 5, 6)
func3(a=5, b=6, c=7)
func4(5, 6, 7, 8, 9, 10)
func5(5, 8, a=5, b=3)
func6(2, 5, 6, 7, 8, b=6, c=7)
func7(a=1, b=2, c=3, d=4, e=5)
