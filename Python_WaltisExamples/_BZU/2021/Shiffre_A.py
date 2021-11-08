# ------------------------------------------------------------------
# Name: Shiffre.py
#
# Description: Crypto Maschine in Python
#
# Autor: Walter Rothlin
#
# History:
# 05-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

def shifter(sChr, sh):
    retVal = chr(ord(sChr) + sh)
    return retVal

def encrypt(klartext, key):
    return "verschluesselter Text"

def decrypt(chiffrat, key):
    return "Klartext"

klartext = 'Hello World!'
shift = 5
key = 'superGeheim007'

# print(klartext)
# for singleChar in klartext:
#     print(singleChar, ord(singleChar), ord(singleChar) + shift, chr(ord(singleChar) + shift), end='', sep=' ')
#     print(shifter(singleChar, shift), shifter(shifter(singleChar, shift), -shift), end='\n')

chiffrat = encrypt(klartext, key)
print("Klartext:", klartext, "   Key:", key)
print("Chiffrat:", chiffrat)
