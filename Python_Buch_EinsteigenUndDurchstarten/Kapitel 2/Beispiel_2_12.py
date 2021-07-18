# Beispiel 2.12
#
# Lösung zur Aufgabenstellung
#
fliesskommazahl = float(input("Fließkommazahl eingeben: "))

vorkommaanteil = int(fliesskommazahl)
nachkommaanteil = (fliesskommazahl - vorkommaanteil)

print("Vorkommaanteil: ", vorkommaanteil)
print("Nachkommaanteil: {0:.6f}".format(nachkommaanteil))
