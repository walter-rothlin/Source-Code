# ------------------------------------------------------------------
# Name: B_Dictsn
#
# Description: dicts methoden
#
# Autor: Walter Rothlin
#
# History:
# 07-Jan-2021   Walter Rothlin      Initial Version
# -----------------------------------------------------------------
capital_country = {"United States": "Washington",
                   "US": "Washington",
                   "Canada": "Ottawa",
                   "Italy": "Roma",
                   "Germany": "Berlin",
                   "France": "Paris",
                   "England": "London",
                   "UK": "London",
                   "Switzerland": "Bern",
                   "Austria": "Vienna",
                   "Netherlands": "Amsterdam"}

land = input("Land:")
print(land, " --> ", capital_country[land])
print("\n")

for country in capital_country:
    print(country, " --> ", capital_country[country])
print("\n")

child1 = {
  "name": "Emil",
  "year": 2004
}

child2 = {
  "name": "Tobias",
  "year": 1996
}

child3 = {
  "name": "Linus",
  "year": 1999
}

print(child3["name"], " -->", child3["year"])
print("\n")

myfamily = {
    "kind1": child1,
    "kind2": child2,
    "kind3": child3,
    "gChild1": {
        "name": "Felix",
        "year": 2021,
        "freunde": ["Paul", "Max", "Eva"]
    }
}
print(myfamily["kind2"]["year"])
print("\n")

for aKind in myfamily:
    print(myfamily[aKind]["name"], "hat Jahrgang", myfamily[aKind]["year"])
print("\n")

print(myfamily["gChild1"]["freunde"][2])
print("\n")


myfamilyListe = [
    child1,
    child2,
    child3,
    {
        "name": "Felix",
        "year": 2021,
        "freunde": ["Paul", "Max", "Eva"]
    }
]

for aChild in myfamilyListe:
    print(aChild)