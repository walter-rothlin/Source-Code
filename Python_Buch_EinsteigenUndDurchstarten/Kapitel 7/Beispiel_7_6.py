# Beispiel 7.6
#
# Abfangen aller Exceptions
#
while True:
    try:
        eingabe = int(input("Eingabe: "))
        ergebnis = 10/eingabe

        print(ergebnis)
        break
    except ValueError:
        print("Ungültige Eingabe!")
    except Exception:
        # Hier ging etwas unerwartet schief
        print("Unerwarteter Fehler")

        # Exception weiterreichen
        raise
