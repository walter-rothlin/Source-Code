# Beispiel 2.8
#
# Fließkommazahlen formatiert ausgeben
#
wert1 = 1.0 / 3.0
wert2 = 10.0 / 7.0

# Unformatierte Ausgabe:
print("Wert 1: {0}, Wert 2: {1}".format(wert1, wert2))

# Formatierte Ausgabe:
print("Wert 1: {0:.2f}, Wert 2: {1:.4f}".format(wert1, wert2))
wert3 = 5.0 / 2.0
print("Wert 3: {0:.5f}".format(wert3))
