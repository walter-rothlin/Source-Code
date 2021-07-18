from datetime import datetime


# Klassendefinition
class Auto:
    def __init__(self, marke, farbe, leistung, anzahl_tueren):
        self.kilometerstand = 0
        self.marke = marke
        self.farbe = farbe
        self.leistung = leistung
        self.anzahl_tueren = anzahl_tueren

        print("Neues Auto erzeugt")

        # Logfile öffnen und einen Eintrag erzeugen
        logfile = open("Logfile.txt", "a")
        logfile.write(datetime.now().strftime("%d.%m.%Y - %H:%M:%S") + " : ")

        logfile.write("Neues Auto der Marke {0} erstellt\n".format(marke))

    def zeige_daten(self):
        print("Marke:", self.marke)
        print("Kilometerstand:", self.kilometerstand)
        print("Farbe:", self.farbe)
        print("Leistung:", self.leistung, "kW")
        print("Anzahl der Türen:", self.anzahl_tueren)

    def strecke_fahren(self, kilometer):
        print("Das Auto fährt {0} Kilometer".format(kilometer))
        self.kilometerstand += kilometer
