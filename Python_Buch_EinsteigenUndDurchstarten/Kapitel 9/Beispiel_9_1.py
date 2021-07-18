# Beispiel 9.1
#
# Den Inhalt einer einfachen Textdatei ausgeben
#

# Datei öffnen
datei = open("Dateien/Sprichwort.txt", encoding="utf-8")

# Datei auslesen und Inhalt ausgeben
inhalt = datei.read()
print(inhalt)

# Nicht vergessen, die Datei zu schließen!
datei.close()
