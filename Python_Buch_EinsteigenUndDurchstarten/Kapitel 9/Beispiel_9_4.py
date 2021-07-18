# Beispiel 9.4
#
# Zeilenweises Auslesen
#
datei = open("Dateien/ToDo-Liste.txt", encoding="utf-8")

# Alle Zeilen auslesen und in eine Liste packen
zeilen = datei.readlines()
print(zeilen)

# Position befindet sich am Ende, also zurücksetzen
datei.seek(0)

# Über alle Zeilen der Textdatei iterieren
for zeile in datei:
    print(zeile.strip())

datei.close()
