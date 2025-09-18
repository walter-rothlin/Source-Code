#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Bruch_Rechner.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Fraction/Fraction_Calulator.py
#
# Description: Reference application for Class_Bruch
#
#
# Autor: Walter Rothlin
#
# History:
# 25-Jan-2021	Walter Rothlin  Initial Version
# 22-Nov-2023   Walter Rothlin  Implemented TBI 21.11.23
#
# ------------------------------------------------------------------
from Class_Fraction import *
import pydoc


def unterstreichen(text, char='='):
    print(text)
    print(char * len(text))
    return text


bruch_1 = Fraction(bruch_str='[8/11]')
print(bruch_1)

bruch_1.nenner = 15
bruch_1.name = "Bruch 1"
print(bruch_1, bruch_1.name)


bruch_1 = Fraction(9, 10)
print(bruch_1)


print(Fraction.unterstreichen('von Klasse', '?'))
Fraction.do_trace=False

bruch_2 = Fraction(55, 100)
print(bruch_1)

"""
print(unterstreichen("Help für Class Fraction via help()"))
help(Fraction)
print('\n\n')

print(unterstreichen("Help für Class Fraction via render_doc()"))
hilfe_text = pydoc.render_doc(Fraction, title="Hilfe für %s")
print(hilfe_text)     # zeigt den Help-Text
print('\n\n')


print('=============================')
print(bruch_1.to_decimal.__doc__)
"""