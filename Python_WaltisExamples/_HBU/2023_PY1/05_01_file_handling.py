#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 05_01_file_handling.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_PY1/05_01_file_handling.py
#
# Description: Filehandling
#
# Autor: Walter Rothlin
#
# History:
# 27-Sep-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
file_name = 'test.txt'

def halt():
    return input('Weiter?')


print('File schreiben')
print('==============')
a_text = '''
Hallo HBU
in Uster äöü
'''
f = open(file_name, 'w', encoding='utf-8')
f.write(a_text)
f.close()


f = open(file_name, 'a', encoding='utf-8')
f.write(a_text)
f.close()


print('\n\n\n')
print('File lesen')
print('==========')
f = open(file_name, 'r', encoding='utf-8')
file_content = f.readlines()
f.close()
print(file_content)

print('\n\n\n')
with open(file_name, 'r', encoding='utf-8') as f:
    first_line = f.readline()
    print('first_line:', first_line, ':')
    

print('\n\n\n')
f = open(file_name, 'r', encoding='utf-8')
line_number = 0
for a_line in f:
    line_number += 1
    print(line_number, ':', a_line, end='')
    

print('\n\n\n')
f = open(file_name, 'r', encoding='utf-8')
ersten_5_zeichen = f.read(5)
ersten_6_zeichen = f.read(6)
print('ersten_5_zeichen:', ersten_5_zeichen)
print('ersten_6_zeichen:', ersten_6_zeichen)

halt()

import os
if os.path.exists(file_name):
    os.remove(file_name)
    print(file_name, 'has been deleted!!!')
else:
    print(file_name, 'does not exist')

os.remove(file_name)