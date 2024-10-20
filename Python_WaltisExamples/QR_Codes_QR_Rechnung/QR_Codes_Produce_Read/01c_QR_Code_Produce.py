#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01c_QR_Code_Produce.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/QR_Codes_QR_Rechnung/QR_Codes_Produce_Read/01c_QR_Code_Produce.py
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

qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_L,
    box_size=10,
    border=4,
)
qr.add_data("https://www.fh-hwz.ch/")
qr.make(fit=True)
img = qr.make_image(fill_color="red", back_color="black")
img.save("../QR-Codes_Images/01c_hwzLink.png")
