liste_1 = [1, 6, 88, 12, 12.7, 'BZU', True, False, 67*2.0]
print('liste_1:', liste_1)
print('liste_1[2]:', liste_1[2])

liste_1.append(700)
print('liste_1 (after append):', liste_1)

liste_1.insert(2, 2341)
print('liste_1 (after insert(2, 2341)):', liste_1)


for ein_element in liste_1:
    print(ein_element)   #, ein_element**2)


liste_2 = liste_1[2:4][1:2]
print('liste_2:', liste_2)

liste_2 = liste_1[0:4]
print('liste_1:', liste_1)
print('liste_2:', liste_2)

liste_2 = liste_1[:4]
print('liste_1:', liste_1, len(liste_1))
print('liste_2:', liste_2, len(liste_2))

liste_2 = liste_1[-3:]
print('liste_1:', liste_1, len(liste_1))
print('liste_2:', liste_2, len(liste_2))

untere_grenze = 5
oberer_grenze = 100
for i in range(untere_grenze, oberer_grenze+1, 5):
    print(i, 2**i, i*i)


for i in range(10,-10,-3):
    print(i)
unterstreichen = 6 * '-**-'
print(unterstreichen)

name = 'Hallo Ihr Lernenden'
print('name:', name)
for c in name[-7:]:
    print(c)
