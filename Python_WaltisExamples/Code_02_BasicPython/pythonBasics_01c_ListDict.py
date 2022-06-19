#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_01c_ListDict.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01c_ListDict.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2021   Walter Rothlin      Initial Version
# 16-Jun_2022   Walter Rothlin      Added split() and join()
# ------------------------------------------------------------------

# =======================
# Uebung zu List und Dict
# =======================



" List [value,value,....] "    # doc-string
" ======================= "
a = ['aa', 'ab', 'ac', 'ad', 'ae', 'af', 'ag']
b = ['bA', 'bB', 'bC', 'bD', 'bE']
n = [1, 2, 3, 4, 5, 6, 7, 8]

# ? Schreiben Sie den Inhalt von b auf den Bildschirm
print(b)

# ? 3.Element von b  => 'bC'
print(b[2])

# ? Letztes Element von a ==> 'ag'
print(a[-1])

# ? 3.letztes Element von n ==> 6
print(n[-3])

# ? Wieviele Elemente enthält die Liste b ==> 5
print(len(b))

# ? An welcher Stelle in der Liste b ist der Wert 'bC'   ==> 2
print(":", b.index("bC"), ":")

# ? An welcher Stelle in der Liste b ist der Wert 'BC'   ==> Raise Exception ValueError
try:
    print(":", b.index("BC"), ":")
except ValueError:
    print(": BC ist nicht in der Liste:")

# ? Aendere den Wert des 5.letztes Elements der Liste n von 4 auf 44
n[-5] = 44
print(n)

# ? 'bFF' am Schluss der Liste b anhängen
b.append('bFF')
print(b)

# ? Füge 'bGG' an der 4.Stelle in der Liste b ein und verschiebe alle anderen Elemente nach rechts.
b.insert(3, 'bGG')
print(b)

# ? Sortieren Sie die Liste b alphabetisch aufsteigend
b.sort()
print(b)

# ? Löschen Sie die beiden letzten Elemente in der Liste b
b.pop(-1)
print(b)
b.pop(-1)
print(b)


# Split / Join
# ============
print("Test split!!")
testCases = """
Nr    |Fct                   |Param1       |Param2       |Param3       |Expected
     1|celsius2Fahrenheit    |37.8         |0            |0            |100.04
     2|celsius2Fahrenheit    |0            |0            |0            |32.0
     3|fahrenheit2Celsius    |100          |0            |0            |37.78
     4|rad2Grad              |0            |0            |0            |0
"""
# ? splitten sie testCases in eine Liste (listOfLines) von Zeilen
listOfLines = testCases.split('\n')

# ? splitten sie nun die Liste (listOfLines) von Zeilen weiter in Spalten
#   result[] enthält eine liste von listen mit den Elementen der Zeilen
result = []
lineNr = 0
for aLine in listOfLines:
    print(lineNr, ") Line:", aLine)
    lineNr += 1
    result.append(aLine.split('|'))
print(result)
print("Element 1.Zeile 3.Element:", result[1][3], "\n\n")

listOfNames = ['Name', 'Vorname', 'Strasse']
print("Test join!!")
# ? erstellen Sie aus der Liste ein csv-String
print(";".join(listOfNames))


# List of List
# ============
x = [a, b, n]

# ? Schreiben Sie den Inhalt von x auf den Bildschirm
print(x)

# ? Wieviele Elemente enthält die Liste b ==> 5
print(len(x[1]))

# ? Aendere den Wert des 5.letztes Elements der letzten Liste x von 44 auf 4
x[-1][-5] = 4
print(x)


# Dictionary {key:value,key:value...}
# ===================================

# Varianten zum Testen ob ein Key im Dict vorhanden ist: https://thispointer.com/python-how-to-check-if-a-key-exists-in-dictionary/
# -----------------------------------------------------
capital_country = {"United States": "Washington",
                   "US": "Washington",
                   "Canada": "Ottawa",
                   "Germany": "Bonn",
                   "France": "Paris",
                   "England": "London",
                   "UK": "London",
                   "Switzerland": "Bern",
                   "Austria": "Vienna",
                   "Netherlands": "Amsterdam"}

# Dict keys
# ---------

# ? Was ist die Hauptstadt der US
print(capital_country["US"])

# ? Was ist die Hauptstadt der USA   --> Exception KeyError
try:
    print(capital_country["USA"])
except KeyError:
    print("USA ist not an existing key")

# ? Ist Germany ein gültiger Key?
if "Germany" in capital_country:
    print("Germany ist ein gültiger Key")
