#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: einkaufslisteAdvancedWithList.py
#
# Description: Formatiert eine Shoppingliste
#
# Autor: Walter Rothlin
#
# History:
# 12-Dec-2019   Walter Rothlin      Initial Version
# 26-Nov_2020   Walter Rothlin      Advanced Version
# 26-Nov_2020   Walter Rothlin      Added List
# ------------------------------------------------------------------
from datetime import datetime as DateTime

def addPositionsPreis(liste, anzahlFN="Anzahl", preisFN="Einzelpreis", positionsPreisFN = "Preis"):
    for listItem in liste:
        listItem.update({positionsPreisFN: listItem[anzahlFN] * listItem[preisFN]})
    return liste

shoppingList = [
    {"Anzahl": 500,
     "Einzelpreis": 4.20,
     "Bezeichnung": "Banane",
     "ArtNo": "(01-234-123)"
     },
    {"Anzahl": 18,
     "Einzelpreis": 0.20,
     "Bezeichnung": "Nektarine",
     "ArtNo": "(11-445-123)"
     },
    {"Anzahl": 46,
     "Einzelpreis": 32.50,
     "Bezeichnung": "Wein",
     "ArtNo": "(44-444-231)"
     },
]

shoppingList = addPositionsPreis(shoppingList)

# for einkaufsPos in shoppingList:
#     print(einkaufsPos)
#     print(einkaufsPos['Bezeichnung'])
#     for k in einkaufsPos:
#         print(k, ":", einkaufsPos[k])


gPreis = 0


# ---------------
# Config Elemente
# ---------------
title = "Quittung"
lbl_Total = "Rechnungsbetrag"

nachkommastellen = 2

columnWithList = {
    "Anzahl": 12,
    "Artikel": 20,
    "Art.Nr": 20,
    "Stueckpreis": 11,
    "Preis": 10
}

lbl_Anzahl = "Anzahl"
lbl_Artikel = "Artikel"
lbl_ArtNo = "Art.Nr"
lbl_Stueckpreis = "Stueckpreis"
lbl_Preis = "Preis"



# -------------------
# Code ohne hardcodes
# -------------------

tableWith = 0
for cellWithKey in columnWithList:
    tableWith += columnWithList[cellWithKey]

print(title + "     ", DateTime.now().strftime('%d.%m.%Y %H:%M:%S'))
print("=" * len(title) + "\n")
titleStr = "| "
for cellWithKey in columnWithList:
    titleStr += ("{a:" + str(columnWithList[cellWithKey]) + "s} ").format(a=cellWithKey)
    titleStr += "| "
print(titleStr)

titleUnderline = "+"
for cellWithKey in columnWithList:
    titleUnderline += "-" * (columnWithList[cellWithKey]+2) + "+"
print(titleUnderline)

for einkaufsPos in shoppingList:
    gPreis += einkaufsPos['Preis']
    rowStr = "|"
    for cellWithKey in columnWithList:
        posStrFm = "{0:" + str(columnWithList[cellWithKey]) + "d} |"
        print(einkaufsPos, cellWithKey, einkaufsPos[cellWithKey], posStrFm)
        posStr = posStrFm.format(einkaufsPos[cellWithKey])
        rowStr += posStr
    print(rowStr)


print(" " * (tableWith + 4) + "-" * columnWithList['Preis'])
fmStrRechnungsbetrag = "{gPreis:" + str(columnWithList['Preis']) + "." + str(nachkommastellen) + "f}"
print(" " * (tableWith - len(lbl_Total)) + lbl_Total + ":   " + fmStrRechnungsbetrag.format(gPreis=gPreis))
print(" " * (tableWith + 4) + "=" * columnWithList['Preis'])
print("\n\n")


