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
# 18-Sep-2025   Walter Rothlin      Added new examples for HBU
# ------------------------------------------------------------------

trenner = '-' * 80

print('1) Function Calls')
print('=================')
def func1(a):
    print(f"1) func1({a})")

func1(5)
func1(a=5)
func1((10, 6, 9))
func1({'Anrede': 'Hallo', 'b': 5})
print(trenner, "\n")


print('2) Function Calls with variable number of arguments')
print('===================================================')
def func2(*values):
    print(f"2) func2(*values) ==> func2{values}")
    for v in values:
        print(f"   Value: {v}")
    print(f'   {values[-1]} is the last value')


func2(5, 7 , 8)
func2(5, 7 , 8, 9.0, 10, "Uster", 12)
print('\n')


def summe(*values):
    sum_value = 0
    for v in values:
        sum_value += v
    return sum_value

print(f"2) summe(5, 7 , 8) = {summe(5, 7 , 8)}")

def average(*values, round_result=False):
    sum_value = 0
    for v in values:
        sum_value += v
    if round_result:
        return round(sum_value/len(values), 2)
    else:
        return sum_value/len(values)

print(f"2) average(5, 7 , 8) = {average(5, 7 , 8)}")
print(f"2) average(5, 7 , 8) = {average(5, 7 , 8, round_result=True)}")
print(trenner, "\n")


print('3) Function calls with variable number of named arguments')
print('=========================================================')
def func3(**keyValues):
    print(f"3) func3(**keyValues)  ==> func3{keyValues}")

func3(pi=3.1415, e=2.78)
func3(m=3.1415, c=2.788888)
print(trenner, "\n")



print('4) Function Calls with variable number of named arguments and normal arguments')
print('==============================================================================')
def func4(first_name, *values):
    print(f"4) func4(first_name, *values)  ===> first_name={first_name}, values={values}")

func4('Hallo', 1, 2, 3, 4, 5)
print(trenner, "\n")


print('5) Function Calls with variable number of named arguments and normal arguments')
print('==============================================================================')
def func5(first_name, **keyValues):
    print(f"5) func5(first_name, **keyValues)  ===> first_name={first_name}, keyValues={keyValues}")

func5('Hallo', a=1, b=2, c=3, d=4, e=5)
print(trenner, "\n")

print('6) Function Calls with normal arguments, variable number of named arguments and normal arguments')
print('==============================================================================')
def func6(a, *values, **keyValues):
    print(f"6) func6(a, *values, **keyValues) ===> a={a}, values={values}, keyValues={keyValues}")

func6('Peter', 1, 2, 3, 4, 5, pi=3.1415, e=2.78)
print(trenner, "\n")

