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
    print("a = ", a)


def func2(*values):
    print("values = ", values)


def func3(**keyValues):
    print("keyValues = ", keyValues)


def func4(a, *values):
    print("a = ", a, "values = ", values)


def func5(*values, **keyValues):
    print("values = ", values, "keyValues = ", keyValues)


def func6(a, *values, **keyValues):
    print("a = ", a, "values = ", values, "keyValues = ", keyValues)


def func7(**keyValues):
    for key in [*keyValues]:
        print(key, sep=";", end="")

    print()

    for key in keyValues.keys():
        print(key, sep=";", end="")


func1(5)
func2(1, 2, 3, 4, 5, 6)
func3(a=5, b=6, c=7)
func4(5, 6, 7, 8, 9, 10)
func5(5, 8, a=5, b=3)
func6(2, 5, 6, 7, 8, b=6, c=7)
func7(a=1, b=2, c=3, d=4, e=5)
