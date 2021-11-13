# ------------------------------------------------------------------
# Name: SymCrypterEncrypterFct.py
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


# shifter using a ringbuffer (source
def shiftChr(aChar, shift):
    if (aChar >= " ") and (aChar <= "~"):
        return chr(((ord(aChar) - ord(' ') + shift) % (ord('~') - ord(' ') + 1)) + ord(' '))
    else:
        return aChar


# check out waltisLibrary.py for implementation using comprehension
def encrypt(klartext, aKey):
    keyIndex = 0
    geheimtext = ""
    for aChar in klartext:
        aKeyChr = aKey[keyIndex]
        shifter = ord(aKeyChr)
        aSecretChr = shiftChr(aChar, shifter)
        # print(aChar, " (Rigth-Shift: ord(", aKeyChr, ") ", shifter, ") --> ", aSecretChr, sep="")
        keyIndex += 1
        if (keyIndex >= len(aKey)):
            keyIndex = 0
        geheimtext += aSecretChr
    return geheimtext


def decrypt(geheimtext, aKey):
    keyIndex = 0
    encryptedtext = ""
    for aChar in geheimtext:
        aKeyChr = aKey[keyIndex]
        shifter = ord(aKeyChr)
        decryptedChar = shiftChr(aChar, -shifter)
        # print(aChar, " (Left-Shift:        ", -shifter, ") --> ", decryptedChar, sep="", end="\n\n")
        keyIndex += 1
        if (keyIndex >= len(aKey)):
            keyIndex = 0
        encryptedtext += decryptedChar
    return encryptedtext


# ================
# Main starts here
# ================
doLoop = True
while doLoop:
    print(" Crypt-Maschine V1.0")
    print(" ===================")
    print()
    print("1: Verschluesseln")
    print("2: Entschluesseln")
    print()
    print("0: Ende")
    print()
    ant = input("    Wähle:")
    print("\n\n")
    if ant == "1":
        print("Verschluesseln")
        klartext = input("Klartext:")
        key = input("Key:")
        print(encrypt(klartext, key))

    elif ant == "2":
        print("Entschluesseln")
        chiffrat = input("Geheimtext:")
        key = input("Key:")
        print(decrypt(chiffrat, key))

    elif ant == "0":
        doLoop = False
