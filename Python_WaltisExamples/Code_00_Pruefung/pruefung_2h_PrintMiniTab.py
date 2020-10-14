#!/usr/bin/python3

'''pruefung_2h_PrintMiniTab.py'''

''' Expected Result:
123456789012345678901234567890
Artikel    Preis
Brot        4.50
Milch       1.25
Wurst       1.00
'''


bLabel = "Brot"
bPreis = 4.5
mLabel = "Milch"
mPreis = 1.25
qLabel = "Wurst"
qPreis = 1

tabFormatStr = "{art:8s} {pr:7.2f}"
print("123456789012345678901234567890")
print("Artikel    Preis")
print(tabFormatStr.format(art=bLabel, pr=bPreis))
print(tabFormatStr.format(art=mLabel, pr=mPreis))
print(tabFormatStr.format(art=qLabel, pr=qPreis))
