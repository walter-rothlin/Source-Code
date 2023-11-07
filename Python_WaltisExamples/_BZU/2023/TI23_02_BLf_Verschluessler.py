print('Verschlüssler')
print('=============')

# ASCII Tabelle generieren pythonBasics_16_StrHexBinOct.py

do_loop = True
while do_loop:
    ein_buchstabe = input('Klartext:')
    shifter = int(input('Shifter:'))

    chiffrat = chr(ord(ein_buchstabe) + shifter)
    print(f'{ein_buchstabe} geshiftet um {shifter} --> {chiffrat}')

    weiter = input('Weiter (J/N)?')
    if weiter == 'N':
        do_loop = False

print('Programm beendet!!!')


i = ord(' ')
print("|{z:5s}|{ordDec:3d}|{ordHex:5s}|{ordOct:6s}|{ordBin:8s}|".format(
                                                                z=chr(i),
                                                                ordDec=i,
                                                                ordHex=hex(i)[2:].upper(),
                                                                ordOct=oct(i)[2:].upper().rjust(3, "0"),
                                                                ordBin=bin(i)[2:].upper().rjust(7, "0")))
print("+{z:5s}+{ordDec:3s}+{ordHex:5s}+{ordOct:6s}+{ordBin:8s}+".format(
                                                                z=aLine(5),
                                                                ordDec=aLine(3),
                                                                ordHex=aLine(5),
                                                                ordOct=aLine(6),
                                                                ordBin=aLine(8)))

print()

