# Beispiel 6.30
#
# Fehlerquelltext
#

# Dictionary mit zu sortierenden Zahlen
zahlen = {1: False, 2: True, 3: True, 4: False, 5: True, 6: False, 7: True}

# Listen, in die die Zahlen hineinsortiert werden sollen
primzahlen = ()
zusammengesetzte_zahlen = ()

print("Die folgenden Zahlen werden sortiert:", zahlen)

# Durch das Dictionary iterieren und Zahlen in Listen einsortieren
for eintrag in zahlen.items():
    zahl, prim = eintrag
    if prim:
        primzahlen.append(zahl)
    else:
        zusammengesetzte_zahlen.append(zahl)

    # Eintrag wurde einsortiert, kann also gelöscht werden
    del zahlen[zahl]

# Ergebnisse zeigen
print("Liste von Primzahlen:", primzahlen)
print("Liste von zusammengesetzten Zahlen:", zusammengesetzte_zahlen)

print("Verbleibende Zahlen zum Sortieren:", zahlen)
