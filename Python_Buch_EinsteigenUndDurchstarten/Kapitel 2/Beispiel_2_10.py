# Beispiel 2.10
#
# Der erste Fehlerquelltext
#
speicherplatz = input("Speicherplatz gesamt (in Gigabyte): ")
belegt = input("Belegter Speicherplatz: ")

belegt_in_prozent = belegt * 100 / speicherplatz
frei_in_prozent = 100 - Belegt_in_prozent

print("Auf der Festplatte sind noch", frei_in_prozent, "% frei")
print(belegt_in_prozent, "% sind bereits belegt")
