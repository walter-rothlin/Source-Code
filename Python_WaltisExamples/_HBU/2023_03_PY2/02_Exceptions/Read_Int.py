#!/usr/bin/python3

# ------------------------------------------------------------------
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_03_PY2/02_Exceptions/Read_Int.py
#
# Description: Beispiele
#
# Autor: Walter Rothlin
#
# History:
# 27-Nov-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
class TooMany_Tries(Exception):
    def __init__(self, *args):
        if args:
            self.message = args[0]
        else:
            self.message = 'Nothing to say'

    def __str__(self):
        return f'TooMany_Tries: {self.message}'



def read_int(prompt='int:', max_tries=None):
    if max_tries is None:
        tries = 100
    else:
        tries = max_tries

    has_error = True
    while has_error:
        value_str = input(prompt)

        try:
            value = int(value_str)
            has_error = False
        except ValueError:
            if max_tries is not None:
                tries -= 1
            print(f'ERROR: Kein Integer!  Versuche übrig:{tries}')
            if tries <= 0:
                raise TooMany_Tries('Very bad')

    return value

# ===========================================================
# MAIN
# ===========================================================
if __name__ == '__main__':
    do_loop = True
    while do_loop:
        try:
            radius = read_int('Radius:', max_tries=3)
        except TooMany_Tries:
            do_loop = False
        else:
            print(f'''Radius: {radius}     ==> Kreisfläche:{radius * radius * 3.1415926:3.2f}''')
