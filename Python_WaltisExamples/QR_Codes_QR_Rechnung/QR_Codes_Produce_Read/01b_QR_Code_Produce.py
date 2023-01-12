#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01b_QR_Code_Produce.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/QR_Codes_QR_Rechnung/QR_Codes_Produce_Read/01b_QR_Code_Produce.py
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
import qrcode

def createQR_Code(text="Hello World!", filename="QR_CodeProduced.png", trace=True):
    img = qrcode.make(text)
    img.save(filename)
    if trace:
        print(filename)


# Simple-Text
# ===========
createQR_Code(text='Hallo BZU!!!!!', filename='../QR-Codes_Images/01a_01_helloWorld.png')


# Multiline-Text
# ==============
qrText = '''Dies ist ein langer Text!!!
2.Zeile
'''
fName = '../QR-Codes_Images/01a_02_multiLineText.png'
createQR_Code(text=qrText, filename=fName)


# Link
# ====
qrText = 'https://www.fh-hwz.ch'
fName = '../QR-Codes_Images/01a_03_Link.png'
createQR_Code(text=qrText, filename=fName)


# Email
# =====
qrText = '''MATMSG:TO:walter@rothlin.com;walter.rothlin@bzu.ch;
SUB:Eine anfrage via QR - Code;
BODY:Hallo Schule, hier ist eine Anfrage
via QR - Code!
Freundliche Grüsse;;
'''
fName = '../QR-Codes_Images/01a_04_Email.png'
createQR_Code(text=qrText, filename=fName)


# VCard
# =====
qrText = '''BEGIN:VCARD
VERSION:3.0
N:Rothlin;Walter
FN:Walter Rothlin
ORG:
TITLE:
ADR:;;Peterliwiese 33;Wangen;SZ;8855;Schweiz
TEL;WORK;VOICE:+41 55 460 14 40
TEL;CELL:+41 79 368 94 22
TEL;FAX:
EMAIL;WORK;INTERNET:walter@rothlin.com
URL:
END:VCARD
'''
fName = '../QR-Codes_Images/01a_05_VCard.png'
createQR_Code(text=qrText, filename=fName)
