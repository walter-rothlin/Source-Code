
#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: umrechnungen.py
#
# Description: Rechnet verschiedene physikalische Grössen um.
#
# Autor: Walter Rothlin
#
# History:
# 01-Feb-2025   Walter Rothlin      Initial Version (Menu-Text)
# 14-Feb-2025   Walter Rothlin      Added Constants and Functions
# 07-Mar-2025   Walter Rothlin      Added read_float()
# 14-Mar-2025   Walter Rothlin      read_float() erweitern um min, max
# 21-Mar-2025   Walter Rothlin      Added read_int()
# ------------------------------------------------------------------

import re

# ----------------------------
# Constants
# ----------------------------
pi = 3.1415926

# ----------------------------
# Variables

menu_text = f'''
Umrechnungen
============
  1: Grad in Bogenmass   rad  = grad*pi/180
  2: Bogenmass in Grad   grad = rad*180/pi

  3: Fahrenheit in Celsius   32F -> 0°C    100F -> 37.778°C     °C = (°F - 32) / 1.8
  4: Celsius in Fahrenheit   32F -> 0°C    100F -> 37.778°C     °F = (°C * 1.8) - 32

  0: Schluss
'''

# ----------------------------
# Functions
# ----------------------------
def grad_in_bogenmass(grad_value):
    return grad_value * pi / 180

def bogenmass_in_grad(rad_value):
    return rad_value * 180 / pi

def fahrenheit_in_celsius(fahrenheit_value):
    return (fahrenheit_value - 32) / 1.8

def celsius_in_fahrenheit(celsius_value):
    return (celsius_value * 1.8) + 32

def read_float_Precondition(prompt, min=None, max=None):
    error = True
    while error:
        in_str = input(prompt)
        in_str = in_str.replace(",", ".")
        in_str = in_str.replace(" ", "")
        in_str = in_str.replace("\t", "")
        in_str = in_str.replace("'", "")
        if re.fullmatch(r"^-?\d+(?:\.\d+)?$", in_str):
            in_value = float(in_str)
            if min is not None and in_value < min:
                print(f"Error (pre-test): '{in_str}' is smaller than {min}")
                error = True
            elif max is not None and in_value > max:
                print(f"Error (pre-test): '{in_str}' is greater than {max}")
                error = True
            else:
                error = False
        else:
            print(f"Error (pre-test): '{in_str}' is not a valid float")
            error = True
    return in_value


def read_float_exception(prompt, min=None, max=None):
    error = True
    while error:
        try:
            in_str = input(prompt)
            in_str = in_str.replace(",", ".")
            in_str = in_str.replace(" ", "")
            in_str = in_str.replace("\t", "")
            in_str = in_str.replace("'", "")
            in_value = float(in_str)
            if min is not None and in_value < min:
                print(f"Error (try-except): '{in_str}' is smaller than {min}")
                error = True
            elif max is not None and in_value > max:
                print(f"Error (try-except): '{in_str}' is greater than {max}")
                error = True
            else:
                error = False
        except ValueError:
            print(f"Error (try-except): '{in_str}' is not a valid float")
            error = True
    return in_value

def read_float(prompt, min=None, max=None, method="exception"):
    if method == "pre":
        return read_float_Precondition(prompt, min=min, max=max)
    else:
        return read_float_exception(prompt, min=min, max=max)

def read_int(prompt, min=None, max=None):
    error = True
    while error:
        try:
            in_str = input(prompt)
            in_str = in_str.replace(" ", "")
            in_str = in_str.replace("\t", "")
            in_str = in_str.replace("'", "")
            in_value = int(in_str)
            if min is not None and in_value < min:
                print(f"Error read_int(): '{in_str}' is smaller than {min}")
                error = True
            elif max is not None and in_value > max:
                print(f"Error read_int(): '{in_str}' is greater than {max}")
                error = True
            else:
                error = False
        except ValueError:
            print(f"Error read_int(): '{in_str}' is not a valid int")
            error = True
    return in_value

def read_boolean(prompt):
    error = True
    while error:
        in_str = input(prompt)
        in_str = in_str.replace(" ", "")
        in_str = in_str.replace("\t", "")
        if in_str.lower()[0] in ["t", "j", "y", "1"]:
            return True
        elif in_str.lower()[0] in ["f", "n", "0"]:
            return False
        else:
            print(f"Error read_boolean(): '{in_str}' is not a valid boolean")
            error = True

# ----------------------------
# Main:
# ----------------------------
do_loop = True
while do_loop:
    print(menu_text)

    auswahl = read_int('Wahl:',min=0,max=4)
    if auswahl == '1':
        print("Grad in Bogenmass")
        grad = read_float("Grad:", min=-360, max=360)
        rad = grad_in_bogenmass(grad)
        print(f"{grad:0.2f} Grad sind {rad:0.2f} rad")

    elif auswahl == '2':
        print("Bogenmass in Grad")
        rad = read_float("rad:", method="pre", min=-10, max=10)
        grad = bogenmass_in_grad(rad)
        print(f"{rad:0.2f} rad sind {grad:0.2f} Grad")

    elif auswahl == '3':
        print("Fahrenheit in Celsius")
        fahrenheit = read_float("Fahrenheit:")
        celsius = fahrenheit_in_celsius(fahrenheit)
        print(f"{fahrenheit:0.2f} Fahrenheit sind {celsius:0.2f} Celsius")

    elif auswahl == '4':
        print("Celsius in Fahrenheit")
        celsius = read_float("Celsius:")
        fahrenheit = celsius_in_fahrenheit(celsius)
        print(f"{celsius:0.2f} Celsius sind {fahrenheit:0.2f} Fahrenheit")

    elif auswahl == '0':
        print("Schluss")
        do_loop = False
    else:
        print("Falsche Eingabe")
print("Tschüss")



