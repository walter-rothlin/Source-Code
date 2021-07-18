# Beispiel 6.20
#
# split und join
#

# Eine Liste von Rebsorten
rebsorten = ["Cabernet Sauvigon", "Merlot", "Zinfandel", "Syrah", "Pinot Grigio",
             "Weißer Burgunder", "Riesling", "Chardonnay"]

print("Eine Liste von Rebsorten:")
print(rebsorten)

# Die Einträge der Liste zu einem String verbinden. " - " als Trennzeichen
rebsorten_string = " - ".join(rebsorten)

print("\nDieses Mal als String:")
print(rebsorten_string)

# Den String wieder zerlegen und in eine Liste packen
print("\nAus dem String generierte Liste:")
print(rebsorten_string.split(" - "))

print("\nMaximale Anzahl der Splits begrenzen:")

# Die Maximale Anzahl an Splits begrenzen
log_eintrag = "03.01.2018.Würfelförmiges Raumschiff entdeckt. Sind besorgt."
print(log_eintrag.split(".", 3))

# Das geht auch von rechts
log_eintrag = "Heute keine besonderen Vorkommnisse.04.01.2018"
print(log_eintrag.rsplit(".", 3))
