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

def shift(sChar, offset):
    return chr(ord(sChar) + offset)

def encrypt(plainText, key):
    return "Verschluesselter Text"


plainText = '''Hallo BZU!'''
key = 5

# print("plainText:", plainText)
# for singleChar in plainText:
#     print(singleChar, ord(singleChar), ord(singleChar) + key, chr(ord(singleChar) + key), shift(singleChar, key), shift(shift(singleChar, key), -key))

print("Plaintext: ", plainText)
print("Chiffrat : ", encrypt(plainText, key))
