# Beispiel 3.4
#
# Logische Operatoren
#

# Temperaturwerte
heizung_an = False
minimal = 27
maximal = 32

# Aktuelle Temperatur ermitteln und auswerten
aktuelle_temperatur = int(input("Aktuelle Temperatur: "))

# Vergleich mit logischem "oder"
print("Vergleich mit logischem \"oder\":")

if (aktuelle_temperatur < minimal) or (aktuelle_temperatur > maximal):
    print("Temperaturwarnung!")
else:
    print("Temperatur ist OK")

# Vergleich mit logischem "und"
print("Vergleich mit logischem \"und\":")

if (aktuelle_temperatur >= minimal) and (aktuelle_temperatur <= maximal):
    print("Temperatur ist OK")
else:
    print("Temperaturwarnung!")

# Vergleich mit logischer Negierung
print("Vergleich mit logischer Negierung:")

if heizung_an:
    print("Heizung ist an")

if not heizung_an:
   print("Heizung ist aus")
