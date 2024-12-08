# ------------------------------------------------------------------
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/SchulungsUnterlagen/Studentenbeispiele/BZU/24_25/M231/Shifter_A.py
#
# Description: Examples
#
# Autor: Walter Rothlin
#
# History:
# 21-Nov-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------



def shiftChr_simple(aChar, shift):
    return chr(ord(aChar) + shift)

def shiftChr(aChar, shift):
    if (aChar >= " ") and (aChar <= "~"):
        return chr(((ord(aChar) - ord(' ') + shift) % (ord('~') - ord(' ') + 1)) + ord(' '))
    else:
        return aChar


def encrypt(klartext, key):
    shiffrat = ''
    for a_chr in klartext:
        shiffrat += shiftChr(a_chr, ord(key[0]))

    return shiffrat



