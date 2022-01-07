#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01b_QR_Code_Read.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/QR_Code/01b_QR_Code_Read.py
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
import cv2

img = cv2.imread('QR-CodesImages/01a_01_helloWorld.png')

det = cv2.QRCodeDetector()
val, pts, st_code = det.detectAndDecode(img)
print(val)
