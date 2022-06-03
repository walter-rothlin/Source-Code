#!/usr/bin/python3

# ------------------------------------------------------------------
# Name:  Library_A.py
# https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_BZU/2022/Library_A.py
#
# Description: Function Library
#
# Autor: Walter Rothlin
#
# 02-Jun-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import math

# Konstanten
# ==========
halbBogen = 180



# Bildschirmsteuerung
# ===================
def halt(prompt="Weiter?"):
    ants = input(prompt)


def isFloat(inputStirng):
    return inputStirng.replace('.', '', 1).replace('-', '', 1).isdigit()


# Umrechnungs-Funktionen
# ======================
def grad2Rad(grad):
    return math.pi * grad / halbBogen


def rad2Grad(rad):
    return halbBogen * rad / math.pi


def fahrenheit2Celsius(fahrenheit):
    return (fahrenheit - 32) / 1.8


def celsius2Fahrenheit(celsius):
    return (celsius * 1.8) + 32


def sin(x, einheit="rad"):     # 'deg'
    if einheit == "rad":
        return math.sin(x)
    else:
        return math.sin(grad2Rad(x))
