# Beispiel 3.16
#
# Zahlenraten - Version 1
#
from random import randint

level = 1

while True:

    # Ausgabe des Menüs
    #
    print("\n---------------------")
    print("Menü:")
    print("(N)eues Spiel starten")
    print("(L)evel festlegen")
    print("(B)eenden")

    # Gewünschten Menüpunkt abfragen
    #
    auswahl = input("Deine Wahl: ")

    if auswahl == 'N' or auswahl == 'n':
        # Neues Spiel starten
        #
        bereich = 10 * level
        print("Neues Spiel beginnt. Rate eine Zahl von 1 bis", bereich)
        zielzahl = randint(1, bereich)
        anzahl_versuche = 0

        tipp = 0

        while tipp != zielzahl:
            # Zahl wurde noch nicht erraten. Nächster Versuch
            #
            try:
                tipp = int(input("Dein Tipp (0 zum Aufgeben): "))
            except ValueError:
                print("Fehler: Es wurden Buchstaben eingegeben")
                continue

            if tipp == 0:
                print("Du gibst auf :(")
                break
            elif int(tipp < zielzahl):
                print("Die gesuchte Zahl ist größer")
            elif int(tipp > zielzahl):
                print("Die gesuchte Zahl ist kleiner")

            anzahl_versuche += 1
        else:
            # Zahl wurde erraten!
            #
            print("Glückwunsch, Du hast die Zahl erraten!")
            print("Anzahl der Versuche: ", anzahl_versuche)
    elif auswahl == 'L' or auswahl == 'l':
        # Gewünschtes Level abfragen. Gültige Eingabe sicherstellen
        #
        while True:
            try:
                level = int(input("Neues Level (1-10): "))
            except ValueError:
                print("Fehler: Es wurden Buchstaben eingegeben")
                continue

            if level < 1 or level > 10:
                print("Ungültiges Level!")
                continue
            else:
                break
    elif auswahl == 'B' or auswahl == 'b':
        # Spiel beenden
        #
        print("Spiel wird beendet")
        break
    else:
        # Ungültiger Menüpunkt eingegeben
        #
        print("Falsche Eingabe")
