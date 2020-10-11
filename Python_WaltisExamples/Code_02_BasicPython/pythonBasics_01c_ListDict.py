
# List [value,value,....]
# -----------------------
a = ['aa', 'ab', 'ac', 'ad', 'ae', 'af', 'ag']
b = ['bA', 'bB', 'bC', 'bD', 'bE']
n = [1, 2, 3, 4, 5, 6, 7, 8]


print(b[2])       # ? 3.Element von b  => 'bC'
print(a[-1])      # ? Letztes Element von a ==> 'ag'
print(n[-3])      # ? 3.letztes Element von n ==> 6
print(len(b))     # ? Wieviele Elemente enthält die Liste b ==> 5
print(":", b.index("bC"), ":")   # ? An welcher Stelle in der Liste b ist der Wert 'bC'   ==> 2

try:
    print(":", b.index("BC"), ":")        # ? An welcher Stelle in der Liste b ist der Wert 'BC'   ==> Raise Exception ValueError
except ValueError:
    print(": BC ist nicht in der Liste:")

n[-5] = 44        # ? Aendere den Wert des 5.letztes Elements der Liste n von 4 auf 44
print(n)

b.append('bFF')   # ? 'bFF' am Schluss der Liste b anhängen
print(b)

b.insert(3, 'bGG') # ? Füge 'bGG' an der 4.Stelle in der Liste b ein und verschiebe alle anderen Elemente nach rechts.
print(b)

b.sort()           # ? Sortieren Sie die Liste b alphabetisch aufsteigend
print(b)

b.pop(-1)          # ? Löschen Sie die beiden letzten Elemente in der Liste b
print(b)
b.pop(-1)
print(b)


# List of List
x = [a, b, n]
print(x)
print(len(x[1]))      # ? Wieviele Elemente enthält die Liste b ==> 5

x[-1][-5] = 4         # ? Aendere den Wert des 5.letztes Elements der letzten Liste x von 44 auf 4
print(x)


# Dictionary {key:value,key:value...}
# -----------------------------------

# Varianten zum Testen ob ein Key im Dict vorhanden ist: https://thispointer.com/python-how-to-check-if-a-key-exists-in-dictionary/
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
print(capital_country["US"])                # ? Was ist die Hauptstadt der US

try:
    print(capital_country["USA"])           # ? Was ist die Hauptstadt der USA
except KeyError:
    print("USA ist not an existing key")


if "Germany" in capital_country:            # ? Ist Germany ein gültiger Key?
    print("Germany ist ein gültiger Key")
else:
    print("Germany ist KEIN Key")

if "US" in capital_country.keys():           # ? Ist US ein gültiger Key?
    print("US ist ein gültiger Key")
else:
    print("US ist KEIN Key")

if "USA" in capital_country:                 # ? Ist USA ein gültiger Key?
    print("USA ist ein gültiger Key")
else:
    print("USA ist KEIN Key")

if "USA" in capital_country.keys():          # ? Ist USA ein gültiger Key?
    print("USA ist ein gültiger Key")
else:
    print("USA ist KEIN Key")

if capital_country.get("USA") is not None:
    print("Yes, key: 'USA' exists in dictionary")
else:
    print("No, key: 'USA' does not exists in dictionary")

if capital_country.get("USA",-1) != -1:
    print("Yes, key: 'USA' exists in dictionary")
else:
    print("No, key: 'USA' does not exists in dictionary")

print(capital_country.keys())        # ? Alle Keys auflisten
for k in capital_country:
    print(k, "-->", capital_country[k])


# Dict values
if "Ottawa" in capital_country.values():   # ? Ist Ottawa ein gültiger Value?
    print("Ottawa ist ein gültiger Value")
else:
    print("Ottawa ist KEIN Value")

if "Ottowa" in capital_country.values():   # ? Ist Ottowa ein gültiger Value?
    print("Ottowa ist ein gültiger Value")
else:
    print("Ottowa ist KEIN Value")


print(capital_country.values())      # ? Alle Keys auflisten

# ? Aendern Sie die Hauptstadt von Deutschland von Bonn zu Berlin
capital_country["Germany"] = "Berlin"
print(capital_country)

# ? Fügen Sie die Hauptstadt von Italy dazu (Roma)
capital_country.update({"Italy":"Roma","Lichtenstein":"Vaduz"})
print(capital_country)

# Dict of Dict
# ------------
capital_country = {"United States":
                       {"Capitol":"Washington",
                        "Präsident":"Donald Trup",
                        "Population":328000000,},
                   "Switzerland":
                       {"Capitol":"Bern",
                        "Präsident":"Simoneta Samaruga",
                        "Population":8000000,},
                   }

print(capital_country)
print(capital_country["Switzerland"])
print(capital_country["Switzerland"]["Population"])      # ? Wieviele Einwohner hat die Schweiz
print(capital_country["United States"]["Präsident"])     # ? Wie heisst der Präsident von Amerika


# Dict of List
# ------------
capital_country = {"United States":
                       ["New york", "Washingthon", "Texas", "New Jersey", "Penselvenia"],
                   "Switzerland":
                       ["Schwyz", "Bern", "Aargau", "St.Gallen", "Basel", "Genf"]
                   }

print(capital_country)
print(capital_country["Switzerland"])
print(capital_country["Switzerland"][1])     # ? Wie heisst der 2.Kanton in der Schweiz        --> Bern
print(capital_country["Switzerland"][-1])    # ? Wie heisst der letzte Kanton in der Schweiz   --> Genf

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

print("Temp in", meteoDaten[0]["Standort"], ":", meteoDaten[0]["Temp"], meteoDaten[0]["Einheit"])

