# Beispiel 3.6
#
# break in while-Schleifen
#

# Menü ausgeben
print("Menü:")
print("1: Heizstab ein\n2: Heizstab aus")
print("3: Programm beenden")

# Gewünschte Aktion abfragen
while True:
    aktion = int(input("Aktion wählen: "))

    # Funktion ausführen
    if aktion == 1:
        print("Heizstab wird eingeschaltet")
    elif aktion == 2:
        print("Heizstab wird ausgeschaltet")
    elif aktion == 3:
        print("Programm wird beendet")
        break
    else:
        print("Ungültige Eingabe")

print("Das war's")
