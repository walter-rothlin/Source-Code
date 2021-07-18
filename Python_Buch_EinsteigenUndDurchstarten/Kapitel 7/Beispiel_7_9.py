# Beispiel 7.9
#
# try-finally
#
try:
    # Folgende beiden Zeilen können Exceptions auslösen
    print("Kritische Anweisung 1")
    print("Kritische Anweisung 2")

    # Die folgende Zeile kann zum Testen einkommentiert werden
    #raise OSError
except OSError:
    # Auf den Fehler reagieren
    print("Es ist ein Fehler aufgetreten!")
else:
    # Wenn kein Fehler auftrat, diesen Teil des Quelltextes ausführen
    print("Alles ging glatt!")
finally:
    # Abschließende Aufräumarbeiten
    print("In jedem Fall noch aufräumen")
