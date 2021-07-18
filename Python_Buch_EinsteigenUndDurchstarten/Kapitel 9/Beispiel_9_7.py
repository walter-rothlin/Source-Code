# Beispiel 9.7
#
# Pfade
#
import os

# Verzeichnis, in dem wir arbeiten wollen
cwd = os.getcwd() + "/Dateien"
dateipfad = cwd + "/Einkaufsliste.txt"

# Einen Pfad zu einem Ordner analysieren
print("Analyse des Pfads:", cwd)
print("Ist ein Verzeichnis:", os.path.isdir(cwd))
print("Ist eine Datei:", os.path.isfile(cwd))
print("Existiert:", os.path.exists(cwd))
print("Basisname:", os.path.basename(cwd))
print("Verzeichnis:", os.path.dirname(cwd))

# Einen Pfad zu einer Datei analysieren
print("\nAnalyse des Pfads:", dateipfad)
print("Ist ein Verzeichnis:", os.path.isdir(dateipfad))
print("Ist eine Datei:", os.path.isfile(dateipfad))
print("Existiert:", os.path.exists(dateipfad))
print("Basisname:", os.path.basename(dateipfad))
print("Verzeichnis:", os.path.dirname(dateipfad))

# In Dateinamen- und Endungen aufteilen
print("\nDateiname aus Pfad extrahieren:", os.path.split(dateipfad))
print("Dateiendung extrahieren:", os.path.splitext(dateipfad))
