#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 03_03_fct_calls.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_PY1/03_03_fct_calls.py
#
# Description: Beispiele für fct calls
#
# Autor: Walter Rothlin
#
# History:
# 20-Sep-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
print('Function Calls')
print('==============')

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