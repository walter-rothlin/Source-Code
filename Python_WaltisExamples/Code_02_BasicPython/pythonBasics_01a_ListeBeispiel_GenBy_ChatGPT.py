# Eine Liste von Zahlen
numbers = [1, 2, 3, 4, 5]

# Ausgabe der gesamten Liste
print("Die Liste der Zahlen lautet:", numbers)

# Ausgabe des ersten Elements
print("Das erste Element der Liste ist:", numbers[0])

# Ausgabe des letzten Elements
print("Das letzte Element der Liste ist:", numbers[-1])

# Ändern des dritten Elements
numbers[2] = 10
print("Die Liste nach der Änderung des dritten Elements lautet:", numbers)

# Hinzufügen eines Elements am Ende der Liste
numbers.append(6)
print("Die Liste nach dem Hinzufügen einer weiteren Zahl lautet:", numbers)

# Hinzufügen eines Elements an einer bestimmten Position in der Liste
numbers.insert(2, 7)
print("Die Liste nach dem Hinzufügen einer weiteren Zahl an der dritten Position lautet:", numbers)

# Entfernen eines Elements aus der Liste
numbers.remove(4)
print("Die Liste nach dem Entfernen der Zahl 4 lautet:", numbers)

# Sortieren der Liste in aufsteigender Reihenfolge
numbers.sort()
print("Die Liste nach dem Sortieren in aufsteigender Reihenfolge lautet:", numbers)

# Sortieren der Liste in absteigender Reihenfolge
numbers.sort(reverse=True)
print("Die Liste nach dem Sortieren in absteigender Reihenfolge lautet:", numbers)