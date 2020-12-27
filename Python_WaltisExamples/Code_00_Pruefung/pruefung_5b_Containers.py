#!/usr/bin/python3

'''pruefung_5b_Containers.py'''



# Listen
# ------
squares = [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196]

print("squares[1]      -->", squares[1])      # indexing returns the item:       1
print("squares[-1]     -->", squares[-1])     # indexing returns the last item: 25
print("squares[2:4]    -->", squares[2:4])    # slicing returns a new list [9, 16]
print("squares[7:]     -->", squares[2:])     # slicing returns a new list [9, 16, 25]
print("squares[:4]     -->", squares[:4])     # slicing returns a new list [1, 4, 9, 16]
print("squares[-3:]    -->", squares[-3:])    # slicing returns a new list [9, 16, 25]
print("squares[:-3]    -->", squares[:-3])    # slicing returns a new list [1, 4]



xxxx = {
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
    },
    "Wissenschaftler": {
        "name": "Einstein",
        "vorname": "Fritz",
        "Land": "USA",
        "relatives": [
            {
                "name": "Einstein",
                "vorname": "Hans",
                "verwandtschaft": "Sohn"
            },
            {
                "name": "Einstein",
                "vorname": "Anna",
                "Verwandtschaft": "Tochter"
            },           {
                "name": "Einstein",
                "vorname": "Hans",
                "verwandtschaft": "Vater"
            },
            {
                "name": "Feuerstein",
                "vorname": "Angelika",
                "Verwandtschaft": "Mutter"
            }
        ]
    }
}

print(xxxx["Wissenschaftler"]["relatives"][3]["vorname"])
print(xxxx["Wissenschaftler"]["relatives"][-1]["vorname"])
print(xxxx["Wissenschaftler"]["relatives"][round(27/9)]["vorname"])
print(xxxx["Wissenschaftler"]["relatives"][-1]['vorname'])

print(xxxx["Wissenschaftler"]["relatives"][1])
print(xxxx["Wissenschaftler"]["relatives"][-3])
print(xxxx["Wissenschaftler"]["relatives"][-1*3])

preisListe = ["12.45", "3.41", "4", "6"]
print(preisListe[2]+preisListe[3])

cubes = []
n = int(input("n="))
for basis in range(1, n+1):
    cubes.append(3**basis)
print(cubes)

adresse = {
        "name": "Pütz",
        "vorname": "Jean",
        "land": "Schweiz",
        "strasse": "Hauptstrasse",
        "Plz": 8655,
        "Ort": "Elm"
}

print(adresse['Plz'], '<U>' + adresse['Ort'] + '</U>')
print(str(adresse['Plz']) + "<U>" + adresse['Ort'] + "</U>")

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

print(adresse_1['Forscher']['verwandte'][1]['Verwandtschaft'], adresse_1['Forscher']['verwandte'][1]['vorname'])

