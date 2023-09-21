#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_05b_FunctionArguments.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_05b_FunctionArguments.py
#
# Description: Demo for function calls with named parameter arguments as dicts
#
# Autor: Walter Rothlin
#
# History:
# 28-Nov-2021   Walter Rothlin      Initial Version
# 20-Sep-2023   Walter Rothlin      Added new examples for HBU
# ------------------------------------------------------------------
print('1) Function Calls')
print('=================')
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

print('\n\n')
print('2) Function Calls')
print('=================')
def function_1(a):
    print('function_1("' + str(a) + '")')


def summe(*values):
    sum = 0
    for summand in values:
        sum += summand
    return sum


def function_3(**key_values):
    print(key_values)


def func_super(a, b, *values, **key_values):
    print('func_super')
    print('a         :', a)
    print('b         :', b)
    print('values    :', values)
    print('key_values:', key_values)


# Main (Fct calls)
# ================
function_1('Hallo')

print(summe(123, 567, 10, -3))

function_3(a=5, b=6, c=7, end='Hallo')

func_super(('Hallo', 'HBU'), 555, 1, 2, 3, 4, aa=5, bb=6, c=7, end='Hallo')