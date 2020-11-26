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

def addPositionsPreis(liste, anzahlFN="", preisFN="", positionsPreisFN=""):
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
    {"Anzahl": 100,
     "Einzelpreis": 22.50,
     "Bezeichnung": "Mineralwasser",
     "ArtNo": "(00-007-007)"
     },
]

lbl_Anzahl = "Anzahl"
lbl_Einzelpreis = "Einzelpreis"
lbl_Preis = "Preis"

shoppingList = addPositionsPreis(shoppingList, anzahlFN=lbl_Anzahl, preisFN=lbl_Einzelpreis, positionsPreisFN=lbl_Preis)

# for einkaufsPos in shoppingList:
#     print(einkaufsPos)
#     print(einkaufsPos['Bezeichnung'])
#     for k in einkaufsPos:
#         print(k, ":", einkaufsPos[k])


# ---------------
# Config Elemente
# ---------------
title = "Quittung"
lbl_Total = "Rechnungsbetrag"

nachkommastellen = 2

columnWithList = {
    "Anzahl": 8,
    "Bezeichnung": 25,
    "ArtNo": 20,
    "Einzelpreis": 11,
    "Preis": 10
}

# -------------------
# Code ohne hardcodes
# -------------------
gPreis = 0
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
    gPreis += einkaufsPos[lbl_Preis]
    rowStr = "| "
    for cellWithKey in columnWithList:
        placeHolderType = "s"
        if (type(einkaufsPos[cellWithKey]) is int):
            placeHolderType = "d"
        elif (type(einkaufsPos[cellWithKey]) is float):
            placeHolderType = "f"

        if (placeHolderType == "f"):
            posStrFm = "{0:" + str(columnWithList[cellWithKey]) + "." + str(nachkommastellen) + placeHolderType + "} | "
        else:
            posStrFm = "{0:" + str(columnWithList[cellWithKey]) + placeHolderType + "} | "
        posStr = posStrFm.format(einkaufsPos[cellWithKey])
        rowStr += posStr
    print(rowStr)


print(" " * (tableWith + 4) + "-" * columnWithList[lbl_Preis])
fmStrRechnungsbetrag = "{gPreis:" + str(columnWithList[lbl_Preis]) + "." + str(nachkommastellen) + "f}"
print(" " * (tableWith - len(lbl_Total)) + lbl_Total + ":   " + fmStrRechnungsbetrag.format(gPreis=gPreis))
print(" " * (tableWith + 4) + "=" * columnWithList[lbl_Preis])
print("\n\n")


