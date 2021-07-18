# Beispiel 9.3
#
# Schrittweises Auslesen einer Datei
#
datei = open("Dateien/Datenstrom.txt", encoding="utf-8")

# Viermal jeweils fünf Zeichen lesen und ausgeben
for i in range(4):
    print("5 Zeichen lesen:", datei.read(5))

# Anzeigen, wo wir uns befinden
print("Position im Datenstrom:", datei.tell())

# Zeile bis zum Ende lesen
print("Rest der aktuellen Zeile lesen:", datei.readline())
print("Position im Datenstrom:", datei.tell())

print("Nächste Zeile lesen:", datei.readline())  # Kein Zeilenumbruch mehr!

# Position im Datenstrom neu setzen und erneut etwas auslesen
datei.seek(10)
print("Ab Position 10 nochmal 5 Zeichen lesen:", datei.read(5))

datei.close()
