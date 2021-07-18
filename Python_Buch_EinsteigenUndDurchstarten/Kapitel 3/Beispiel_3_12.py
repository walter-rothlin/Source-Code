# Beispiel 3.12
#
# Abfangen und Behandeln von Exceptions
#
korrekte_eingabe = False

# So lange Werte abfragen, bis diese korrekt sind
while not korrekte_eingabe:
    try:
        tankmenge = float(input("Getankte Liter eingeben: "))
        literpreis = float(input("Literpreis eingeben: "))
    except ValueError:
        print("Fehler: Falsches Format")
        continue

    korrekte_eingabe = True

gesamtbetrag = tankmenge * literpreis
print("Zu zahlender Betrag: {0:0.2f} €".format(gesamtbetrag))
