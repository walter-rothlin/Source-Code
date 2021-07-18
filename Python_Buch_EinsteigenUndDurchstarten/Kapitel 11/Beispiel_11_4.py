# Beispiel 11.4
#
# Eine fiktive Anlagensteuerung
#
import random


# Eine Reihe von Messungen durchführen
def messungen_durchfuehren(anzahl_messungen, wertebereich):
    for i in range(anzahl_messungen):
        # Fiktive Messwerte ermitteln
        messwert_1 = random.randint(0, wertebereich / 2)
        messwert_2 = random.randint(0, wertebereich)
        messwert_3 = random.randint(0, wertebereich)

        # Messwerte verrechnen und System regulieren
        ergebnis = messwert_2 * messwert_3 - messwert_1
        reguliere_system(ergebnis)


# System anhand des berechneten Wertes regulieren
def reguliere_system(messwert):
    if messwert > 80:
        print("Kritischer Bereich, herunterregeln")
    elif messwert < 30:
        print("Kritischer Bereich, hochregeln")


def main():
    # Konfiguration für die Messung
    random.seed()
    anzahl_messungen = 20
    wertebereich = 10

    messungen_durchfuehren(anzahl_messungen, wertebereich)


main()
