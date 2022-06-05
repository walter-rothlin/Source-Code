#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01a_QR_Code_Read.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/QR_Code/01a_QR_Code_Read.py
#
#
# Description: Decodes an QR-Code using cv2 module
# https://towardsdatascience.com/create-and-read-qr-code-using-python-9fc73376a8f9
#
#
# Autor: Walter Rothlin
#
# History:
# 03-Jan-2022   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
# ------------------------------------------------------------------
#  VORSICHT: PyCharm installiert falsches Module! Manuel installieren über Terminal:
#  ev muss vorher pip updated werden (via Terminal):
#  python -m pip install --upgrade pip oder
#    pyCharm --> File --> Settings --> Project:Source Code --> Python Interpreter
#  pip install opencv-python
#
import cv2

img = cv2.imread('../QR-Codes_Images/01a_01_helloWorld.png')

det = cv2.QRCodeDetector()
val, pts, st_code = det.detectAndDecode(img)
print("reading from 01a_01_helloWorld.png:", val)
