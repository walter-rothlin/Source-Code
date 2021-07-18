# Beispiel 6.28
#
# Über Dictionaries iterieren
#

# Ein Verzeichnis von Tieren und deren Klassen. Aber offensichtlich fehlerhaft!
tiere = {"Katze": "Säugetier", "Schlange": "Rebdil", "Krokodil": "Rebdil",
         "Guppy": "Fisch", "Spatz": "Insekt", "Amsel": "Vogel", "Ameise": "Insekt"}

print("Tierverzeichnis:", tiere)
print("Einträge gesamt:", len(tiere))

# Den Fehler korrigieren
tiere["Spatz"] = "Vogel"

# Ein weiteres Tier hinzufügen
tiere["Eisbär"] = "Säugetier"

# Iteration
print("\nDurch alle Schlüssel iterieren:")
for schluessel in tiere:
    print(schluessel, end=", ")

# Rechtschreibfehler korrigieren (recht umständlich, aber möglich)
print("\nRechtschreibprüfung...")
for eintrag in tiere.items():
    schluessel, wert = eintrag
    if tiere[schluessel] == "Rebdil":
        tiere[schluessel] = "Reptil"
        print("Es wurde ein Fehler korrigiert!")

print("\n\nDurch alle Werte iterieren:")
for wert in tiere.values():
    print(wert, end=", ")

# Alle vorhandenen Schlüssel in eine Liste kopieren:
print("\n\nAlle Schlüssel:", tiere.keys())

schluessel_liste = list(tiere.keys())
print("Alle Schlüssel als richtige Liste:", schluessel_liste)
