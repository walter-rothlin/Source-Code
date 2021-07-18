# Beispiel 5.3
#
# Properties - Getter und Setter
#


# Klassendefinition
class Auto:
    def __init__(self):
        self._wischerstellung = 0

        print("Hurra, ein Neuwagen!")

    def get_wischerstellung(self):
        print("Getter wurde aufgerufen")
        return self._wischerstellung

    def set_wischerstellung(self, wert):
        print("Neuer Wert:", wert)

        if wert >= 0 and wert <= 4:
            self._wischerstellung = wert
        else:
            print("Ungültige Wischerstellung!")

    wischerstellung = property(get_wischerstellung, set_wischerstellung)


def main():
    # Hauptprogramm
    mein_auto = Auto()

    mein_auto.wischerstellung = 0
    mein_auto.wischerstellung = 3
    mein_auto.wischerstellung = 6
    print("Wischerstellung:", mein_auto.wischerstellung)

    mein_auto._wischerstellung = 9
    print("Wischerstellung:", mein_auto.wischerstellung)

main()
