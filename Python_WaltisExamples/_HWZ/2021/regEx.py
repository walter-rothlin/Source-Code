
import re

test = 'kshjksadjkj'
test = "jkdjskfjsjk"
test_text_1 = '''
Uebungsaufgabe

Bitte diese Nachricht an {email} senden.

Der Rechnungsbetrag von {Betrag} ist innert 10 Tagen zu Ã¼berweisen.



Weitere Daten zum Testen

walter@rothlin.com 8855 Wangen
claudia@collet.com 8853 Lachen

1230 Aepfel

055 460 14 40

079/368'22'20
'''

print("(5):", re.findall(r'{[a-zA-Z]+}', test_text_1))                                 # alle Placeholders
print("(6):", re.findall(r'[a-zA-Z]+@rothlin.com|[a-zA-Z]+@collet.com', test_text_1))  # alle eMail Adressen
print("(7):", re.findall(r'\d{4}', test_text_1))                                       # alle 4-stelligen Ziffern
print("(8):", re.findall(r'\d{3}.?\d{3}.?\d{2}.?\d{2}', test_text_1))                  # alle Telefonnummern
