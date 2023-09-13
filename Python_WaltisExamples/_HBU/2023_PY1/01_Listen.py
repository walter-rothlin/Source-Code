#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01_Listen.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_PY1/01_Listen.py
#
# Description: Beispiele von Listen und Operationen
#
# Autor: Walter Rothlin
#
# History:
# 06-Sep-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from waltiSuperLib import *

eine_liste = [123, 678, [987, 12.3, 7896], 23, 'Hallo', True]



print(eine_liste, len(eine_liste), eine_liste[2])
print(eine_liste[len(eine_liste)-1], eine_liste[-1], eine_liste[-2])
print('12.3=', eine_liste[2][1])

eine_liste.append('Referenz')
# print(eine_liste[-17])  # IndexError: list index out of range

for a_list_element in eine_liste:
    print('   ->', a_list_element)
    


eine_liste = [123, 678, [987, 12.3, 7896], 23, 'Hallo', True]
zweite_liste = eine_liste
print(eine_liste)
print(zweite_liste)

zweite_liste.append('Referenz')
print(eine_liste)
print(zweite_liste)

zweite_liste = eine_liste.copy()
zweite_liste.append('Clone')
print(eine_liste)
print(zweite_liste)

eine_liste = [123, 678, [987, 12.3, 7896], 23, 'Hallo', True]
zweite_liste = [1, 2, 3, 4]
eine_liste.extend(zweite_liste)
print(eine_liste)
print(zweite_liste)

print('\nRanges')
eine_liste = [123, 678, 987, 12.3, 7896, 23, 'Hallo', True]
print(eine_liste[-4:-2])

print('\nEnumerations')
for i, a_value in enumerate(eine_liste):
    print(i, a_value)

a_string = 'Walter Rothlin'
print(a_string[2:-1])


print()
print()
print('Comprehensions')
fruits = ['apple', 'banana', 'cherry', 'kiwi', 'mango']


a_fruits = []
for  a_fruit in fruits:
    if 'a' in a_fruit:
        a_fruits.append(a_fruit)
        
print('fruits  :', fruits)
print('a_fruits:', a_fruits)

a_new_sub_liste = [a_fruit for a_fruit in fruits if 'a' in a_fruit]
print(a_new_sub_liste)

print('\n\nZip with comprehensions')
fruits = ['apple', 'banana', 'cherry', 'kiwi', 'mango', 'pinaple']
prices = [1.20,    2.30,     4.50,      3.10,  9.20]
for a_element in zip(fruits, prices):
     print('Price:', a_element[1], '   Fruit:', a_element[0])
