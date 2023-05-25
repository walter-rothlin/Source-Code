
eineListe = [1, 4, 7, 23]
print('Die Liste:', eineListe)
print('Element mit index[2]:', eineListe[2])

print('\nIterieren durch die Liste')
for einElement in eineListe:
    print(einElement, einElement**2)

eineListe.append(54)
print('Die Liste:', eineListe, len(eineListe))

eineListe.insert(2, 100)
print('Die Liste:', eineListe, len(eineListe))

eineListe.remove(100)
print('Die Liste:', eineListe, len(eineListe))

zweiteListe = [3, 6, 7.8, 'Hallo', True, 4, 1, 8, 'BZU']
print('Die zweiteListe:', zweiteListe, len(zweiteListe))
print('Subliste:', zweiteListe, '---->', zweiteListe[2:4])
print('Subliste:', zweiteListe, '---->', zweiteListe[:2])
print('Subliste:', zweiteListe, '---->', zweiteListe[2:])
dritteListe = zweiteListe[2:]
print('dritteListe:', dritteListe)

print('Subliste:', zweiteListe, '---->', zweiteListe[-5:-2])

vorname = 'Walter'
for c in vorname:
    print(c)

print('Substr:', vorname, vorname[1:3])

for i in range(5, 10, 2):
    print(i)

for i in range(-10, 10):
    print(i)

for i in range(10, -10, -2):
    print(i)
