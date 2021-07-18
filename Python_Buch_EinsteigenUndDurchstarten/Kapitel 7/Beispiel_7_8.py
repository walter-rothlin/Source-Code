# Beispiel 7.8
#
# try-else
#
while True:
    try:
        # Folgende beiden Zeilen können Exceptions auslösen
        eingabe = int(input("Eingabe: "))
        ergebnis = 16/eingabe
    except (ValueError, ZeroDivisionError):
        # Auf den Fehler reagieren
        print("Fehler bei der Berechnung!")
    else:
        # Diese Teile der Berechnung sind unkritisch
        ergebnis += 16
        ergebnis *= 23
        print(ergebnis)
