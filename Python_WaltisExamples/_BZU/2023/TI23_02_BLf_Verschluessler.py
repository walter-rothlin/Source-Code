

def shift_one_char(a_letter, shift_chr, backward=False):
    shift = ord(shift_chr[0])
    if backward:
        shift = -shift
    if (a_letter >= " ") and (a_letter <= "~"):
        return chr(((ord(a_letter) - ord(' ') + shift) % (ord('~') - ord(' ') + 1)) + ord(' '))
    else:
        return a_letter

def verschluesseln(klartext, key, crypt=True):
    chiffrat = ''

    key_length = len(key)
    klartext_position = 0
    for ein_buchstabe in klartext:
        key_chr = key[klartext_position % key_length]
        chiffrat += shift_one_char(ein_buchstabe, key_chr, backward=not crypt)
        klartext_position += 1
    return chiffrat

print('Verschlüssler')
print('=============')

do_loop = True
while do_loop:
    klartext_mldg = input('Klartext:')
    key_str = input('Key     :')
    geheimtext = verschluesseln(klartext_mldg, key_str)
    print(f'{klartext_mldg}  key:{key_str} --> {geheimtext}')

    klartext_mldg = verschluesseln(geheimtext, key_str, crypt=False)
    print(f'{geheimtext}  key:{key_str} --> {klartext_mldg}')

    weiter = input('Weiter (J/N)?')
    if weiter == 'N':
        do_loop = False

print('Programm beendet!!!')














i = ord(' ')
print(f'|{chr(i):5s}|{i:3d}|{hex(i)[2:].upper():5s}|{oct(i)[2:].upper().rjust(3, "0"):6s}|{bin(i)[2:].upper().rjust(7, "0"):8s}|')


