#!/usr/bin/python3

'''pruefung_10b_TypeCast.py'''

''' Expected Result:
Gesamtpreis:509.5
Gesamtpreis:509.5
Gesamtpreis: 509.5
'''


einzelPreis     = 50.95
bestellteAnzahl = 10
lableText       = "Gesamtpreis:"



# print(lableText + einzelPreis, sep="")                       # TypeCast Error
# print(lableText + (bestellteAnzahl * einzelPreis), sep="")   # TypeCast Error
print(lableText, bestellteAnzahl * einzelPreis, sep="")
print(lableText + str(bestellteAnzahl * einzelPreis))
print(lableText, str(bestellteAnzahl * einzelPreis))






