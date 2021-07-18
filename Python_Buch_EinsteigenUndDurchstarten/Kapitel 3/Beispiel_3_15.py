# Beispiel 3.15
#
# Lösung zur Aufgabenstellung
#

# Zu begleichenden Restbetrag abfragen
while True:
    try:
        restbetrag = float(input("Bitte Preis des Einkaufs eingeben: "))
        break
    except ValueError:
        print("Falsche Eingabe!")

# Wurde die Rechnung bereits beglichen?
while restbetrag > 0:
    while True:
        try:
            betrag = float(input("Bitte gezahlten Betrag eingeben: "))
            break
        except ValueError:
            print("Falsche Eingabe!")

    # Prüfen und Berechnen des Restbetrags
    restbetrag -= betrag

    if restbetrag == 0:
        print("Sehr schön, passend!")
    elif restbetrag > 0:
        print("Bitte zahlen Sie noch {0:0.2f} €".format(restbetrag))
    else:
        print("Sie erhalten {0:0.2f} € Wechselgeld".format(-restbetrag))

# Nett sein zum Kunden!
print("Vielen Dank für Ihren Einkauf und beehren Sie uns bald wieder!")
