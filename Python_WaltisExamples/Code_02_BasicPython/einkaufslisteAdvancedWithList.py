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

shoppingList = [
    {"Anzahl": 500,
     "Preis": 4.20,
     "Bezeichnung": "Banane",
     "ArtNo": "(01-234-123)"
     },
]

anz_Bananen = 500
preis_Bananen = 4.2
bez_Bananen = "Bananen"
artNr_Bananen = "(01-234-123)"

anz_Nektarinen = 18
preis_Nektarinen = 0.2
bez_Nektarinen = "Nektarinen"
artNr_Nektarinen = "(11-445-123)"

anz_Weine = 46
preis_Weine = 32.50
bez_Weine = "Weine"
artNr_Weine = "(44-444-231)"

gPreis = 0
pPreis = 0

# ---------------
# Config Elemente
# ---------------
title = "Quittung"
lbl_Total = "Rechnungsbetrag"

nachkommastellen = 2

lbl_Anzahl = "Anzahl"
sb_Anzahl = 12          # Spaltenbreite für Anzahl

lbl_Artikel = "Artikel"
sb_Artikel = 20

lbl_ArtNo = "Art.Nr"
sb_ArtNr = 20

lbl_Stueckpreis = "Stueckpreis"
sb_StueckPreis = 11

lbl_Preis = "Preis"
sb_Preis = 10



# -------------------
# Code ohne hardcodes
# -------------------
tabellenBreite = sb_Anzahl + sb_Artikel + sb_ArtNr + sb_StueckPreis + sb_Preis
print(title + "     ", DateTime.now().strftime('%d.%m.%Y %H:%M:%S'))
print("=" * len(title) + "\n")
titleStr = "| "
titleStr += ("{a:" + str(sb_Anzahl) + "s} ").format(a=lbl_Anzahl)
titleStr += "| "
titleStr += ("{a:" + str(sb_Artikel) + "s} ").format(a=lbl_Artikel)
titleStr += "| "
titleStr += ("{a:" + str(sb_ArtNr) + "s} ").format(a=lbl_ArtNo)
titleStr += "| "
titleStr += ("{a:" + str(sb_StueckPreis) + "s} ").format(a=lbl_Stueckpreis)
titleStr += "| "
titleStr += ("{a:" + str(sb_Preis) + "s} ").format(a=lbl_Preis)
titleStr += "|"
print(titleStr)

print("+" + "-" * (sb_Anzahl+2) + "+" + "-" * (sb_Artikel+2) + "+" + "-" * (sb_ArtNr+2) + "+" + "-" * (sb_StueckPreis+2) + "+" + "-" * (sb_Preis+2) + "+")

formatStr = "| {anz:" + str(sb_Anzahl) + "d} | {art:" + str(sb_Artikel) + "s} | {an:" + str(sb_ArtNr) + "s} | {sPreis:" + str(sb_StueckPreis) + "." + str(nachkommastellen) + "f} | {totP:" + str(sb_Preis) + "." + str(nachkommastellen) + "f} |"

pPreis = anz_Bananen * preis_Bananen
gPreis = gPreis + pPreis
print(formatStr.format(anz=anz_Bananen, art=bez_Bananen, an=artNr_Bananen, sPreis=preis_Bananen, totP=pPreis))

pPreis = anz_Nektarinen * preis_Nektarinen
gPreis = gPreis + pPreis
print(formatStr.format(anz=anz_Nektarinen, art=bez_Nektarinen, an=artNr_Nektarinen, sPreis=preis_Nektarinen, totP=pPreis))


pPreis = anz_Weine * preis_Weine
gPreis = gPreis + pPreis
print(formatStr.format(anz=anz_Weine, art=bez_Weine, an=artNr_Weine, sPreis=preis_Weine, totP=pPreis))
print(" " * (tabellenBreite + 4) + "-" * sb_Preis)
fmStrRechnungsbetrag = "{gPreis:" + str(sb_Preis) + "." + str(nachkommastellen) + "f}"
print(" " * (tabellenBreite - len(lbl_Total)) + lbl_Total + ":  " + fmStrRechnungsbetrag.format(gPreis=gPreis))
print(" " * (tabellenBreite + 4) + "=" * sb_Preis)
print("\n\n")


