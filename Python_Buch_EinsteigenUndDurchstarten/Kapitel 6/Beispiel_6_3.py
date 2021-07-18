# Beispiel 6.3
#
# Elemente entfernen
#

# Eine Liste initialisieren
leckeres_essen = ["Knödel", "Gulasch", "Bruschetta", "Leber", "Eis"]

print("Das hier ist leckeres Essen, oder?")
print(leckeres_essen)

entfernen = input("Nicht einverstanden? Welcher Eintrag soll entfernt werden?: ")

# Versuchen, den Eintrag zu entfernen
if entfernen in leckeres_essen:
    leckeres_essen.remove(entfernen)
else:
    print("Dieser Eintrag ist nicht vorhanden")

print("\nKorrigierte Liste:")
print(leckeres_essen)

# Element über dessen Index aus einer Liste entfernen
farben = ["violett", "gelb", "Rauhaardackel", "grün", "blau", "schwarz", "rot"]
print("\nFehlerhafte Farbliste:")
print(farben)

del farben[2]
print("\nKorrigierte Farbliste")
print(farben)

# Entferntes Element zurückliefern lassen
entfernte_farbe = farben.pop(0)

print("\nFarbe entfernt:", entfernte_farbe)
print("Farbliste:")
print(farben)

# Element ersetzen
print("\nEine Farbe ersetzen:")
farben[3] = "beige"
print(farben)
