print('Verschlüssler!')
print('--------------')

do_loop = True
while do_loop:
    klartext = input('Klartext:')
    if klartext == '':
        do_loop = False
    else:
        shifter = int(input('Shift    :'))

        chipher_text = ''
        for a_letter in klartext:
            chipher_text = chipher_text + chr(ord(a_letter) + shifter)

        # print(f'{a_letter}   (shift:{shifter})   --> {chr(ord(a_letter) + shifter)}')  # Format-String
        print(f'{klartext}   (shift:{shifter})   --> {chipher_text}')
        weiter = input('Weiter (J/N)?')
        if weiter == 'N':
            do_loop = False
print('Tschüsss!')
