# Beispiel 4.4
#
# Globale und lokale Variablen
#


# Überschreiben der Variablen "zahl"
def zahl_ersetzen():
    zahl = 20
    print("Funktion: Neuer Wert:", zahl)
    testvariable = 408
    print("Testvariable:", testvariable)


# Hauptprogramm
zahl = 17

zahl_ersetzen()
print("Hauptprogramm: Neuer Wert:", zahl)

# Das wäre ein Fehler!
#print("Testvariable:", testvariable)
