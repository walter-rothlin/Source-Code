#!/usr/bin/python3

'''pruefung_5a_Listen.py'''

'''
8855 <U>Wangen</U>
['Walter', 'Rothlin', 'Peterliwiese 33', 8855, 'Wangen']
['Peterliwiese 33', 8855]
['Rothlin', 'Peterliwiese 33', 8855]
10
46
Traceback (most recent call last):
  File "G:\_WaltisDaten\SourceCode\GitHosted\Python_WaltisExamples\Code_00_Pruefung\pruefung_0_Listen.py", line 34, in <module>
    werteListe = result.split(separator=";")
TypeError: 'separator' is an invalid keyword argument for split()
'''


# Listen
# ------
namensListe=['Walter', 'Rothlin', 'Peterliwiese 33', 8855, 'Wangen']
ortPlz = str(namensListe[3]) + " <U>" + namensListe[4] + "</U>"
print(ortPlz)


print(namensListe)
print(namensListe[2:4])
print(namensListe[1:4])

preisListe = [12.45, 3.41, 4, 6]
print(preisListe[2]+preisListe[3])

preisListe = ["12.45", "3.41", "4", "6"]
print(preisListe[2]+preisListe[3])

result = "Hallo;BZU;Uster;Kanton Zuerich"
werteListe = result.split(separator=";")
print(werteListe)
