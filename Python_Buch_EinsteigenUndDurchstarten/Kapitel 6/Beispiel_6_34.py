# Beispiel 6.34
#
# Mengenoperationen
#

# Fähigkeiten der einzelnen Teammitglieder
programmierung = set(("Anne", "Peter", "Marc", "Dennis", "Julien", "Tina"))
testing = set(("Daniel", "Anne", "Marc", "Thorsten", "Peter"))
design = set(("Peter", "Tina", "Thorsten", "Jan", "Jonas"))
leitung = set(("Marc", "Peter"))
nur_comicstil = set(("Tina", "Thorsten", "Jan"))

print("\nTeammitglieder, die programmieren können:\n", programmierung)
print("\nTeammitglieder, die testen können:\n", testing)
print("\nTeammitglieder, die designen können:\n", design)

# Das gesamte Team zusammenstellen
gesamtes_team = programmierung.union(testing)
gesamtes_team.update(design)
# Alternative Schreibweise: gesamtes_team = programmierung | testing | design
print("\nDas Team besteht aus:\n", gesamtes_team)

# Schnittmenge (Wer kann programmieren und testen?)
schnittmenge = programmierung.intersection(testing)
# Alternative Schreibweise: schnittmenge = programmierung & testing
print("\nTeammitglieder, die programmieren und testen können:\n", schnittmenge)

# Differenz (Wer kann programmieren, aber nicht designen?)
differenz = programmierung.difference(design)
# Alternative Schreibweise: differenz = programmierung - design
print("\nTeammitglieder, die programmieren, aber kein Design können\n", differenz)

# Symmetrische Differenz (Exklusiv-Oder) - Wer kann nur eins von beidem?
spezialisiert = design.symmetric_difference(testing)
# Alternative Schreibweise: spezialisiert = design ^ testing
print("\nTeammitglieder, die entweder nur testen oder nur designen können")
print(spezialisiert)

print("\nTeammitglieder mit Leitungserfahrung:", leitung)
print("Alle Leiter können programmieren:", leitung.issubset(programmierung))
# Alternative Schreibweise: leitung <= programmierung)

print("Alle Leiter können testen:", testing.issuperset(leitung))
# Alternative Schreibweise: testing >= leitung

print("Alle Leiter können designen:", leitung.issuperset(design))
# Alternative Schreibweise: leitung >= design

# Elemente einer Menge aus einer anderen entfernen
design.difference_update(nur_comicstil)
# Alternative Schreibweise: design -= nur_comicstil
print("\Designer, die für das nächste Projekt geeignet sind:")
print(design)
