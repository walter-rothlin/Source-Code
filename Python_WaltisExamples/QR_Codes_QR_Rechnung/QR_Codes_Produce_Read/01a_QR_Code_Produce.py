#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01a_QR_Code_Produce.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/QR_Codes_QR_Rechnung/QR_Codes_Produce_Read/01a_QR_Code_Produce.py
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
#
import qrcode

# Simple-Text
img = qrcode.make('Schoene Weihnachten 2023')
img.save('../QR-Codes_Images/01a_01_helloWorld.png')
print('../QR-Codes_Images/01a_01_helloWorld.png')
