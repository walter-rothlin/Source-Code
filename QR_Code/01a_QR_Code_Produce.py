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
import qrcode

# Simple-Text
img = qrcode.make('Hello World!!!')
img.save('QR-CodesImages/01a_01_helloWorld.png')
print('QR-CodesImages/01a_01_helloWorld.png')

# Multiline-Text
qrText = '''Dies ist ein langer Text!!!
2.Zeile
'''
img = qrcode.make(qrText)
img.save('QR-CodesImages/01a_02_multiLineText.png')
print('QR-CodesImages/01a_02_multiLineText.png')

# Link
qrText = 'https://www.fh-hwz.ch'
img = qrcode.make(qrText)
img.save('QR-CodesImages/01a_03_Link.png')
print('QR-CodesImages/01a_03_Link.png')

# Email
qrText = 'MATMSG:TO:walter@rothlin.com;SUB:Gegenstand gefunden;BODY:Ich habe Ihr Gegenstand gefunden!;;'
img = qrcode.make(qrText)
img.save('QR-CodesImages/01a_04_Email.png')
print('QR-CodesImages/01a_04_Email.png')


# VCard
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
img = qrcode.make(qrText)
img.save('QR-CodesImages/01a_05_VCard.png')
print('QR-CodesImages/01a_05_VCard.png')

