# Beispiel 6.9
#
# Anonyme Funktionen in der Praxis
#


# Klassendefinition für einen Highscore-Eintrag
class Highscore:
    def __init__(self, name, punkte):
        self.name = name
        self.punkte = punkte

    def __str__(self):
        return "Name: {0}, Punkte: {1}".format(self.name, self.punkte)


# Hauptprogramm
def main():
    highscores = [Highscore("Sneaky", 6205), Highscore("Largo", 3221),
                  Highscore("Cheater", 9999), Highscore("Mike", 5412)]

    # Unsortierte Liste ausgeben
    print("\nUnsortierte Highscore-Liste")
    for eintrag in highscores:
        print(eintrag)

    # Nach Punkten sortieren
    highscores.sort(key=lambda x: x.punkte, reverse=True)

    print("\nNach Punkten sortiert:")
    for eintrag in highscores:
        print(eintrag)


main()
