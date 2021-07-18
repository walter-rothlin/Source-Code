# Beispiel 9.8
#
# join
#
import os

# Pfad zusammenbauen
aktuelles_verzeichnis = os.getcwd()
pfad = os.path.join(aktuelles_verzeichnis, "Dateien")
pfad = os.path.join(pfad, "Bilder", "2016", "Mai", "Urlaub")

print("Der Pfad lautet:")
print(pfad)