else:
    print("Germany ist KEIN Key")

# ? Ist US ein gültiger Key?
if "US" in capital_country.keys():
    print("US ist ein gültiger Key")
else:
    print("US ist KEIN Key")

# ? Ist USA ein gültiger Key?
if "USA" in capital_country:
    print("USA ist ein gültiger Key")
else:
    print("USA ist KEIN Key")

# ? Ist USA ein gültiger Key?
if "USA" in capital_country.keys():
    print("USA ist ein gültiger Key")
else:
    print("USA ist KEIN Key")

# variante mit get
if capital_country.get("USA") is not None:
    print("Yes, key: 'USA' exists in dictionary")
else:
    print("No, key: 'USA' does not exists in dictionary")

if capital_country.get("USA", -1) != -1:
    print("Yes, key: 'USA' exists in dictionary")
else:
    print("No, key: 'USA' does not exists in dictionary")

# ? Listen sie alle Keys auf
print(capital_country.keys())

# ? Loopen sie durch alle Keys und zeigen Sie auf dem Bildschirm ein Key --> Value pair pro Zeile
for k in capital_country:
    print(k, "-->", capital_country[k])


# Dict values
# -----------

# ? Ist Ottawa ein gültiger Value?
if "Ottawa" in capital_country.values():
    print("Ottawa ist ein gültiger Value")
else:
    print("Ottawa ist KEIN Value")

# ? Ist Ottowa ein gültiger Value?
if "Ottowa" in capital_country.values():
    print("Ottowa ist ein gültiger Value")
else:
    print("Ottowa ist KEIN Value")

# ? Listen sie alle Values auf
print(capital_country.values())

# ? Aendern Sie die Hauptstadt von Deutschland von Bonn zu Berlin
capital_country["Germany"] = "Berlin"
print(capital_country)

# ? Fügen Sie die Hauptstadt von Italy dazu (Roma)
capital_country.update({"Italy": "Roma", "Lichtenstein": "Vaduz"})
print(capital_country)

# Dict of Dict
# ------------
capital_country = {"United States":
                       {"Capitol": "Washington",
                        "Präsident": "Donald Trump",
                        "Population": 328000000, },
                   "Switzerland":
                       {"Capitol": "Bern",
                        "Präsident": "Simoneta Samaruga",
                        "Population": 8000000, },
                   }

# ? Zeigen Sie auf dem Bildschirm die Struktur
print(capital_country)

# ? Zeigen Sie auf dem Bildschirm die Struktur von Switzerland
print(capital_country["Switzerland"])

# ? Wieviele Einwohner hat die Schweiz
print(capital_country["Switzerland"]["Population"])

# ? Wie heisst der Präsident von Amerika
print(capital_country["United States"]["Präsident"])


# Dict of List
# ------------
capital_country = {"United States":
                       ["New york", "Washingthon", "Texas", "New Jersey", "Penselvenia"],
                   "Switzerland":
                       ["Schwyz", "Bern", "Aargau", "St.Gallen", "Basel", "Genf"]
                   }

# ? Zeigen Sie auf dem Bildschirm die Struktur
print(capital_country)

# ? Zeigen Sie auf dem Bildschirm die Struktur von Switzerland
print(capital_country["Switzerland"])

# ? Wie heisst der 2.Kanton in der Schweiz        --> Bern
print(capital_country["Switzerland"][1])

# ? Wie heisst der letzte Kanton in der Schweiz   --> Genf
print(capital_country["Switzerland"][-1])

# List of Dict
# ------------
meteoDaten = [
    {"Standort": "Wangen",
     "Feuchtigkeit": 62,
     "Temp": 32,
     "Einheit": "Celsius",
    },
    {"Standort": "Nuolen",
     "Feuchtigkeit": 69,
     "Temp": 25,
     "Einheit": "Celsius",
     },
    {"Standort": "New York",
     "Feuchtigkeit": 85,
     "Temp": 100,
     "Einheit": "Fahrenheit",
     },
]

# ? Zeigen Sie die Temp mit Einheit auf dem Bildschirm in der Form --> Temp in Wangen : 32 Celsius
print("Temp in", meteoDaten[0]["Standort"], ":", meteoDaten[0]["Temp"], meteoDaten[0]["Einheit"])

# ? Berechnen Sie die Durchschnittstemperatur aller in Celsius gemessenen
average = 0
anzahl = 0
for messOrt in meteoDaten:
    if messOrt["Einheit"] == "Celsius":
        average += messOrt["Temp"]
        anzahl += 1
average = average/anzahl
print(average)



print(__doc__)