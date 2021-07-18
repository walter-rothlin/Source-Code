# Beispiel 9.2
#
# Fehler abfangen
#

# Mal sehen, ob das gutgeht...
try:
    # Datei öffnen. "close" erfolgt implizit beim Verlassen des Blocks
    with open("Dateien/Sprichwort", encoding="utf-8") as datei:
        # Öffnen hat funktioniert, Inhalt ausgeben
        print(datei.read())
except FileNotFoundError:
    print("Datei konnte nicht gefunden werden!")
