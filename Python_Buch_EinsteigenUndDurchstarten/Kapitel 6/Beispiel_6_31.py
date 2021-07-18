# Beispiel 6.31
#
# Lösung zum Fehlerquelltext
#

# Dictionary mit zu sortierenden Zahlen
zahlen = {1: False, 2: True, 3: True, 4: False, 5: True, 6: False, 7: True}

# Listen, in die die Zahlen hineinsortiert werden sollen
primzahlen = []
zusammengesetzte_zahlen = []

print("Die folgenden Zahlen werden sortiert:", zahlen)

# So lange Elemente aus dem Dictionary löschen, bis es leer ist
while zahlen:
    zahl, prim = zahlen.popitem()
    if prim:
        primzahlen.append(zahl)
    else:
        zusammengesetzte_zahlen.append(zahl)

# Ergebnisse zeigen
print("Liste von Primzahlen:", primzahlen)
print("Liste von zusammengesetzten Zahlen:", zusammengesetzte_zahlen)

print("Verbleibende Zahlen zum Sortieren:", zahlen)
