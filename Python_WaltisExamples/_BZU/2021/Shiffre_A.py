# ------------------------------------------------------------------
# Name: Shiffre.py
#
# Description: Crypto Maschine in Python
#
# Autor: Walter Rothlin
#
# History:
# 05-Nov-2021   Walter Rothlin      Initial Version
# 11-Nov-2021   Walter Rothlin      Implemented Ringbuffer Shifter, encrypter, decrypter
# ------------------------------------------------------------------

def shifter(sChr, sh):
    retVal = chr(ord(sChr) + sh)
    return retVal

# shifter using ringbuffer
def shiftChr(aChar, shift):
    return chr(((ord(aChar) - ord(' ') + shift) % (ord('~') - ord(' ') + 1)) + ord(' '))

def encrypt(klartext, key):
    keyIndex = 0
    geheimtext = ""
    for aChar in klartext:
        if (aChar >= "") and (aChar <= "~"):
            aKeyChr = key[keyIndex]
            shifter = ord(aKeyChr)
            aSecretChr = shiftChr(aChar, shifter)
            # print(aChar, " (Rigth-Shift: ord(", aKeyChr, ") ", shifter, ") --> ", aSecretChr, sep="")
            keyIndex = keyIndex + 1
            if (keyIndex >= len(key)):
                keyIndex = 0
            geheimtext = geheimtext + aSecretChr
    return geheimtext

def decrypt(geheimtext, key):
  keyIndex = 0
  encryptedtext = ""
  for aChar in geheimtext:
     if (aChar >= "") and (aChar <= "~"):
        aKeyChr = key[keyIndex]
        shifter = ord(aKeyChr)
        decryptedChar = shiftChr(aChar, -shifter)
        # print(aChar, " (Left-Shift:        ", -shifter, ") --> ", decryptedChar, sep="", end="\n\n")
        keyIndex = keyIndex + 1
        if (keyIndex >= len(key)):
           keyIndex = 0
        encryptedtext = encryptedtext + decryptedChar
  return encryptedtext

key = 'superGeheim007'

klartext = '''Hello World!
Dies ist ein langer Text!
'''

# klartext = input("Klartext:")
# print("Klartext:", klartext)


radius = float(input("Radius:"))
print("r =", radius, "   U =", 2*radius*3.1415926)

# chiffrat = encrypt(klartext, key)
# print("Klartext:", klartext, "   Key:", key)
# print("Chiffrat:", chiffrat)
# print()
#
# dechiffrat = decrypt(chiffrat, key)
# print("Chiffrat:", chiffrat)
# print("Dechiffrat:", dechiffrat, "   Key:", key)
# print("Klartext:", klartext)
# print()
