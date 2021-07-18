# Beispiel 11.1
#
# Grundlagen des Debuggens
#
multiplikator = 10

# Abfragen der Werte
erster_wert = int(input("Bitte ersten Wert eingeben: "))
zweiter_wert = int(input("Bitte zweiten Wert eingeben: "))

# Berechnung durchführen und Ergebnis anzeigen
ergebnis = erster_wert + zweiter_wert
ergebnis * 10  # Ein (recht offensichtlicher) Fehler in der Berechnung

print("Ergebnis:", ergebnis)
