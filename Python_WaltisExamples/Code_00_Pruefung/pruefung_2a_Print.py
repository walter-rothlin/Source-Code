#!/usr/bin/python3

# https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_00_Ruefunge/pruefung_2a_Print.py
'''pruefung_2a_Print.py'''


''' Expected Result:
Rothlin Tobias
Rothlin Tobias
RothlinTobias
Rothlin   Tobias
Rothlin Tobias
Rothlin   Tobias
Rothlin Tobias
Rothlin Tobias
'''

# ? Welche Zeilen geben "Tobias Rothlin" (mit genau einem Space zwischen Vorname und Nachname) aus?

vorname  = "Tobias"
nachname = "Rothlin"

print(nachname, vorname)
print(nachname, vorname, sep=" ")
print(nachname, vorname, sep="")
print(nachname, " ", vorname, sep=" ")
print(nachname, " ", vorname, sep="")
print(nachname, " ", vorname)
print(nachname + " " + vorname, sep="")
print(nachname + " " + vorname, sep=" ")
