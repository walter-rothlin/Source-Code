# Beispiel 9.5
#
# Text in eine Datei schreiben
#
datei = open("Dateien/Einkaufsliste.txt", "w", encoding="utf-8")

# Titel der Einkaufsliste schreiben
datei.write("Einkaufsliste")
datei.write("-------------")

# Daten sicherheitshalber sofort schreiben
datei.flush()

# Eine Liste zu kaufender Lebensmittel
einkauf = ["Eier", "Milch", "Mehl", "Wasser", "Fisch"]

# Zeilenumbrüche einfügen und Liste schreiben
datei.write("\n".join(einkauf))
datei.write("\n-----\n")

# Gesamte Liste auf einen Rutsch schreiben
datei.writelines(einkauf)

datei.close()
