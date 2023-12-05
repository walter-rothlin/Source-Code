

def shift_one_char(a_letter, shift_chr, backward=False):
    shift = ord(shift_chr[0])
    if backward:
        shift = -shift
    if (a_letter >= " ") and (a_letter <= "~"):
        return chr(((ord(a_letter) - ord(' ') + shift) % (ord('~') - ord(' ') + 1)) + ord(' '))
    else:
        return a_letter
def verschluesseln(klartext, key, entschluesseln=False):
    encryption_text = ''
    key_length = len(key)
    klar_text_pos = 0
    for a_letter in klartext:
        key_part = key[klar_text_pos % key_length]
        encryption_text += shift_one_char(a_letter, key_part, backward=entschluesseln)
        klar_text_pos += 1
    return encryption_text


print('Verschlüssler!')
print('--------------')

do_loop = True
while do_loop:
    klartext = input('Klartext:')
    if klartext == '':
        do_loop = False
    else:
        key_str = input('Key    :')
        chipher_text = verschluesseln(klartext, key_str)
        print(f'{klartext}   (Key:{key_str})   --> {chipher_text}')

        dechiffrat = verschluesseln(chipher_text, key_str, entschluesseln=True)
        print(f'{chipher_text}   (Key:{key_str})   --> {dechiffrat}')

        if klartext == dechiffrat:
            print('Verschlüsselung ok!')
        else:
            print('ERROR!!!!!')

        weiter = input('Weiter (J/N)?')
        if weiter.upper() == 'N':
            do_loop = False
print('Tschüsss!')

