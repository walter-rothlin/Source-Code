
# Print
# =====
print("Hello HWZ 2021")
print("Hello", 'hwz', 2021)

# Variablen
# =========
pi = 3.1415              # float
radius = 1.0             # float
durchmesser_02 = 20      # integer
figureName = "Kreis"     # string
figurename = "Quadrat"   # string
koerper = 'Würfel'       # string
aufhoeren = True         # boolean
ende = False             # boolean
flaeche = radius**2 * pi # float

# Berechnungen / Operatoren
# =========================
print(pi, figureName, aufhoeren, flaeche)
print(pi * 2.3)
print(5 * 3.0)     # float Multiplikation
print(2**4)        # Potenz
print(16/2)        # float Division
print(16//2)       # integer Division
print(17//2)       # integer Division
print(5 % 3)       # ganzahliger Rest der Division

print("55" + "66") # String concatination
print('31' * 5)    # String Wiederholung

print(ende and True)
print(ende or True)

# input
# =====
antwort = input("Ja oder Nein: ") # String
print("Deine Antwort war:", antwort)

r = float(input("Radius:"))
print("Kreisfläche = r**2 * pi =", r**2*pi)

# Verzweigungen
# =============
if antwort == "Ja" or antwort == "ja" or antwort == "JA":
    print("Du hast Ja gesagt!!!")
    print("Vielen Dank!")
else:
    print("Wieso hast du nicht JA gesagt?")
    if antwort == "Nein":
        print("Du hast Nein gesagt")
    elif antwort == "NEIN":
        print("Du hast NEIN gesagt")
    else:
        print("Du hast weder Ja noch Nein gesagt!!!!")

# Schleifen
# =========
ant = "Ja"
while (ant == "Ja"):
    print("Ich bin in der Schleife")
    ant = input("Soll ich weiter machen? ")

# for-Schleife
# ============
for i in (1, 4, 7, 8, 9):
    print(i, i**2)
print("Hallo\tHWZ \n\nHWZ")

for i in range(7):
    print(i, i**2)
print()

for i in range(2, 9):
    print(i, i**2)
print()

for i in range(2, 9, 3):
    print(i, i**2)
print()

for i in (3, 1.0, "45", "HWZ", True, 6):
    print(i)


# Umfang vom Kreis
# ================
durchmesser = float(input("Durchmesser: "))
umfang = durchmesser * pi
print("Durchmesser:", durchmesser, " --> Umfang:", umfang)


def calcUmfang(d):
    return d * 3.1415

durchmesser = float(input("Durchmesser: "))
umfang = calcUmfang(durchmesser)
print("Durchmesser:", durchmesser, " --> Umfang:", round(umfang, 2))

