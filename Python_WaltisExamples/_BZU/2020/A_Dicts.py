# ------------------------------------------------------------------
# Name: A_Dicts
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
                   "Germany": "Berlin",
                   "France": "Paris",
                   "England": "London",
                   "UK": "London",
                   "Switzerland": "Bern",
                   "Austria": "Vienna",
                   "Netherlands": "Amsterdam"}

print("dict capital_country:", capital_country)
print("\n")
print("Hauptstadt der Schweiz:", capital_country["Switzerland"])

print("-->  capital_country: Alle Keys auflisten")
for country in capital_country.keys():
    print(country, "-->", capital_country[country])

print("Anzahl Elemente im Dict:", len(capital_country))

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

gchild1= {
  "name": "Felix",
  "year": 2021
}
print(child1["name"], "hat Jahrgang", child1["year"])
print(child2["name"], "hat Jahrgang", child2["year"])
print(child3["name"], "hat Jahrgang", child3["year"])

myfamily = {
  "child1": child1,
  "child2": child2,
  "child3": child3,
  "grandChild1": gchild1,
  "grandChild2": {"name": "Claudia", "year": 2021, "Sex": "F"}
}

print("\n")
print(myfamily["child1"]["name"], "hat Jahrgang", myfamily["child1"]["year"])
print("\n")
for aChildKey in myfamily.keys():
    print(myfamily[aChildKey]["name"], "hat Jahrgang", myfamily[aChildKey]["year"])

print("\n")
print(myfamily["grandChild2"]["Sex"])

print("\n")
kinderListe = [
    child1,
    child2,
    child3,
    {"name": "Claudia",
     "year": 2021,
     "Sex": "F"},
    {"name": "Petra",
     "year": 2020,
     "Sex": "F",
     "Freunde": ["Paul", "Fritz"]}
]

for aChild in kinderListe:
    print(aChild["name"])

print("\n")
for aFreund in kinderListe[4]["Freunde"]:
    print("-->", aFreund)




