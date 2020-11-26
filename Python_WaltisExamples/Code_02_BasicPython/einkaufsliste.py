#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: einkaufsliste.py
#
# Description: Formatiert eine Shoppingliste
#
# Autor: Walter Rothlin
#
# History:
# 12-Dec-2019   Walter Rothlin      Initial Version

# ------------------------------------------------------------------
from datetime import datetime as DateTime

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

print("Quittung     ", DateTime.now().strftime('%d.%m.%Y %H:%M:%S'))
print("========\n")

print("| Anzahl | Artikel      | Art.Nr         | Stueckpreis | Preis      |")
print("| -------+--------------+----------------+-------------+------------|")

formatStr = "| {anz:6d} | {art:12s} | {an:14s} | {sPreis:11.2f} | {totP:10.2f} |"

pPreis = anz_Bananen * preis_Bananen
gPreis = gPreis + pPreis
print(formatStr.format(anz=anz_Bananen, art=bez_Bananen, an=artNr_Bananen, sPreis=preis_Bananen, totP=pPreis))

pPreis = anz_Nektarinen * preis_Nektarinen
gPreis = gPreis + pPreis
print(formatStr.format(anz=anz_Nektarinen, art=bez_Nektarinen, an=artNr_Nektarinen, sPreis=preis_Nektarinen, totP=pPreis))


pPreis = anz_Weine * preis_Weine
gPreis = gPreis + pPreis
print(formatStr.format(anz=anz_Weine, art=bez_Weine, an=artNr_Weine, sPreis=preis_Weine, totP=pPreis))
print("                                                         ----------")
print("                                      Rechnungsbetrag:{gPreis:13.2f}".format(gPreis=gPreis))
print("                                                         ==========")
print("\n\n")


