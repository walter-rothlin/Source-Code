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




if __name__ == '__main__':
    print('Shifter')
    print('=======')


'''
    klar_text = input('Klartext:')
    shiffer_key = input('Key:')

    shiffrat = encrypt(klar_text, shiffer_key)

    print(f'{klar_text}   ==> {shiffrat}')
'''

print(f"shiftChr_simple('a', 1) = {shiftChr_simple('a', 1)}")
print(f"shiftChr_simple('A', 10) = {shiftChr_simple('A', 10)}")
print(f"shiftChr_simple('Z', 100) = {shiftChr_simple('Z', 100)}")

