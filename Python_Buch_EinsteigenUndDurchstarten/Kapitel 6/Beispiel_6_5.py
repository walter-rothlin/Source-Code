# Beispiel 6.5
#
# Einfache Sortierung
#

# Eine Liste initialisieren und ausgeben
zahlen = [75, 85, 81, 46, 11, 3, 19, 45, 10, 15]
strings = ["wasserstoff", "brom", "uran", "aluminium", "zink", "argon", "neon"]

# Zahlen sortieren
print("Unsortierte Zahlen:", zahlen)
zahlen.sort()
print("Aufsteigend sortierte Zahlen:", zahlen)

# Strings sortieren
print("\nUnsortierte Strings:", strings)
strings.sort(reverse=True)
print("Absteigend sortierte Strings:", strings)

# Die Reihenfolge lässt sich auch direkt umkehren:
zahlen.reverse()
print("\nGeänderte Reihenfolge:", zahlen)

zahlen.append("vier")
# Das hier wird leider nicht funktionieren und zu einer Fehlermeldung führen:
#zahlen.sort()
