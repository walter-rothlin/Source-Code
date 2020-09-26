#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: support.py
#
# Description: Library - Module
#
# Autor: Walter Rothlin
#
# History:  
# 24-Oct-2017	Walter Rothlin		Initial Version
#
# ------------------------------------------------------------------
import math

# Bildschirmsteuerung
# -------------------
def VT52_cls():
	print("\033[2J",end="", flush=True)

def VT52_home():
	print("\033[H",end="", flush=True)

def VT52_cls_home():
    VT52_cls()
    VT52_home()

def halt():
    ant=input("Weiter?")

# Pysikalische Umrechnungen
# -------------------------
def grad2Rad(grad):
    return math.pi*grad/180

def rad2Grad(rad):
    return 180*rad/math.pi

def fahrenheit2Celsius(fahrenheit):
    return (fahrenheit-32)/1.8
	
def celsius2Fahrenheit(celsius):
    return (celsius*1.8)+32