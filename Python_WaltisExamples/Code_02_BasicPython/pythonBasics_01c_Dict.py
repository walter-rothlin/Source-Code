#!/usr/bin/python3

# formate using dictionary
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

print("capital_country: Alle Keys auflisten")
for c in capital_country:
    print("    {country:20s}".format(country=c))
print("\n")

print("capital_country: Alle Values auflisten")
for v in capital_country.values():
    print("    {country:20s}".format(country=v))
print("\n")

print("capital_country: Alle Key/Values auflisten")
for c in capital_country:
    print("    {country:20s}: {capital}".format(country=c, capital=capital_country[c]))
print("\n")



print("Einzelner Value ueber Key zugreifen:      ", end="")
varName1 = "Austria"
print("capital_country[\"", varName1, "\"]                 --> ", capital_country[varName1], sep="")

print("Einzelner Value ueber Key updaten  :      ", end="")
varName1 = "Austria"
capital_country[varName1] = "Wien"
print("capital_country[\"", varName1, "\"] = \"Wien\"        --> ", capital_country[varName1], sep="")

print("New Key/Value insert               :      ", end="")
varName1 = "Lichtenstein"
capital_country[varName1] = "Vaduze"
print("capital_country[\"", varName1, "\"] = \"Vaduze\" --> ",  capital_country[varName1], sep="")
print("New Key/Value (which is existing)  :      ", end="")
capital_country[varName1] = "Vaduz"
print("capital_country[\"", varName1, "\"] = \"Vaduz\"  --> ",  capital_country[varName1], sep="")
print("\n")

varName1 = "Austria"
print("Einzelner Key/Value delete   (capital_country.pop(\"", varName1, "\"))", sep="")
print("dict capital_country:", capital_country)
capital_country.pop(varName1)       # del capital_country(varName1)
print("dict capital_country:", capital_country)
print("\n")



print("Letzter Eintrag wieder entfernen   (capital_country.popitem())", sep="")
print("dict capital_country (", len(capital_country), "):", capital_country)
capital_country.popitem()
print("dict capital_country ( ", len(capital_country), "):", capital_country)
capital_country.popitem()
print("dict capital_country ( ", len(capital_country), "):", capital_country)
print("\n")
if "Canada" in capital_country:
    print("Canada is a existing Key in capital_country!")
print("\n")

print("After copy")
cc = capital_country.copy()
print("dict capital_country ( ", len(capital_country), "):", capital_country)
print("dict cc              ( ", len(cc),              "):", cc)
print("\n")

print("After del")
cc.clear()
print("dict cc              ( ", len(cc),              "):", cc)
print("\n\n")

print("Nested dict")
child1 = {
  "name" : "Emil",
  "year" : 2004
}
child2 = {
  "name" : "Tobias",
  "year" : 1996
}
child3 = {
  "name" : "Linus",
  "year" : 1999
}

myfamily = {
  "child1" : child1,
  "child2" : child2,
  "child3" : child3
}

print("myfamily                  :", myfamily)
print("myfamily[\"child2\"]        : ", myfamily["child2"])
print("myfamily[\"child2\"][\"year\"]: ", myfamily["child2"]["year"])
myfamily["child3"]["name"] = "Lukas"
print("myfamily                  :", myfamily)