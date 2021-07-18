# Beispiel 3.3
#
# elif
#

# Menü ausgeben
print("Menü:")
print("1: Heizstab ein\n2: Heizstab aus")
print("3: Heizstab-Automatik\n4: Futter geben")

# Gewünschte Aktion abfragen
aktion = int(input("Aktion wählen: "))

# Funktion ausführen
if aktion == 1:
    print("Heizstab wird eingeschaltet")
elif aktion == 2:
    print("Heizstab wird ausgeschaltet")
elif aktion == 3:
    print("Heizstab im Automatik-Modus")
elif aktion == 4:
    print("Portion Futter eingestreut")
else:
    print("Ungültige Eingabe")
