# Beispiel 2.11
#
# Korrigierter Fehlerquelltext
#
speicherplatz = int(input("Speicherplatz gesamt (in Gigabyte): "))
belegt = int(input("Belegter Speicherplatz: "))

belegt_in_prozent = belegt * 100 / speicherplatz
frei_in_prozent = 100 - belegt_in_prozent

print("Auf der Festplatte sind noch", frei_in_prozent, "% frei")
print(belegt_in_prozent, "% sind bereits belegt")
