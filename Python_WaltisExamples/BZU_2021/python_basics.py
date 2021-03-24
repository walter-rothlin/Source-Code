#!/usr/bin/python3

# print (Ausgabe)
# ===============
print("Hello BZU")
print('Hello', "BZU", 2021, 3.1415, 1.0)

# Variablen
# =========
pi = 3.1415			  # float
radius = 1.0    	  # float
durchmesser_02 = 20	  # integer
figureName = "Kreis"  # String
figurename = 'Wuerfel'# String
ende = True           # boolean
schluss = False       # boolean
flaeche = radius * radius * pi  # float

# Operationen / Berechnungen
# ==========================
print(pi * 2, radius, schluss, figureName)
print(5 * 3)		# int multiplikation
print(5.0 * 3.0)    # float multiplikation
print(5 * 3.0)      # float multiplikation
print(2   ** 4)     # Potenz
print(16 / 2)       # float division
print(17/2)			# float division
print(16 // 2)      # integer division
print(17//2)		# integer division (mit Rest)
print(17 % 2)       # ganzahliger Rest der Division

print("55" + "66" + "Hallo" + figurename + str(pi) + str(True))  # String concatination
print("456Hallo" * 3)  # String repeat

print(ende, schluss, ende and schluss, ende or not schluss)
print(5 >= 9)       # boolean vergleich
print("Hallo" == "Hallo ")
print("Adam" >= "Eva")

# input
# =====
radius = float(input("Wie gross ist der Radius:"))
print("Flaeche:",radius**2*pi)

# Verzweigungen
# =============
if True:
	print("es ist wahr!!!")
	if True:
		print("nochmals wahr!!!!")
	else:
		print("und nicht wahr!")
else:
	print("es ist NICHT wahr!!!!")

antwort = input("Ja oder Nein:")
if antwort == "Ja" or antwort == "JA" or antwort == "ja":
	print("Du hast JA gesagt!!!")
elif antwort == "Nein" or antwort == "Nein" or antwort == "nein":
	print("Du hast NEIN gesagt")
else:
	print("Du hast irgend etwas gesagt!!!")
print("Schluss")

# Schleifen (Loops)
# =================
while antwort == "Ja":
	print("ich bin in der Schleife")
	antwort = input("Weiter? Ja oder Nein:")

zahlenWert = 0
while zahlenWert<=10:
	print(zahlenWert, zahlenWert ** 2, 2 ** zahlenWert)
	zahlenWert += 1

for i in (2, 4, 8, 1, 6):
	print(i, i**2, 2**i)
print()

for i in range(9):
	print(i)
print()

for i in range(10, 23):
	print(i)
print()

for i in range(7, 23, 3):
	print(i)
print()

for i in (1, 3.4, "BZU", False, 3*pi):
	print(i)
print()

# Eigenen Funktionen
# ==================
def calcKreisUmfang(durchmesser):
	return durchmesser * 3.1415

def calcKreisFlaeche(radius):
	return radius ** 2 * 3.1415

d = float(input("Durchmesser: "))
print("Umfang = ", round(calcKreisUmfang(d),2))
print("Flaeche = ", round(calcKreisFlaeche(d/2),2))



