# Beispiel 2.2
#
# Rechnen mit Variablen
#
dollarkurs = 1.21
kapital_in_euro = 2500
wechselgebuehr = 10
endbetrag = kapital_in_euro

# Umrechnung von Euro in Dollar. Punkt-vor-Strich beachten!
endbetrag = (kapital_in_euro * dollarkurs) - wechselgebuehr

# Ausgabe der Werte
print("Du wechselst", kapital_in_euro, "Euro in Dollar")
print("Aktueller Dollarpreis:", dollarkurs, "€")
print("Wechselgebühr:", wechselgebuehr, "€")
print("Nach dem Geldwechsel besitzt Du", endbetrag, "$")
