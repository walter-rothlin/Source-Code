#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01_Listen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/01_Listen.py
#
# Description: Listen und Listen Operationen.
#
# Autor: Walter Rothlin
#
# History:
# 04-Sep-2023   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
from waltisMegaLib import *

eine_liste = [34, 67, 12, 56, 78.8, 'Hallo', 'HBU', True]

print(eine_liste)

print('len(',eine_liste,') =', len(eine_liste))
print('eine_liste[2] =', eine_liste[2])
for a_list_element in eine_liste:
    print(a_list_element)

eine_liste.append('Uster')
print('eine_liste  :', eine_liste)

andere_liste = eine_liste
print('andere_liste:', andere_liste)

andere_liste.append('Referenz')
print('eine_liste  :', eine_liste)
print('andere_liste:', andere_liste)

noch_eine_liste = eine_liste.copy()
noch_eine_liste.append('Clone')
print('noch_eine_liste:', noch_eine_liste)
print('eine_liste     :', eine_liste)

print()
print('eine_liste[5:7]:', eine_liste[5:7])
print('eine_liste[0:7]:', eine_liste[0:7])
print('eine_liste[:7] :', eine_liste[:7])

print('eine_liste[len()-1] :', eine_liste[len(eine_liste)-1])
print('eine_liste[-1]      :', eine_liste[-1])

print('eine_liste[2:-2]    :', eine_liste[2:-2])
print('eine_liste[-4:-2]   :', eine_liste[-4:-2])

print()
eine_liste.extend(eine_liste[-4:-2])
print(eine_liste)

print()
eine_liste.append(eine_liste[-4:-2])
print(eine_liste)
print(eine_liste[-1][0])


for i, a_value in enumerate(eine_liste):
    print(i, a_value)
    


print()
print()
print('Comprehensions')
fruits = ['apple', 'banana', 'cherry', 'kiwi', 'mango']
print(fruits)

a_fruits = []
for a_fruit in fruits:
    if 'a' in a_fruit:
        a_fruits.append(a_fruit)
        
print(a_fruits)

a_new_fruits_list = [a_fruit for a_fruit in fruits if 'a' in a_fruit]
print(a_new_fruits_list)

print()
print()
print('String operations')
vorname = 'Walti Rothlin'
print(vorname, len(vorname), vorname[3], vorname[:3])
#  vorname.insert = 'T'   # strings sind nicht mutierbar!
#  print(vorname, len(vorname), vorname[3], vorname[:3])

print()
print()
print('zip with comprehensions')
fruits = ['apple', 'banana', 'cherry', 'kiwi', 'mango', 'plumbs']
prices = [12.3,     5.6,      2.3,     5.6,    7.5,     10.0]

for a_element in zip(fruits, prices):
    print('Preis:' + str(a_element[1]) + '    Frucht:' + a_element[0])
