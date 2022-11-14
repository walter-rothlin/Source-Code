# ------------------------------
# Walter Rothlin
# ------------------------------


print("Verschluessler")
print("--------------")

eineZahl_0 = 1234     # Kommentar
_eineZahl_0 = 234.56
__eineZahl_0 = 1.0

print(eineZahl_0, _eineZahl_0, __eineZahl_0, eineZahl_0 + __eineZahl_0)

vorname = "Walti"
nachname = 'Haemmerli'
print(vorname, nachname, eineZahl_0)

print(nachname + " " + vorname)


print("A ==> ", ord("A"))
print("65 ==> ", chr(65))
print(chr(ord("R") + 32))

eineZahl = 65
print(eineZahl, hex(eineZahl), bin(eineZahl), oct(eineZahl), "==>", chr(eineZahl))

klartext = input("Klartext:")
shifter = int(input("Shifter:"))
chiffrat = ""
for einBuchstabe in klartext:
    print(einBuchstabe, chr(ord(einBuchstabe) + shifter))
    chiffrat = chiffrat + chr(ord(einBuchstabe) + shifter)
print(klartext, "==>", chiffrat)

'''
0   00000000   0o00000     0x00 


'''

