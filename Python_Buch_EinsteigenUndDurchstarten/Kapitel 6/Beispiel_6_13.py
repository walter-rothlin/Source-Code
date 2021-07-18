# Beispiel 6.13
#
# Die feinen Details
#


# Eine Liste erzeugen und diese einem Tupel hinzufügen
liste = [4, 5, 6]
tupel = (1, 2, 3, liste, 7, 8)

# Instanzen innerhalb eines Tupels sind sehr wohl veränderlich!
print("Inhalt des Tupels vor der Veränderung:", tupel)

# Die Liste im Tupel umkehren
tupel[3].reverse()
print("Inhalt des Tupels nach der Veränderung:", tupel)

# Noch mehr Magie:
liste.reverse()
print("Der Beweis, dass es sich um Referenzen handelt:", tupel)
