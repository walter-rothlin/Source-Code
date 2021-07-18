# Beispiel 6.18
#
# Slicing
#

# Ein Zitat als Beispiel
spock = "Es ist keine Lüge, wenn man die Wahrheit für sich behält!"
print("Das originale Zitat lautet: " + spock)

# Verschiedene Arten des Slicings
slice_1 = spock[:17]    # Von Anfang an bis Position X kopieren
slice_2 = spock[17:]    # Ab Position X bis zum Ende kopieren
slice_3 = spock[3:17]   # Von Position X bis zu Position Y kopieren
slice_4 = spock[28:40]  # Von Position X bis zu Position Y kopieren

# Ausgabe der einzelnen Slices
print("Zusammengesetztes Zitat:", slice_1 + slice_2)
print("Unvollständiges Zitat:", slice_4 + " " + slice_3)

# Slicing mit festgelegter Schrittweite
muster = "0001000200030004000500060007"
print("Slicing mit Schrittweite: " + muster[7:24:4])

# Mit einem Trick gehts auch rückwärts!
geheimbotschaft = "!neßartS eniek riw nehcuarb ,nerhafnih riw oW ?neßartS"
entschluesselung = geheimbotschaft[::-1]

print(entschluesselung)
