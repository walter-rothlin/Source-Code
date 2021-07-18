# Beispiel 7.7
#
# Eigene Exceptions
#


# Eigene Exception-Klasse
class DateiFormatException(Exception):
    def __init__(self, dateiname, min_bytes, max_bytes, anzahl_bytes):
        self.dateiname = dateiname
        self.min_bytes = min_bytes
        self.max_bytes = max_bytes
        self.anzahl_bytes = anzahl_bytes

    def __str__(self):
        details = "Datei \"{0}\" hat die falsche Größe! ".format(self.dateiname)
        details += "Länge: {0}".format(self.anzahl_bytes)
        details += " (Min: {0}, Max: {1})".format(self.min_bytes, self.max_bytes)
        return details


# Beispielfunktion
def datei_auslesen(dateiname, min_bytes, max_bytes):
    anzahl_bytes = 94  # So tun, als hätten wir Daten gelesen

    if anzahl_bytes < min_bytes or anzahl_bytes > max_bytes:
        # Erwartete Länge stimmt nicht, Exception werfen
        raise(DateiFormatException(dateiname, min_bytes, max_bytes, anzahl_bytes))


# Hauptprogramm
def main():
    try:
        datei_auslesen("Testdatei.txt", 20, 40)
    except DateiFormatException as error:
        print("Exception des Typs \"DateiFormatException\" gefangen")
        print("Information zur Exception:")
        print(error)

        print("\nInhalt des Tupels:")
        print("args:", error.args)


main()
