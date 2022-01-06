#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_01c_Dict.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01c_Dict.py

#
# Description: Examples for Dictonaries
#
# Autor: Walter Rothlin
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version ()
# 28-Nov-2021   Walter Rothlin      Added some more specifics
# ------------------------------------------------------------------
import json
# Dictonaries in Python
capitols = {
    "Schweiz" : "Bern",
    "Deutschland" : "Berlin",
    "Oestreich" : "Wien",
    "Italien" : "Rom",
    "Frankreich" : "Paris",
    "Lichtenstein" : "Vaduz"
}

print(capitols)
print(capitols["Schweiz"])
for aKey in capitols:
    print(aKey, " --> ", capitols[aKey])

# combinations of dicts and dicts
countries = {
    "Schweiz": {"capitol": "Bern", "Population" : "8 Mio", "currencies" : ["franken", "rappen"]},
    "Deutschland": {"capitol": "Berlin", "Population" : "83 Mio", "currencies" : ["euro", "pence"]}
}

print(countries["Schweiz"]["capitol"], countries["Deutschland"]["Population"])
print(countries["Schweiz"]["currencies"][0])

# 2.Beispiel
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

print("dict capital_country:\n", capital_country)
print("Add new key/value")
capital_country.update({"Deutschland" : "Berlin"})
print("dict capital_country:\n", json.dumps(capital_country, indent=4))
print("1 --------------------------------------------------- 1\n")

print("-->  capital_country: Alle Keys auflisten")
for c in capital_country:
    print("-->    {country:20s}".format(country=c))
print("2a ------------------------------------------------- 2a\n")

print("-->  capital_country: Alle Keys auflisten")
for c in capital_country.keys():
    print("-->    {country:20s}".format(country=c))
print("2b ------------------------------------------------- 2b\n")

print("capital_country: Alle Values auflisten")
for v in capital_country.values():
    print("    {country:20s}".format(country=v))
print("3 --------------------------------------------------- 3\n")

print("capital_country: Alle Values auflisten, welche mit B beginnen (using comprehensions)")
resultListe = [aValue for aValue in capital_country.values() if aValue[0] == 'B']
print(resultListe)
print("3b --------------------------------------------------- 3b\n")

print("capital_country: Alle Key/Values auflisten")
for c in capital_country:
    print("    {country:20s}: {capital}".format(country=c, capital=capital_country[c]))
print("4 --------------------------------------------------- 4\n")

print("10 --------------------------------------------------- 10\n")
print("\n\n----> json string --> json --> json string --> formated json str")
# string must be in ' NOT in "
ampelColors_jsonStr = '''{
       "stop": "red", 
       "go": "green", 
       "maybe": "orange"
       }'''

print("ampelColors_jsonStr        :", ampelColors_jsonStr)

ampelColors_json = json.loads(ampelColors_jsonStr)
ampelColors_json['stop'] = 'ROT'
print("ampelColors_json           :", ampelColors_json)

ampelColors_jsonStr1 = str(ampelColors_json)
print("ampelColors_jsonStr1       :", ampelColors_jsonStr1)

ampelColors_jsonStrFormated = json.dumps(ampelColors_json, indent=4)
print("ampelColors_jsonStrFormated:\n", ampelColors_jsonStrFormated)


print("\n\n----> json string list --> json --> json string --> formated json str")
ampelColorsListStr = '''[
       "red","green","orange"
       ]'''
print("ampelColorsListStr             :", ampelColorsListStr)

ampelColorsList = json.loads(ampelColorsListStr)
ampelColorsList[0] = "RED"
print("ampelColorsList                :", ampelColorsList)

ampelColors_jsonStr1 = str(ampelColorsList)
print("ampelColors_jsonStr1           :", ampelColors_jsonStr1)

ampelColorsList_jsonStrFormated = json.dumps(ampelColorsList, indent=4)
print("ampelColorsList_jsonStrFormated:\n", ampelColorsList_jsonStrFormated)
print("10 --------------------------------------------------- 10\n")


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