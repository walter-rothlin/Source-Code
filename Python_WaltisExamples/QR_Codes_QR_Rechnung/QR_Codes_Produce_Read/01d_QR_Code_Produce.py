#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01b_QR_Code_Produce.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/QR_Code/01b_QR_Code_Produce.py
#
# Description: Generates a QR-Code using qrcode module
# https://towardsdatascience.com/create-and-read-qr-code-using-python-9fc73376a8f9
#
#
# Autor: Walter Rothlin
#
# History:
# 03-Jan-2022   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
from waltisLibrary import *
import qrcode

qr_valueText = input("QR-Value:")
filename = '../QR-Codes_Images/01b_helloWorld.png'

img = qrcode.make(qr_valueText)
img.save(filename)
print("QR-Code saved: ", filename)
