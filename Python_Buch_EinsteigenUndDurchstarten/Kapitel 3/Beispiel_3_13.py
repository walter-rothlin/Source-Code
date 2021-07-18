# Beispiel 3.13
#
# Fehlerquelltext
#

# Höhe und Breite des Rechtecks abfragen
hoehe = int(input("Höhe des Rechtecks: "))
breite = int(input("Breite des Rechtecks: "))

if hoehe < 3 and breite < 3:
    # Rechteck muss groß genug für einen Rahmen sein
    print("Ungültige Werte!")
else:
    # Verschachtelte Schleife zum Zeichnen
    for y in range(0, hoehe):
        for y in range(0, breite):
            if (x == 0) or (y == 0) or (x == breite) or (y == hoehe):
                # Rand zeichnen
                print("-", end="")
            else:
                # Füllung zeichnen
                print("*", end="")
        # Zeilenumbruch
        print("")
