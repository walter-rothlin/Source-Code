# Beispiel 6.6
#
# Eigene Sortierfunktionen
#


# Klassendefinition für einen Highscore-Eintrag
class Highscore:
    def __init__(self, name, punkte):
        self.name = name
        self.punkte = punkte

    def __str__(self):
        return "Name: {0}, Punkte: {1}".format(self.name, self.punkte)


# Sortierfunktionen
def sortiere_name(eintrag):
    return eintrag.__name


def sortiere_punkte(eintrag):
    return eintrag.punkte


# Hauptprogramm
def main():
    highscores = [Highscore("Sneaky", 6205), Highscore("Largo", 3221),
                  Highscore("Cheater", 9999), Highscore("Mike", 5412)]

    # Unsortierte Liste ausgeben
    print("\nUnsortierte Highscore-Liste")
    for eintrag in highscores:
        print(eintrag)

    # Nach Namen sortieren
    highscores.sort(key=sortiere_name)

    print("\nNach Namen sortiert:")
    for eintrag in highscores:
        print(eintrag)

    # Nach Punkten sortieren
    highscores.sort(key=sortiere_punkte, reverse=True)

    print("\nNach Punkten sortiert:")
    for eintrag in highscores:
        print(eintrag)


main()
