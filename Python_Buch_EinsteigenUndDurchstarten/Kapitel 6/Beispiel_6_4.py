# Beispiel 6.4
#
# Lösung zur Aufgabe 6.1
#

# Eine Liste initialisieren
farben = ["blau", "gelb", "blau", "grün", "blau", "schwarz", "rot", "blau"]

# Über die Liste anhand der Länge und des Indexes iterieren
laenge = len(farben)  # Länge der Liste ermitteln

print("Inhalt der Liste:")
for i in range(laenge):
    print(farben[i])
    
# Abfragen, welcher Eintrag entfernt werden soll
entfernen = input("Farbe, die entfernt werden soll: ")

# Solange remove aufrufen, bis Eintrag nicht mehr vorhanden
while entfernen in farben:
    farben.remove(entfernen)

print("Aufgeräumte Liste:")
print(farben)
