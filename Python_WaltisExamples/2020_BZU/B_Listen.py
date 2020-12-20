# ------------------------------------------------------------------
# Name: B_Listen
#
# Description: List methoden
#
# Autor: Walter Rothlin
#
# History:
# 17-Dec-2020   Walter Rothlin      Initial Version
# -----------------------------------------------------------------

squares = [1, 4, 9]
print(squares)
print(squares[1], " * ", squares[2], " = ", squares[1] * squares[2])

einkaufsListe = ["Brot", "Milch", "Fleisch", 12, 12.5, True, 2*6, False]
print(einkaufsListe)
print(einkaufsListe[1] + einkaufsListe[0])
print(einkaufsListe[2:5])
print(einkaufsListe[:5])
print(einkaufsListe[3:])
subliste = einkaufsListe[3:]
print(subliste)

for artikel in einkaufsListe:
    print(artikel)

neueEinkaufsliste = [['Brot', 'Milch', 'Wurst'],[1,5,6],3.1415]
print(neueEinkaufsliste[1][1])

print("einkaufsListe:", einkaufsListe)
print("subliste     :", subliste)
einkaufsListe.append("Ende")
print("einkaufsListe:", einkaufsListe)
print("subliste     :", subliste)
einkaufsListe.remove("Milch")
einkaufsListe.remove(1)
einkaufsListe.remove(False)
einkaufsListe.pop(0)
print("einkaufsListe:", einkaufsListe)
print(einkaufsListe.count(12))
einkaufsListe.extend([700, 800, 900])
print("einkaufsListe:", einkaufsListe)
print(einkaufsListe.index('Ende'))

neueListe = [1,2,3,4,5,6,7,8,9]
copyListe = neueListe.copy()
cp_1liste = neueListe
print("neueListe:", neueListe)
print("copyListe:", copyListe)
print("cp_1liste:", cp_1liste)

copyListe.append("Ende_1")
cp_1liste.append("Ende_2")
print("after copyListe.append()")
print("neueListe:", neueListe)
print("copyListe:", copyListe)
print("cp_1liste:", cp_1liste)


