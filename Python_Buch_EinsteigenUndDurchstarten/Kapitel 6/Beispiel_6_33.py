# Beispiel 6.33
#
# Sets: Elemente hinzufügen und entfernen
#

# Ein Set verschiedener Stilrichtungen
stile = set(["Punk", "Ska", "Rap", "HipHop", "Blues", "Klassik", "Rock"])

# Eine wichtige Stilrichtung wurde vergessen
stile.add("Metal")

print("Musikrichtungen:", stile)

# Entfernen, was nicht gefällt:
stile.remove("Rap")  # Wirft eine Exception, wenn Eintrag nicht vorhanden!
stile.discard("HipHop")  # Wenn nicht vorhanden, passiert nichts

print("Persönlicher Geschmack:", stile)

# Beliebige Elemente entfernen
print("Zufällig abspielen:", stile.pop())
print("Als Nächstes kommt:", stile.pop())

print("Noch nicht abgespielte Musikrichtungen: ", stile)
