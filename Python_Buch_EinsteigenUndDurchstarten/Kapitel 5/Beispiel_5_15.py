# Beispiel 5.15
#
# Mehrfachvererbung 
#


# Klassendefinition (Telefon)
class Telefon:
    def anrufen(self, name):
        print("Kontakt {0} wird angerufen".format(name))


# Klassendefinition (Kamera)
class Kamera:
    def foto_knipsen(self):
        print("Foto wird geknipst")


# Klassendefinition (Taschenrechner)
class Taschenrechner:
    def addieren(self, wert1, wert2):
        print("Ergebnis der addition:", wert1 + wert2)


# Klassendefinition (Smartphone)
class Smartphone(Telefon, Kamera, Taschenrechner):
    def __init__(self):
        print("Smartphone erstellt")


def main():
    # Hauptprogramm
    idroid = Smartphone()
    idroid.addieren(13, 32)
    idroid.anrufen("Lieferdienst für Pizza")
    idroid.foto_knipsen()


main()
