#!/usr/bin/python3

file_name = '../test.txt'
def halt():
    return input('Weiter?')

print('File schreiben')
print('==============')

a_text = '''Hallo HBU
in Uster öäü
'''

f = open(file_name, 'w', encoding='utf-8')
f.write(a_text)
f.write(a_text)
f.write('Guten ')
f.write('Abend!\n')
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
for a_line in file_content:
    print(a_line, end='')


print('\n\n\n')
with open(file_name, 'r', encoding='utf-8') as f:
    first_line = f.readline()
    print(f'first_line:{first_line}')

print('\n\n\n')
with open(file_name, 'r', encoding='utf-8') as f:
    all_lines = f.read()
    print(f'all_lines:{all_lines}')

print('\n\n\n')
f = open(file_name, 'r', encoding='utf-8')
line_number = 0
for a_line in f:
    line_number += 1
    print(f'{line_number:2d}:{a_line}', end='')
f.close()

halt()

import os

if os.path.exists(file_name):
    print(f'File {file_name} exists!')
    os.remove(file_name)
else:
    print(f'File {file_name} NOT exists!')



