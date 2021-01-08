# ------------------------------------------------------------------
# Name: A_Listen
#
# Description: List methoden
#
# Autor: Walter Rothlin
#
# History:
# 17-Dec-2020   Walter Rothlin      Initial Version
# -----------------------------------------------------------------

squares = [4, 9]
print(squares)
print(squares[0], "*", squares[1], "=", squares[0] * squares[1])

einkaufsListe = ['Brot', 'Milch', 'Wurst', 12, 13.45, True]
print(einkaufsListe[2])
print(einkaufsListe[3] + einkaufsListe[4])
print(einkaufsListe[1] + einkaufsListe[2])
subListe = einkaufsListe[0:2]
print("SubListe:", einkaufsListe[0:2], "Ende")
print("SubListe:", subListe, "Ende")
print("SubListe:", subListe[0], "Ende")
print("SubListe:", einkaufsListe[0:2][1], "Ende")
print("SubListe:", einkaufsListe[2:2], "Ende")
print("SubListe:", einkaufsListe[:2], "Ende")
print("SubListe:", einkaufsListe[3:], "Ende")

for artikel in einkaufsListe:
    print(artikel)

einkaufsListe = [['Brot', 'Milch', 'Wurst'], [12, 13.45], True, 16, 12]
print(einkaufsListe)
print(einkaufsListe[1][1])
print(einkaufsListe[1])

print(squares)
squares.append([16, 12])
squares.extend([16, 12])
squares.insert(0, 1)
print(squares)
squares.remove(9)
squares.pop(0)
print(squares)
print(squares.index(25))

print("Copy")
print("squares       :", squares)
mySquares_Copy = squares.copy()
mySquares_Copy.append("Ende")
mySquares = squares
mySquares.append("Ende_2")
print("squares       :", squares)
print("mySquares_Copy:", mySquares_Copy)
print("mySquares     :",mySquares)

