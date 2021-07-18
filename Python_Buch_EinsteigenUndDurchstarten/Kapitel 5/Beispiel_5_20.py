# Beispiel 5.20
#
# Überschreiben der Methode __str__()
#


# Klassendefinition
class Auto:
    def __init__(self, marke, farbe, leistung):
        # Ein paar Attribute zum Testen
        self.marke = marke
        self.farbe = farbe
        self.leistung = leistung
        self.baujahr = 2018

        print("Neues Auto erstellt")

    def __str__(self):
        # Die Beschreibung generieren
        beschreibung = "Marke: {0}, Farbe: {1}, Leistung: {2}, Baujahr: {3}".format(
            self.marke, self.farbe, self.leistung, self.baujahr )

        return beschreibung


def main():
    # Hauptprogramm
    auto = Auto("Nissan", "Blau", 57)

    # Beschreibung des Autos ausgeben
    print(auto)

    beschreibung = str(auto)
    print(beschreibung)


main()
