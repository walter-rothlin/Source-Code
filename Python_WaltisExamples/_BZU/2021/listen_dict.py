print("Listen und Dict (JSON)")

# Listen in Python
nameListe = ['Walti',
             "Felix",
             "Hans",
             'Lukas']
print(nameListe)
print(nameListe[1], len(nameListe))
for aName in nameListe:
    print("aName:", aName[0:3], aName[-1], aName[-3:], len(aName))

nameListe.sort()
print(nameListe)

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


# Json
weatherResponse = {"coord": {"lon": 9.2579, "lat": 46.8045},
                   "weather": [{"id": 803, "main": "Clouds", "description": "broken clouds", "icon": "04d"}],
                   "base": "stations",
                   "main": {"temp": 270.49, "feels_like": 270.49, "temp_min": 269.14, "temp_max": 271.72,
                            "pressure": 1022, "humidity": 83, "sea_level": 1022, "grnd_level": 903},
                   "visibility": 10000, "wind": {"speed": 0.31, "deg": 92, "gust": 0.79}, "clouds": {"all": 55},
                   "dt": 1641462831,
                   "sys": {"type": 2, "id": 2019327, "country": "CH", "sunrise": 1641452847, "sunset": 1641484177},
                   "timezone": 3600, "id": 2660083, "name": "Laax", "cod": 200}
