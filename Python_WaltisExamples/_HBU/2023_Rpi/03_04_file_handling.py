#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 03_04_file_handling.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/03_04_file_handling
#
# Description: File lesen und schreiben
#
# Autor: Walter Rothlin
#
# History:
#25-Sep-2023   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
import os

def halt():
   input('weiter?')
   
   

filename = 'test_01.txt'
print('File schreiben')
print('==============')
text = '''
   Hallo BZU!
   Uster
'''
f = open(filename, 'w')
f.write(text)
f.close()

print('file written:',filename)
f = open(filename, 'a')
f.write(text)
f.close()

print()
print('File lesen (1)')
print('==============')
f = open(filename, "r")
z_no = 0
for line in f:
    print(z_no,':',line, end='')
    z_no += 1
f.close()


print()
print('File lesen (2)')
print('==============')
f = open(filename, "r")
print("Die ersten   5 Zeichen vom File:", f.read(10))
print("Die nächsten 6 Zeichen vom File:", f.read(6))
print("Die naechste Zeile:", f.readline(), end="")
f.close()


print()
print('File lesen (3)')
print('==============')
f = open(filename, "r")
filecontent = f.readlines()
print("filecontent:", filecontent)
f.close()

print()
print('File lesen (4)')
print('==============')
with open(filename, "r") as f:
    filecontent = f.readlines()

print("filecontent:", filecontent)
f.close()

halt()

if os.path.exists(filename):
    os.remove(filename)
    print(filename, 'has been removed!')
