
# =======================
# Uebung zu List und Dict
# =======================



" List [value,value,....] "    # doc-string
" ======================= "    
a = ['aa', 'ab', 'ac', 'ad', 'ae', 'af', 'ag']
b = ['bA', 'bB', 'bC', 'bD', 'bE']
n = [1, 2, 3, 4, 5, 6, 7, 8]

# ? Schreiben Sie den Inhalt von b auf den Bildschirm
# ? 3.Element von b  => 'bC'
# ? Letztes Element von a ==> 'ag'
# ? 3.letztes Element von n ==> 6
# ? Wieviele Elemente enthält die Liste b ==> 5
# ? An welcher Stelle in der Liste b ist der Wert 'bC'   ==> 2
# ? An welcher Stelle in der Liste b ist der Wert 'BC'   ==> Raise Exception ValueError
# ? Aendere den Wert des 5.letztes Elements der Liste n von 4 auf 44
# ? 'bFF' am Schluss der Liste b anhängen
# ? Füge 'bGG' an der 4.Stelle in der Liste b ein und verschiebe alle anderen Elemente nach rechts.
# ? Sortieren Sie die Liste b alphabetisch aufsteigend
# ? Löschen Sie die beiden letzten Elemente in der Liste b


# List of List
# ============
x = [a, b, n]

# ? Schreiben Sie den Inhalt von x auf den Bildschirm
# ? Wieviele Elemente enthält die Liste b ==> 5
# ? Aendere den Wert des 5.letztes Elements der letzten Liste x von 44 auf 4


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
# ? Was ist die Hauptstadt der USA   --> Exception KeyError
# ? Ist Germany ein gültiger Key?
# ? Ist US ein gültiger Key?
# ? Ist USA ein gültiger Key?
# ? Ist USA ein gültiger Key?
# ? Listen sie alle Keys auf
# ? Loopen sie durch alle Keys und zeigen Sie auf dem Bildschirm ein Key --> Value pair pro Zeile


# Dict values
# -----------

# ? Ist Ottawa ein gültiger Value?
# ? Ist Ottowa ein gültiger Value?
# ? Listen sie alle Values auf
# ? Aendern Sie die Hauptstadt von Deutschland von Bonn zu Berlin
# ? Fügen Sie die Hauptstadt von Italy dazu (Roma)

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

# ? Zeigen Sie auf dem Bildschirm die Struktur
# ? Zeigen Sie auf dem Bildschirm die Struktur von Switzerland
# ? Wieviele Einwohner hat die Schweiz
# ? Wie heisst der Präsident von Amerika


# Dict of List
# ------------
capital_country = {"United States":
                       ["New york", "Washingthon", "Texas", "New Jersey", "Penselvenia"],
                   "Switzerland":
                       ["Schwyz", "Bern", "Aargau", "St.Gallen", "Basel", "Genf"]
                   }

# ? Zeigen Sie auf dem Bildschirm die Struktur
# ? Zeigen Sie auf dem Bildschirm die Struktur von Switzerland
# ? Wie heisst der 2.Kanton in der Schweiz        --> Bern
# ? Wie heisst der letzte Kanton in der Schweiz   --> Genf

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