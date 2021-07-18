# Beispiel 3.1
#
# Die if-Bedingung
#
# Temperaturwerte
ideale_temperatur = 28
minimal = 22
maximal = 32

# Aktuelle Temperatur ermitteln und auswerten
aktuelle_temperatur = int(input("Aktuelle Temperatur: "))

if aktuelle_temperatur == ideale_temperatur:
    print("Wohlfühltemperatur!")
    print("So kann es bleiben.")

if aktuelle_temperatur < minimal:
    print("Achtung, es ist zu kalt!")
    print("Heizung wird eingeschaltet")

if aktuelle_temperatur > maximal:
    print("Achtung, es ist zu warm!")
    print("Heizung wird ausgeschaltet")
