# Beispiel 5.2
#
# Properties - Verwenden eines Getters
#


# Klassendefinition
class Auto:
    def __init__(self):
        self._kilometerstand = 0

        print("Hurra, ein Neuwagen!")

    def zeige_daten(self):
        print("Kilometerstand:", self._kilometerstand)

    def strecke_fahren(self, kilometer):
        print("Das Auto fährt {0} Kilometer".format(kilometer))
        self._kilometerstand += kilometer

    def get_kilometerstand(self):
        print("Getter wurde aufgerufen")
        return self._kilometerstand

    kilometerstand = property(get_kilometerstand)


def main():
    # Hauptprogramm
    mein_auto = Auto()

    print("\nDaten des Autos:")
    mein_auto.zeige_daten()

    mein_auto.strecke_fahren(340)
    print("Kilometerstand des Autos:", mein_auto.kilometerstand)

    # Folgende Zeile führt zu einem Fehler:
    #mein_auto.kilometerstand = 123

    # Das hier ist dennoch möglich:
    #mein_auto._kilometerstand = 50
    #mein_auto.zeige_daten()


main()
