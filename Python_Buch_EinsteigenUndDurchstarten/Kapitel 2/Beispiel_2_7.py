# Beispiel 2.7
#
# Seltsame Genauigkeitsprobleme
#
wert = 0.0

# Dreimal ein Zehntel addieren
wert += 0.1
wert += 0.1
wert += 0.1

print(wert)

# Das hier sollte 1.0 ergeben
print((1.0 / 49.0) * 49.0)
