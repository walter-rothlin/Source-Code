#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_05b_FunctionCalls.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_05b_FunctionCalls.py
#
# Description: Demo for function calls with optional arguments. By Name By Position
#
# Autor: Walter Rothlin
#
# History:
# 25-Sep-2020   Walter Rothlin      Initial Version
# 27-Sep-2020   Walter Rothlin      Added to GitHub
# 19-Oct-2021   Walter Rothlin      Changes for BWI-A20
# 12-Dec-2021   Walter Rothlin      Added examples with Type Hints
# 03-Jul-2022   Walter Rothlin      Added examples * and ** Parameters
# ------------------------------------------------------------------
import math

# Positional and Named Arguments
def func1(a, b=""):
    print(a, b)

def Test_func1():
    func1(567)
    func1(567, "Hallo")
    func1(b="Hallo", a=456)
    func1(456, b="Hallo")


# Listen Argumente
def func2(a, *values):
    print(a)
    for aElement in values:
        print(aElement, " ; ", sep="",  end="")
    print("\n\n")

def Test_func2():
    func2("Hallo", 234, "HWZ", "BWI-A21")
    func2("Hallo", 234)
    print("\n\n")


# Dictonary Argumente
def func3(a, *values, **keyValues):
    print("a:", a)
    print("values:", values)
    print("keyValues:", keyValues)

def Test_func3():
    func3(45, 1, 2, 3, value=4, name='Rothlin', vorname='Walti')
    func3("Zurich", lastName="Mueller", firstName="Felix")


# Optionale Parameters am Schluss anhängen und ein Default-Wert zuweisen.
# So wird overloading in Python gemacht!
def sayHello(firstname=None, anrede="Hallo"):
    if firstname is None:
        return anrede
    else:
        return anrede + " " + firstname

# With Type Hints
def sayHelloWithTypeHints(firstname : str = None, anrede : str = "Hallo") -> str:
    if firstname is None:
        return anrede
    else:
        return anrede + " " + firstname

# =============
# Hauptprogramm
# =============
if __name__ == '__main__':
    Test_func1()
    Test_func2()
    Test_func3()

    # Print-Function / Format-Strings
    print("Hello\n", "World!!!")
    summand_1 = 43.45
    summand_2 = 7.27
    print(summand_1, "+", summand_2, "=", summand_1 + summand_2, sep=" ", end='\n')
    print(summand_1, "-", summand_2, "=", summand_1 - summand_2, sep=" ", end="\n")
    print('{s1:5.3f} - {s2:5.1f} = {summe:5.1f}'.format(s2=summand_2, summe=summand_1 - summand_2, s1=summand_1))

    # Function call (Named / Positional Arguments
    print(sayHello(), "::", sep="")
    print(sayHello("HWZ"), "::", sep="")
    print(sayHello(firstname="Marco", anrede="Bonjour"), "::", sep="")


    # Excape character
    print("---> Escape Character")
    print('sayHello("Franz")')
    print('sayHello("Franz\"")')
    print('sayHello("Franz\\")')

    # Indirect calls
    print("---> Indirect calls")
    print(summand_1/summand_2)
    print(eval("summand_1/summand_2"))
    print(eval("sayHello('Hans')"))
    print(eval('sayHello("Fra\\\z")'))
    print(eval('sayHello("Franz\\\\")'))
    print(eval('sayHello("Franz\\"", anrede="Guten Morgen")'))

