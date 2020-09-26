#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_SymCrypterEncrypter.py
#
# Description: TC-61 / Enigma
#
#
# Autor: Walter Rothlin
#
# History:
# 28-Apr-2020	Initial Version
#
# ------------------------------------------------------------------
def shiftChr(buchstabe, shift):
   return chr(ord(buchstabe) + shift)


klartext = input("Klartext:")
shiftDistance = int(input("Distanz:"))
geheimText = ""
for aChar in klartext:
   geheimText = geheimText + shiftChr(aChar, shiftDistance)

print("Geheimtext:", geheimText)