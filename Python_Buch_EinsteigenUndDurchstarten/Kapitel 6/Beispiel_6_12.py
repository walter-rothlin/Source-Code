# Beispiel 6.12
#
# Tupel
#

# Die ersten zehn Primzahlen
primzahlen = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29)

# Weitere Primzahlen
mehr_primzahlen = (31, 37, 41, 43, 47)

# Zugriff per Index
print("Dritte Primzahl:", primzahlen[2])

# Tupel verbinden
primzahlen += mehr_primzahlen
print("Die ersten 15 Primzahlen:", primzahlen)

# Tupel mit nur einem Element sind etwas speziell...
weitere_primzahl = (53,)
primzahlen += weitere_primzahl

print("Die ersten 16 Primzahlen:", primzahlen)

# Tupel zu Listen hinzufügen ist möglich...
magische_zahlen = [4, 8, 15, 16, 23, 42]
magische_zahlen += primzahlen

print("Liste, die um den Inhalt eines Tupels erweitert wurde:\n", magische_zahlen)

# ...umgekehrt jedoch nicht!
#mehr_primzahlen += magische_zahlen

# Verändern ist auch nicht erlaubt
#primzahlen[3] = 10
