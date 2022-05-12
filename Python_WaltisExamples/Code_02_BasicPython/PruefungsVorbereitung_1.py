#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: PruefungsVorbereitung_1.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicsPython/PruefungsVorbereitung_1.py

#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 01-Apr-2022	Walter Rothlin		Initial Version
# 07-Apr-2022	Tobias Rothlin		Eigene Functions mit Parametern
#
# ------------------------------------------------------------------

#Daten Typen
myString = "Hal'\"lo"
myString = '"' + "Hallo" + '"'
myString = 'Hallo'
myString = 'Hal\nlo'
myString = '''
Hallo BZU
Hallo Uster
'''

myInt = 15
myFloat = 15.63234
myBool = False
myIntAsString = str(myInt)
myFloatAsInt = int(myFloat)
myNumberString = "115"
myStringAsInt = int(myNumberString)
myStringAsFloat = float(myNumberString)
print(myStringAsFloat)

#Var Namen
print(myNumberString)

#print()
print(146.3)
print(146.3, 12355, 124, 5, 2123, sep="|",                   end=":")
print(1245)
print(2+3*2)
print(100*".")

#input()

#F Strings
print("hallo {a:06.2f} {b:06.2f} {c:06.2f}.".format(a=15.3, b=3.12645, c=2.5236))
print("hallo {a:06.2f} {b:06.2f} {c:06.2f}.".format(a=150.3, b=139.12445, c=420.5236))

#Mathematische Operationen
a = 15.3
b = 64
c = 2
c += 1
c = b**(c)
print(c)
#Boolische Operationen
a = 11
print(a <= 0 or a >= 10)



#Funktionen
def myfunction(a,myOpParameter=0):
    return a + myOpParameter


print(myfunction(myOpParameter=23, a=20))
#Code Analyse

