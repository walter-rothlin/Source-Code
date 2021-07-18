# Beispiel 3.5
#
# while-Schleifen
#

# Menü ausgeben
print("Menü:")
print("1: Heizstab ein\n2: Heizstab aus")
print("3: Programm beenden")

aktion = 0

# Gewünschte Aktion abfragen
while aktion != 3:
    aktion = int(input("Aktion wählen: "))

    # Funktion ausführen
    if aktion == 1:
        print("Heizstab wird eingeschaltet")
    elif aktion == 2:
        print("Heizstab wird ausgeschaltet")
    elif aktion == 3:
        print("Programm wird beendet")
    else:
        print("Ungültige Eingabe")
