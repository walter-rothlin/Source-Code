# Beispiel 4.13
#
# Aufgabenstellung: Zahlenraten Version 2
#
from random import randint


# ------ Menüpunkt abfragen ------
def menuepunkt_abfragen():
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

    return auswahl


# ------ Zahl abfragen und gültige Eingabe prüfen ------
def zahl_abfragen(text):
    while True:
        try:
            zahl = int(input(text))
            return zahl
        except ValueError:
            print("Fehler: Es wurden Buchstaben eingegeben")
            continue


# ------ Zahl abfragen und gültige Eingabe prüfen ------
def neues_spiel(level):
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
        tipp = zahl_abfragen("Dein Tipp (0 zum Aufgeben): ")

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


# ------ Zahl abfragen und gültige Eingabe prüfen ------
def level_abfragen():
    # Gewünschtes Level abfragen. Gültige Eingabe sicherstellen
    #
    while True:
        neues_level = zahl_abfragen("Neues Level (1-10): ")

        if neues_level < 1 or neues_level > 10:
            print("Ungültiges Level!")
            continue
        else:
            return neues_level


# Hauptprogramm
def main():
    level = 1

    while True:
        auswahl = menuepunkt_abfragen()

        if auswahl == 'N' or auswahl == 'n':
            neues_spiel(level)
        elif auswahl == 'L' or auswahl == 'l':
            level = level_abfragen()
        elif auswahl == 'B' or auswahl == 'b':
            # Spiel beenden
            #
            print("Spiel wird beendet")
            break
        else:
            # Ungültiger Menüpunkt eingegeben
            #
            print("Falsche Eingabe")


main()
