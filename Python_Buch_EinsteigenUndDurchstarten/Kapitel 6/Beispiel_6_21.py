# Beispiel 6.21
#
# strip, lstrip und rstrip
#

# Einige Strings, die zur direkten Verarbeitung eher ungeeignet sind
benutzereingabe = "  \tMax Mustermann  "
datum = "Datum: 01.01.2018"
preis = "3.99 €"
chat_zeile = "Ich habe eine Frage ??! ?!?!?"

print("Ungemütliche Strings:")
print(benutzereingabe)
print(datum)
print(preis)
print(chat_zeile)

print("\nDas ist schon besser:")

# Alle Whitespaces links und rechts entfernen
print(benutzereingabe.strip())

# Nur auf der linken Seite entfernen
print(datum.lstrip("Datum: "))

# Nur auf der rechten Seite entfernen
print(preis.rstrip(" €"))
print(chat_zeile.rstrip("!? "))
