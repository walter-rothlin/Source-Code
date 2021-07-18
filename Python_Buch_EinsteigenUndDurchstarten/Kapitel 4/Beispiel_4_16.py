# Beispiel 4.16
#
# Korrigierter Fehlerquelltext
#


# Einen Betrag vom Konto abbuchen
def abbuchen(kontostand, betrag):
    print("Es wurden {0} € abgebucht.".format(betrag))
    return kontostand - betrag


# Zinsen für das Konto vergüten
def zinsen_vergueten(kontostand, prozent=1.25):
    zinsen = (kontostand * prozent) / 100
    print("Zinsen: {0:.2f} €".format(zinsen))
    return kontostand + zinsen


# Kontostand formatiert ausgeben
def kontostand_ausgeben(kontostand):
    print("Aktueller Kontostand: {0:.2f} €".format(kontostand))


# Hauptprogramm
def main():
    kontostand = 1250
    kontostand_ausgeben(kontostand)
    kontostand = abbuchen(kontostand, 125)
    kontostand_ausgeben(kontostand)
    kontostand = zinsen_vergueten(kontostand, prozent=5)
    kontostand_ausgeben(kontostand)
    kontostand = zinsen_vergueten(kontostand)
    kontostand_ausgeben(kontostand)

main()
