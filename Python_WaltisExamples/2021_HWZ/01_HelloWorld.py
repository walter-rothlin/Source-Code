
doThisSection = False
if doThisSection:
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


# Listen
# ======
# List is a collection which is ordered and changeable. Allows duplicate members.
squares = ["1", "4", "9", "16", "25", "36", "49", "49"]
print(squares)
print(squares[1])
print(len(squares))
print(squares[4])
print(squares[len(squares)-1])
print(squares[-1])
print(squares[2:4])

moreSquares = [36, 49, 64, 81, 100]
if (49 in moreSquares):
    print("49 ist eine Quadratzahl!")

if (not (50 in moreSquares)):
    print("50 ist keine Quadratzahl!")

if 50 not in moreSquares:
    print("50 ist keine Quadratzahl!")

# squares_1 = squares.copy()
squares_1 = squares
print("squares            -->", squares)
print("squares_1          -->", squares_1)
squares.clear()
print("squares            -->", squares)
print("squares_1          -->", squares_1)

cubes = [1, 8, 27, 65, 125, 27]  # something's wrong here
print("cubes                                  -->", cubes)
cubes[3] = 64
print("cubes                                  -->", cubes)
cubes.append(6**3)
print("cubes                                  -->", cubes)
cubes.remove(27)  # Removes the first item with the specified value
print("cubes                                  -->", cubes)
cubes.pop(1)    # Removes the element at the specified position
print("cubes                                  -->", cubes)
cubes.insert(1,8)
print("cubes                                  -->", cubes)
cubes.extend([7**3,8**3,9**3])
print("cubes                                  -->", cubes)
cubes.reverse()
print("cubes                                  -->", cubes)

cars = [["Ford",12,1960], ["Volvo",13], ["BMW",15]]
print(cars[1][0])
print(len(cars[1]))
for aCar in cars:
    print(aCar)
    for element in aCar:
        print("   ", element)


for i in [1,2,3,4,5,6]:
    print(i)

# Tuples
# ======
# Tuple is a collection which is ordered and unchangeable. Allows duplicate members.
carsTuple = ("Ford", "Volvo", "BMW", "Ford")
print("1st carsTuble      :", carsTuple[0])
#   carsTuple[0] = "Tesla"   # nicht erlaubt!!!! Tuples können nicht geändert werden!
print("Count of carsTuble :", len(carsTuple))

# Sets
# ====
# Set is a collection which is unordered and unindexed. No duplicate members.
carSet = {"Ford", "Volvo", "BMW", "Ford"}
print(carSet)
print(len(carSet))

if ("BMW" in carSet):
    print("BMW is in set")

if ("Fiat" in carSet):
    print("Fiat is in set")

# Dictonaries
# ===========
capital_country = {"United States": "Washington",
                   "US": "Washington",
                   "Canada": "Ottawa",
                   "Germany": "Berlin",
                   "France": "Paris",
                   "England": "London",
                   "UK": "London",
                   "Switzerland": "Bern",
                   "Austria": "Vienna",
                   "Netherlands": "Amsterdam"}
print(capital_country)

print(capital_country["Austria"])
for c in capital_country:
    print("-->", c)

for v in capital_country.values():
    print("==>", v)


# JSON
# ====
# Dict in dict
data = {
    "president": {
        "name": "Zaphod Beeblebrox",
        "species": "Betelgeusian"
    }
}

print(data["president"]["species"])

data1 = {
    "researcher": {
        "name": "Ford Prefect",
        "species": "Betelgeusian",
        "relatives": [
            {
                "name": "Zaphod Beeblebrox",
                "species": "Betelgeusian"
            },
            {
                "name": "Zaphod Beeblebrox",
                "species": "Wahl"
            }
        ]
    }
}

print(data1["researcher"]["relatives"][1]["species"])







