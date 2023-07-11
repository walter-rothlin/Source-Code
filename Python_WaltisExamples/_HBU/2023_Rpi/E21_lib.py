#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : E21_lib.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/E21_lib.py
#
# Description: Library entwickelt für E21 der HFU.
#
# Autor: Walter Rothlin
#
# History:
# 10-Jul-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

pi = 3.14159267
halbbogen = 180

def input_float(prompt='Grad:', severity='ERROR', err_msg='Falsches Format für einen Float!!!!',
                min_value=None, err_msg_to_small='Wert ist zu klein',
                max_value=None, err_msg_to_high='Wert ist zu gross'):

    has_error = True
    while has_error:
        value_string = input(prompt)
        try:
            value = float(value_string)
            if min_value is not None and value < min_value:
                print(severity + ": " + value_string + '   ' + err_msg_to_small + ' Min:' + str(min_value))
            elif max_value is not None and value > max_value:
                print(severity + ": " + value_string + '   ' + err_msg_to_high + '  Max:' + str(max_value))
            else:
                has_error = False
        except Exception:
            print(severity + ": " + value_string + '   ' + err_msg)

    return value

def TEST_input_float():
    res_val = input_float()
    print(res_val)

    res_val = input_float(prompt='Rad:', severity='WARNING', err_msg='Wrong format for float!!!!',
               min_value=0, err_msg_to_small='value is to small',
               max_value=100, err_msg_to_high='value is to big')
    print(res_val)


def grad_to_rad(grad_wert):
    return grad_wert * pi / halbbogen

def rad_to_grad(rad_wert):
    return rad_wert * halbbogen / pi

def halt():
    return input('Weiter?')

def cls():
    print('\n\n\n\n')

if __name__ == '__main__':
    TEST_input_float()
