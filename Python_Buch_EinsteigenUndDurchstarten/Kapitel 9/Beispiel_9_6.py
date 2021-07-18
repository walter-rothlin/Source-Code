# Beispiel 9.6
#
# Verzeichnisse anzeigen und wechseln
#
import os

# Inhalt des aktuellen Verzeichnisses ausgeben
aktuelles_verzeichnis = os.getcwd()
print("Aktuelles Verzeichnis:", aktuelles_verzeichnis)

print("\nInhalt dieses Verzeichnisses:")
print(os.listdir(aktuelles_verzeichnis))

# In ein Unterverzeichnis wechseln und dessen Inhalt ausgeben
print("\nVerzeichniswechsel...")
os.chdir(aktuelles_verzeichnis + "/Dateien")

print("\nInhalt des Verzeichnisses:")
print(os.listdir(os.getcwd()))
