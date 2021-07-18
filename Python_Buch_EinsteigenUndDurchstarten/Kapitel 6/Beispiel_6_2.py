# Beispiel 6.2
#
# Listen dynamisch erzeugen
#

# Eine leere Liste erzeugen
namensliste = []

# Die Liste dynamisch mit Inhalt füllen
while True:
    name = input("Bitte einen Namen eingeben (leer für Ende): ")

    if name == "":
        break

    namensliste.append(name)

# Einen Eintrag an einer bestimmten Stelle einfügen
namensliste.insert(2, "Sun")

# Liste und die Anzahl ihrer Elemente ausgeben
print("Die Liste enthält {0} Einträge".format(len(namensliste)))
print(namensliste)

# Prüfen, ob sich ein bestimmter Name in der Liste befindet
name = input("Nach welchem Namen soll gesucht werden: ")

if name in namensliste:
    print("Name wurde gefunden")
else:
    print("Name wurde nicht gefunden")
