# Beispiel 6.24
#
# Lösung zur Aufgabe 6.2
#


# ---------- Möglichkeit 1: ----------
def finde_teilstrings_1(satz, teilstring):
    print("Alle Teilstrings finden - Möglichkeit 1:")
    anzahl = satz.count(teilstring)  # Anzahl der Vorkommen im Satz bestimmen

    index = 0

    # So oft suchen, wie Vorkommen gefunden wurden
    for i in range(anzahl):
        index = satz.find(teilstring, index)
        print("Teilstring gefunden an Index", index)
        index += len(teilstring)

    print("...fertig!\n")


# ---------- Möglichkeit 2: ----------
def finde_teilstrings_2(satz, teilstring):
    print("Alle Teilstrings finden - Möglichkeit 2:")

    index = 0

    # So lange suchen, bis kein Treffer mehr erzielt wird
    while True:
        index = satz.find(teilstring, index)

        if index != -1:
            print("Teilstring gefunden an Index", index)
        else:
            break

        index += len(teilstring)

    print("...fertig!\n")


# Hauptprogramm
def main():
    # Ein Satz, der sich gut zum Durchsuchen eignet
    satz = "Fischers Fritz fischt frische Fische Frische Fische fischt Fischers Fritz"
    teilstring = "Fische"

    print("Satz: ", satz)
    print("Suchstring: ", teilstring)

    # Beide Möglichkeiten testen
    finde_teilstrings_1(satz, teilstring)
    finde_teilstrings_2(satz, teilstring)


main()
