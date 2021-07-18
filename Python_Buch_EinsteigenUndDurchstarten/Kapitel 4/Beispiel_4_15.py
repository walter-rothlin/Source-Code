# Beispiel 4.15
#
# Fehlerquelltext
#


# Einen Betrag vom Konto abbuchen
def abbuchen(kontostand, betrag):
    kontostand -= betrag
    print("Es wurden {1} € abgebucht.".format(betrag)


# Zinsen für das Konto vergüten
def zinsen_vergueten(kontostand, prozent=1.25):
    zinsen = (kontostand * prozent) / 100
    print("Zinsen: {1:.2f} €".format(zinsen))
    return kontostand + zinsen


# Hauptprogramm
def main()
    kontostand = 1250
    print("Aktueller Kontostand: {1:.2f}".format(kontostand))
    abbuchen(kontostand, 125)
    print("Aktueller Kontostand: {1:.2f}".format(kontostand))
    kontostand = zinsen_vergueten(kontostand, Prozent=5)
    print("Aktueller Kontostand: {1:.2f}".format(kontostand))
    kontostand = zinsen_vergueten(kontostand)
    print("Aktueller Kontostand: {1:.2f}".format(kontostand))
