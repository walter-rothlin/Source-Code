# Beispiel 6.27
#
# Zugriff absichern
#

# Dictionary erzeugen
schmelzpunkte = {"Fluor": -220, "Krypton": -157, "Argon": 64, "Gold": 1064}

# Sicherstellen, dass das gesuchte Element existiert
if "Platin" in schmelzpunkte:
    print("Platin schmilzt bei {0} Grad Celsius".format(schmelzpunkte["Platin"]))
else:
    print("Element wurde nicht gefunden!")

# Eine weitere Möglichkeit der Überprüfung
schmelzpunkt = schmelzpunkte.get("Dastoolium", "Unbekannt")
print("Schmelzpunkt von Dastoolium:", schmelzpunkt)
