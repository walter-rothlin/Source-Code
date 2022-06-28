#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : FunctionCalls.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HWZ/BWI_A21/FunctionCalls.py
#
# Description:
#
#
# Autor: Walter Rothlin
#
# History:
# 28-Jun-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

def func1(a, b=""):
    print(a, b)

func1(567)
func1(567, "Hallo")
func1(b="Hallo", a=456)
func1(456, b="Hallo")

def func2(a, *values):
    print(a)
    for aElement in values:
        print(aElement, " ; ", sep="",  end="")
    print("\n\n")

func2("Hallo",234, "HWZ", "BWI-A21")
func2("Hallo", 234)
print("\n\n")

def func3(a, *values, **keyValues):
    print("a:", a)
    print("values:", values)
    print("keyValues:", keyValues)

func3(45, 1,2,3,value=4, name='Rothlin', vorname='Walti')
func3("Zurich", lastName="Mueller", firstName="Felix")
