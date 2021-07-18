# Beispiel 9.10
#
# makedirs und removedirs
#
import os

# Gewünschte Verzeichnisstruktur
pfad = "Bilder/2016/Mai/Urlaub/"

# Verzeichnisstruktur anlegen und in Basispfad wechseln
os.makedirs("Dateien/" + pfad, exist_ok=True)
os.chdir("Dateien")

# Löschen, falls gewünscht
abfrage = input("Verzeichnisstruktur löschen (J/N): ")

if abfrage == "j" or abfrage == "J":
    os.removedirs(pfad)
