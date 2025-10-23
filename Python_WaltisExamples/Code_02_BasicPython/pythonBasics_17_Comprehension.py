#!/usr/bin/python

# ------------------------------------------------------------------
# Name  : pythonBasics_17_Comprehension.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_17_Comprehension.py
#
#
# Description: Examples with Comprehensions
#  https://www.w3schools.com/python/python_lists_comprehension.asp
#
# Autor: Walter Rothlin
#
# History:
# 10-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
fruits = ["apple", "banana", "cherry", "kiwi", "mango"]
# ------------------------------------------------------------------
# classic way
newlist = []
for x in fruits:
  if "a" in x:
    newlist.append(x)
print("classic way:", fruits, newlist, sep="\n")
print()

# with comprehension
newlist = [x for x in fruits if "a" in x]
print("comprehension:", fruits, newlist, sep="\n")
print()

# ------------------------------------------------------------------
my_list_a = ['hallo', 'welt', 'hi', 'hoi', 'kurt']
my_list_b = [456, 3425, 234, 1234, 700]
# ------------------------------------------------------------------
print("a:", my_list_a)
print("b:", my_list_b)
print()

# sub-listen with steps
print("b[0:-1:2]:", my_list_b[0:-1:2])
print()

# zip creates tuples
for aElement in zip(range(len(my_list_a)), my_list_a):
  print("      zipped tuples:", aElement)
print()


print("list:", [str(i) + ":" + string_in_list for i,  string_in_list in zip(range(len(my_list_a)), my_list_a)])
print("list:", [str(int_in_list) + ":" + string_in_list for int_in_list,  string_in_list in zip(my_list_b, my_list_a)])
print("list:", [string_in_list for string_in_list in my_list_a if string_in_list[0] == 'h'])
print("list:", [string_in_list for string_in_list in my_list_a if string_in_list[0] != 'h'])
print("dict:", {a : b for a, b in zip(my_list_a, my_list_b)})
print("sets:", {a     for a, b in zip(my_list_a, my_list_b)})

# weitere comprehension siehe waltisLibrary.py under Symetrische Cryptographie
