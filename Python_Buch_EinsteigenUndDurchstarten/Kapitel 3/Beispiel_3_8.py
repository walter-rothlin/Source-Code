# Beispiel 3.8
#
# while-else
#

# Abfragen, wann Zähler beendet werden soll
abbruch = int(input("Abbruch des Zählers bei: "))

zaehler = 0

# Bis zehn oder Abbruch zählen
while zaehler <= 10:
    if zaehler == abbruch:
        print("Zähler abgebrochen")
        break

    zaehler += 1
else:
    print("Zähler erfolgreich beendet!")
