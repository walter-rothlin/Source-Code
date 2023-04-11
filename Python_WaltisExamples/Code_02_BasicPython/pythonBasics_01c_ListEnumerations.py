#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_01c_ListEnumerations.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01c_ListEnumerations.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 07-Apr-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

values = ['aa', 'ab', 'ac', 'ad', 'ae', 'af', 'ag']
print("\n\n With enumerate:")
for i, value in enumerate(values):
    print(i, ":", value)

print("\n\n With zipped comprehension returning single values:")
for i, value in zip(range(len(values)), values):
  print(i, ":", value)


print("\n\n With zipped comprehension returning a tuple:")
for value in zip(range(len(values)), values):
  print(value)
