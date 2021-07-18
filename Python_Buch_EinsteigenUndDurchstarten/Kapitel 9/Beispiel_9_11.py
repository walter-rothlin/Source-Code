# Beispiel 9.11
#
# rename und replace
#
import os

pfad = os.getcwd() + "/Dateien/Umbenennungen"

# Ein paar Verzeichnisse anlegen
os.makedirs(pfad, exist_ok=True)
os.chdir(pfad)
os.makedirs("Bilder", exist_ok=True)

# Zwei Dateien erzeugen
open("Final.txt", "w").close()
open("Original.txt", "w").close()

# Umbenennungen
input("Enter drücken, um fortzufahren")
os.rename("Original.txt", "Bearbeitet.txt")

input("Enter drücken, um fortzufahren")
os.replace("Bearbeitet.txt", "Final.txt")

# Ordner umbenennen und Datei hineinbewegen. Nicht empfohlen
input("Enter drücken, um fortzufahren")
os.replace("Bilder", "Texte")
os.replace("Final.txt", "Texte/Final.txt")
