#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_03_CheckConditionalOperators.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_03_CheckConditionalOperators.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

from __future__ import print_function
import sys

## execute under Windows:
## C:\Python38\python.exe G:\_Daten_2020_06_16\SourceCode\Python_Raspberry\BZU_Code_2020_03_11\ExamplesPython\Code_02_BasicPython\first.py

# Line Comment

"""
https://docs.python.org/3/tutorial/index.html Tutorial
https://www.heise.de/newsticker/meldung/Web-basierter-Python-Emulator-fuer-Raspi-Sense-HAT-3688279.html
https://trinket.io/sense-hat
https://www.raspberrypi.org/documentation/usage/python/
http://www.classthink.com/2013/09/15/getting-started-python-raspberry-pi/
https://www.youtube.com/watch?v=UUOCh0Cbty8
https://www.youtube.com/watch?v=41IO4Qe5Jzw LED ein und ausschalten

"""


# https://docs.python.org/3/tutorial/controlflow.html (Kapitel 4)

print("\n\n")
print("# functions")
print("# ---------")
def fib(n):    # write Fibonacci series up to n
    """Print a Fibonacci series up to n."""
    a, b = 0, 1
    while a < n:
        print(a, end=' ')
        a, b = b, a+b
    print()
 
# Now call the function we just defined:
fib(2000)

#---------------
def fib2(n):  # return Fibonacci series up to n
    """Return a list containing the Fibonacci series up to n."""
    result = []
    a, b = 0, 1
    while a < n:
        result.append(a)    # see below
        a, b = b, a+b
    return result
 
f100 = fib2(100)    # call it
print(f100)         # write the result [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]

#---------------
def ask_ok(prompt, retries=4, reminder='Please try again!'):
    print("retries:", retries, ":   reminder:", reminder)		
    while True:
        ok = raw_input(prompt).upper()
        print(ok)
        if ok in ('Y', 'YE', 'YES'):
            return True
        if ok in ('N', 'NO', 'NOP', 'NOPE'):
            return False
        retries = retries - 1
        if retries < 0:
            pass
            raise ValueError('invalid user response')
        print(reminder)

if ask_ok("Weiter: ",6, "Again"):
    print("Weiter!")
else:
    print("Trotzdem weiter!")

#---------------
print()
def f2(a, L=[]):
    L.append(a)
    return L

print(f2(1))
print(f2(2))
print(f2(3))

#---------------
print()
def f3(a, L=None):
    if L is None:
        L = []
    L.append(a)
    return L

print(f3(1))
print(f3(2))
print(f3(3))

#---------------
print()
def parrot(voltage, state='a stiff', action='voom', type='Norwegian Blue'):
    print("-- This parrot wouldn't", action, end=' ')
    print("if you put", voltage, "volts through it.")
    print("-- Lovely plumage, the", type)
    print("-- It's", state, "!")

parrot(1000)                                          # 1 positional argument
parrot(voltage=1000)                                  # 1 keyword argument
parrot(voltage=1000000, action='VOOOOOM')             # 2 keyword arguments
parrot(action='VOOOOOM', voltage=1000000)             # 2 keyword arguments
parrot('a million', 'bereft of life', 'jump')         # 3 positional arguments
parrot('a thousand', state='pushing up the daisies')  # 1 positional, 1 keyword

#---------------
print()
def cheeseshop(kind, *arguments, **keywords):
    print("-- Do you have any", kind, "?")
    print("-- I'm sorry, we're all out of", kind)
    for arg in arguments:
        print(arg)
    print("-" * 40)
    for kw in keywords:
        print(kw, ":", keywords[kw])

cheeseshop("Limburger", 
           "It's very runny, sir.",
           "It's really very, VERY runny, sir.",
           shopkeeper="Michael Palin",
           client="John Cleese",
           sketch="Cheese Shop Sketch")

#---------------
# 4.7.3. Arbitrary Argument Lists
print()
#def concat(*args, sep="/"):
#    return sep.join(args)

#print(concat("earth", "mars", "venus"))          # --> 'earth/mars/venus'
#print(concat("earth", "mars", "venus", sep=".")) # --> 'earth.mars.venus'


print(list(range(3, 6)))       # normal call with separate arguments        --> [3, 4, 5]
argList = [3, 6]
print(list(range(*argList)))   # call with arguments unpacked from a list   --> [3, 4, 5]

def parrot(voltage, state='a stiff', action='voom'):
    print("-- This parrot wouldn't", action, end=' ')
    print("if you put", voltage, "volts through it.", end=' ')
    print("E's", state, "!")

d = {"voltage": "four million", "state": "bleedin' demised", "action": "VOOM"}
parrot(**d)    #  -- This parrot wouldn't VOOM if you put four million volts through it. E's bleedin' demised !

def make_incrementor(n):
    return lambda x: x + n

f = make_incrementor(42)
print(f(0))   # --> 42
print(f(1))   # --> 43

pairs = [(1, 'one'), (2, 'two'), (3, 'three'), (4, 'four')]
pairs.sort(key=lambda pair: pair[1])
print(pairs)   # --> [(4, 'four'), (1, 'one'), (3, 'three'), (2, 'two')]


def my_function():
    """Do nothing, but document it.
    
        No, really, it doesn't do anything.
    """

print(my_function.__doc__)

#def f(ham: str, eggs: str = 'eggs') -> str:
#    print("Annotations:", f.__annotations__)
#    print("Arguments:", ham, eggs)
#    return ham + ' and ' + eggs

#print(f('spam'))




# http://www.pythonforbeginners.com/files/reading-and-writing-files-in-python (read and write to/from a file)
	
