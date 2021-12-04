#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_05b_FunctionCalls.py
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
# ------------------------------------------------------------------
import math


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


possibles = globals().copy()
print("possibles:", possibles)
possibles.update(locals())
print("possibles:", possibles)

fctToCall = "sayHello"
# method = possibles.get(fctToCall)
method = possibles[fctToCall]
if not method:
    print(fctToCall + " not found")
else:
    print(method("Rothlin"))

possibles = globals().copy()
print("possibles:", possibles)
