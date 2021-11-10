# ------------------------------------------------------------------
# Name: pythonBasics_13_RegEx.py
#
# Description: Test-Programm zu RegEX
#
# Autor: Walter Rothlin
#
# History:
# 04-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import re

# https://www.datacamp.com/community/tutorials/python-regular-expression-tutorial?utm_source=adwords_ppc&utm_campaignid=898687156&utm_adgroupid=48947256715&utm_device=c&utm_keyword=&utm_matchtype=b&utm_network=g&utm_adpostion=&utm_creative=332602034343&utm_targetid=aud-299261629574:dsa-429603003980&utm_loc_interest_ms=&utm_loc_physical_ms=1030659&gclid=CjwKCAjwvMqDBhB8EiwA2iSmPDR31NV8fqfswUZIlUbCzfBvH4Cpe9F1tazVNK5HJBj3j4w-bnDQbBoCZv8QAvD_BwE

pattern = r"Cookie"
sequence = "Cookie is enabled"
if re.match(pattern, sequence):
    print("(0a):", "Match!")
else:
    print("(0a):", "Not a match!")

print("(0b):", re.search(r'Co.k.e', 'Coxkie are enabled! Noch mehr Coxkie').group())

statement = 'Please contact us at: support@datacamp.com'
regExStr = r'([\w\.-]+)@([\w\.-]+)'
match = re.search(regExStr, statement)
if statement:
  print("(0c): Email address:", match.group()) # The whole matched text
  print("(0c): Username:", match.group(1)) # The username (group 1)
  print("(0c): Host:", match.group(2)) # The host (group 2)

print()
print("(1):", re.findall(r'Co.k.e', 'Cookie und noch mehr Coxkxe'))
print("(2):", re.findall(r'^Eat', "Eat a cake! Eat it!"))
print("(3):", re.findall(r'E.t', "Ect a cake! Ebt it!"))
print("(4):", re.findall(r'cake$', "Cake! Let's eat cake"))


print("(5):", re.findall(r'E.t', "Ect a cake! Ebt it!"))

test_text_1 = '''
Uebungsaufgabe

Bitte diese Nachricht an {email} senden.

Der Rechnungsbetrag von {Betrag} ist innert 10 Tagen zu überweisen.



Weitere Daten zum Testen

walter@rothlin.com 8855 Wangen
claudia@collet.com 8853 Lachen

1230 Aepfel

055 460 14 40

079/368'22'20
'''


print("(7):", re.findall(r'\d{4}', test_text_1))                                       # alle 4-stelligen Ziffern
print("(9):", re.findall(r'{[a-zA-Z]+}', test_text_1))                                 # alle Placeholders
print("(8):", re.findall(r'\d{3}.?\d{3}.?\d{2}.?\d{2}', test_text_1))                  # alle Telefonnummer
print("(6):", re.findall(r'[a-zA-Z]+@rothlin.com|[a-zA-Z]+@collet.com', test_text_1))  # alle eMail Adressen
