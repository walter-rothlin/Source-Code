#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: SymCrypterEncrypter.py
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
from Class_SymCrypterEncrypter import *


def encrypt(klarText, key):
   TC61 = SymCrypterEncrypter(key)
   geheimText = TC61.encrypt(klarText)
   return geheimText

def decrypt(geheimText, key):
   TC61 = SymCrypterEncrypter(key)
   encryptedText = TC61.decrypt(geheimText)
   return encryptedText

def encryptWithBackdoor(klarText, key, backdoorKey = "P19"):
   return "Not implemented yet"

def decryptThroughFrontdoor(geheimText, key):
   return "Not implemented yet"

def decryptThroughBackdoor(geheimText, backdoorKey = "P19"):
   return "Not implemented yet"

print("Test Normal")
print("===========")
klarText   = input("Klartext :")
secretKey  = input("Schlüssel:")
geheimText = encrypt(klarText, secretKey)
print(klarText, "-->", geheimText, "\n")

geheimText  = input("Geheimtext :")
secretKey   = input("Schlüssel  :")
encryptedText = decrypt(geheimText, secretKey)
print(geheimText, "-->", encryptedText, "\n")
print("\n\n")


print("Test durch Hintertür")
print("====================")
klarText     = input("Klartext     :")
secretKey    = input("Schlüssel    :")
hintertorKey = input("Hintertor-Key:")
geheimText = encryptWithBackdoor(klarText, secretKey, hintertorKey)
print(klarText, "-->", geheimText, "\n")

geheimText   = input("Geheimtext   :")
frontDoorKey = input("Schlüssel    :")
encryptedText = decryptThroughFrontdoor(geheimText, frontDoorKey)
print(geheimText, "-->", encryptedText, "\n")

geheimText   = input("Geheimtext  :")
backDoorKey  = input("Backdoor-Key:")
encryptedText = decryptThroughBackdoor(geheimText, backDoorKey)
print(geheimText, "-->", encryptedText, "\n")




