adresse_1 = {
    "Forscher": {
        "name": "Pütz",
        "vorname": "Jean",
        "land": "Schweiz",
        "verwandte": [
            {
                "name": "Pütz",
                "vorname": "Hans",
                "verwandtschaft": "Onkel"
            },
            {
                "name": "Pütz",
                "vorname": "Anna",
                "Verwandtschaft": "Tante"
            }
        ]
    }
}
print('Liebe Tante Anna,')

print('Liebe', adresse_1['Forscher']['verwandte'][1]['Verwandtschaft'], adresse_1['Forscher']['verwandte'][1]['vorname'] + ',')
print('Liebe ', adresse_1['Forscher']['verwandte'][1]['Verwandtschaft'], ' ', adresse_1['Forscher']['verwandte'][1]['vorname'], ',', sep='')

print()
print('Liebe ', adresse_1['Forscher']['verwandte'][1]['Verwandtschaft'], adresse_1['Forscher']['verwandte'][1]['vorname'] + ',')
print('Liebe', adresse_1['Forscher']['verwandte'][1]['Verwandtschaft'], ' ', adresse_1['Forscher']['verwandte'][1]['vorname'], ',', sep='')
print('Liebe' + adresse_1['Forscher']['verwandte'][0]['Verwandtschaft'], adresse_1['Forscher']['verwandte'][1]['vorname'], ',')
