# Beispiel 9.12
#
# Kopieren und Verschieben
#
import os
import shutil

# Achtung: Bei Neustart des Beispiels das folgende Verzeichnis zuerst löschen!
pfad = os.getcwd() + "/Dateien/Verschieben"

# Ein paar Verzeichnisse anlegen
os.makedirs(pfad, exist_ok=True)
os.chdir(pfad)
os.makedirs("Notizen", exist_ok=True)
os.makedirs("Archiv", exist_ok=True)

# Zwei Dateien erzeugen
open("Einkaufsliste.txt", "w").close()
open("Erledigt.txt", "w").close()

# Datei verschieben
input("Enter drücken, um fortzufahren")
shutil.move("Erledigt.txt", "Archiv/")

# Datei kopieren
input("Enter drücken, um fortzufahren")
shutil.copy("Einkaufsliste.txt", "Notizen/")
shutil.copy("Einkaufsliste.txt", "Notizen/Einkaufen.txt")

# Gesamtes Verzeichnis verschieben
input("Enter drücken, um fortzufahren")
shutil.move("Notizen/", "Archiv/")

# Ein Backup erstellen
input("Enter drücken, um fortzufahren")
shutil.copytree("Archiv/", "Archiv_Backup/")
