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
# 28-Apr-2020	Walter Rothlin Initial Version
# 08-Apr-2021   Walter Rothlin Added automated testing
# ------------------------------------------------------------------
def shiftChr(einBuchstabe, shiffter):
   return chr(ord(einBuchstabe) + shiffter)


if __name__ == '__main__':
   if shiftChr('a', 5) != 'f':
      print("Error in Test-Case 1")

   if shiftChr('f', -5) != 'a':
      print("Error in Test-Case 2")

   klartextZeichen = input("Klartext Zeichen:")
   shiftDistance = int(input("Distanz:"))
   print(shiftChr(klartextZeichen, shiftDistance))


















# klartext = input("Klartext:")
# shiftDistance = int(input("Distanz:"))
# geheimText = ""
# for aChar in klartext:
#    geheimText = geheimText + shiftChr(aChar, shiftDistance)
#
# print("Geheimtext:", geheimText)