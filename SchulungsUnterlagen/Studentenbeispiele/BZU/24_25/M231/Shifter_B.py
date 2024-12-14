
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

def shiftChr_simple(aChar, shift):
    return chr(ord(aChar) + shift)

def shiftChr(aChar, shift):
    '''
    Shifts a character by the given shift value
    :param aChar: The character to shift
    :param shift: The shift value
    :return: The shifted character
    '''
    # print(f'aChar: {aChar}  shift: {shift}')
    if (aChar >= " ") and (aChar <= "~"):
        return chr(((ord(aChar) - ord(' ') + shift) % (ord('~') - ord(' ') + 1)) + ord(' '))
    else:
        return aChar

def encrypt(klartext, password):
    '''
    Encrypts the given text with the given password
    :param klartext: The text to encrypt
    :param password: The password to use for encryption
    :return: The encrypted text
    '''
    return de_encrypt(klartext, password, encrypt=True)

def decrypt(shiffrat, password):
    '''
    Decrypts the given text with the given password
    :param shiffrat: The text to decrypt
    :param password: The password to use for decryption
    :return: The decrypted text
    '''
    return de_encrypt(shiffrat, password, encrypt=False)

def de_encrypt(text, password, encrypt=True):
    '''
    Encrypts or decrypts the given text with the given password
    :param text: The text to encrypt or decrypt
    :param password: The password to use for encryption or decryption
    :param encrypt: True for encryption, False for decryption
    :return: The encrypted or decrypted
    '''
    return_text = ''
    password_pos = 0
    factor = 1
    if not encrypt:
        factor = -1
    for a_chr in text:
        return_text += shiftChr(a_chr, factor * ord(password[password_pos]))
        password_pos += 1
        if password_pos >= len(password):
            password_pos = 0
    return return_text

if __name__ == '__main__':
    print('Shifter')
    print('=======')

    klar_text = input('Klartext:')
    password = input('Passwort:')

    shiffrat = encrypt(klar_text, password)
    print(f'{klar_text}   ==> {shiffrat}')
    deshiffrat = decrypt(shiffrat, password)
    print(f'{shiffrat}   ==> {deshiffrat}')
    if klar_text == deshiffrat:
        print('OK')
    else:
        print('Error')




