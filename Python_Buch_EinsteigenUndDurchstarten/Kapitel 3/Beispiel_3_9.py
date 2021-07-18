# Beispiel 3.9
#
# Eine einfache for-Schleife
#

# Variablen für den Zähler abfragen
start = int(input("Startwert des Zählers: "))
ende = int(input("Endwert des Zählers: "))
schrittweite = int(input("Schrittweite des Zählers: "))

# Zählschleife durchlaufen
for i in range(start, ende, schrittweite):
    print(i)
