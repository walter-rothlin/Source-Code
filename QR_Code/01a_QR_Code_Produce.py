#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01a_QR_Code_Produce.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/QR_Code/01a_QR_Code_Produce.py
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
#  VORSICHT: PyCharm installiert falsches Module! Manuel installieren über Terminal:
#  pip install qrcode[pil]
#
# ev muss vorher pip updated werden (via Terminal): python -m pip install --upgrade pip

import qrcode

# Simple-Text
img = qrcode.make('Hallo World!!!!')
img.save('QR-CodesImages/01a_01_helloWorld.png')
print('QR-CodesImages/01a_01_helloWorld.png')
