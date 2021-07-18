# Beispiel 9.9
#
# Verzeichnisoperationen
#
import os

# Temporäres Verzeichnis anlegen
# Achtung: Bei Neustart des Beispiels das Verzeichnis zuerst löschen!
temp_verzeichnis = os.getcwd() + "/Dateien/Temp"
os.mkdir(temp_verzeichnis)

# In das Verzeichnis wechseln
os.chdir(temp_verzeichnis)
print("Aktuelles Verzeichnis: ", os.getcwd())

# Einen Ordner und eine Datei anlegen
os.mkdir("Logfiles")
open("Ergebnis.txt", "w").close()

# Das würde einen "FileExistsError" erzeugen
#os.mkdir("Logfiles")

abfrage = input("Temporäre Dateien löschen? (J/N): ")

if abfrage == "j" or abfrage == "J":
    # Ordner und Datei wieder löschen
    os.rmdir("Logfiles")
    os.remove("Ergebnis.txt")
    os.chdir("..")
    os.rmdir("Temp")
    print("Temporäre Dateien erfolgreich gelöscht!")

# Löschen nicht vorhandener Dateien/Verzeichnisse führt zu einem Fehler:
#os.remove("Logfiles")
#os.rmdir("Ergebnis.txt")
