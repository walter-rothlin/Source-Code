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

qrCodeListe = ['../QR-Codes_Images/01a_01_helloWorld.png',
               '../QR-Codes_Images/01a_02_multiLineText.png',
               '../QR-Codes_Images/01a_03_Link.png',
               '../QR-Codes_Images/01a_04_Email.png',
               '../QR-Codes_Images/01a_05_VCard.png']


for aQR_CodeFile in qrCodeListe:
    img = cv2.imread(aQR_CodeFile)
    det = cv2.QRCodeDetector()
    val, pts, st_code = det.detectAndDecode(img)
    print("reading:", aQR_CodeFile, "\n", val, "\n\n", sep="")
