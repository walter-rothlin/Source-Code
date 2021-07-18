# Beispiel 6.16
#
# Strings sind ebenfalls Container
#

satz = "Strings sind auch nur Container"

# Verschiedene Arten der Iteration
print("Über jedes Element iterieren:")
for buchstabe in satz:
    print(buchstabe, end="")

print("\n\nZugriff über Index:")
for i in range(len(satz)):
    print(satz[i], end="")

# Das funktioniert leider nicht
#satz[3] = 'ü'
