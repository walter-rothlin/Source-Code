# Beispiel 6.32
#
# Verschiedene Möglichkeiten, ein Set zu erzeugen
#

# Ein Set aus einer Liste erzeugen
farben = set(["Grün", "Gelb", "Rot", "Blau", "Schwarz", "Gelb"])
print("Farben:", farben)

# Diese Syntax ist ebenfalls möglich, hat aber ihre Tücken
obst = {"Apfel", "Banane", "Kirsche", "Orange", "Kirsche", "Birne"}
print("Obst:", obst)

# Ein Tupel mit doppelten Monatsnamen erzeugen
monate_als_tupel = ("Januar", "Februar", "März", "April", "Januar", "März")
print("Monate (Tupel):", monate_als_tupel)

# Ein Frozenset aus einem Tupel erzeugen
monate = frozenset(monate_als_tupel)
print("Monate (Frozenset):", monate)
print("Monate (Tupel):", monate_als_tupel)

# Auch Strings sind iterierbare Objekte!
zeichen = set("Auch das geht!")
print("Benutzte Zeichen:", zeichen)
