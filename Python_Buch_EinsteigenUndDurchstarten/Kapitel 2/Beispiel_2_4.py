# Beispiel 2.4
#
# Konvertierung von Datentypen - korrigierte Version
#
dollarkurs = input("Bitte aktuellen Dollarkurs eingeben: ")
kapital_in_euro = input("Bitte Kapital in Euro eingeben: ")

kapital_in_dollar = float(kapital_in_euro) * float(dollarkurs)

print(kapital_in_euro, "€ entsprechen", kapital_in_dollar, "$")
