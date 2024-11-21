
# !/usr/bin/python3

# ------------------------------------------------------------------
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/SchulungsUnterlagen/Studentenbeispiele/BZU/24_25/M231/Shifter_B.py
#
# Description: Examples
#
# Autor: Walter Rothlin
#
# History:
# 21-Nov-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

def shiffer(ein_char, shift):
    return chr(ord(ein_char) + shift)

def encrypt(klartext, shift):
    shiffrat = ''
    for a_chr in klartext:
        shiffrat = shiffrat + shiffer(a_chr, shift)
    return shiffrat

print('Shifter')
print('=======')

klar_text = input('Klartext:')
shiffer_key = int(input('Key:'))

shiffrat = encrypt(klar_text, shiffer_key)

print(f'{klar_text}   ==> {shiffrat}')




