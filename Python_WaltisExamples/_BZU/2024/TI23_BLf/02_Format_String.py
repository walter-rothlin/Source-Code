
schule_1 = ['BZU', 'Uster', 8610, 9.2]
schule_2 = ['HWZ', 'Zürich', 8000, 12.234]
schule_3 = ['HSG', 'St. Gallen', 9000, 11.274]

schulen = [schule_1, schule_2, schule_3]

print(schule_1[2])
print(schulen[2])
print('\n\n\n\n')

format_str = '{nr:2d}) {schulname:0s}, {plz:4d} {ortsname:10s} {temp:4.1f}'
nummer = 9
for eine_schule in schulen:
    print(format_str.format(nr=nummer, plz=eine_schule[2], schulname=eine_schule[0], temp=eine_schule[3], ortsname=eine_schule[1]))
    nummer += 1


nummer = 8
for eine_schule in schulen:
    print(f'{nummer:2d}) {eine_schule[0]:0s}, {eine_schule[2]:4d} {eine_schule[1]:10s} {eine_schule[3]:4.1f}')
    nummer += 1

print('\n\n\n\n')

print(' 1) BZU, 8610 Uster')
print(' 1) ', schule_1[0], ', ', schule_1[2], ' ', schule_1[1], ' ', schule_1[3], sep='')
print(' 2) ' + schule_1[0] + ', ' + str(schule_1[2]) + ' ' + schule_1[1] + ' ' + str(schule_1[3]), sep='')
print(' 2) ' + schule_2[0] + ', ' + str(schule_2[2]) + ' ' + schule_2[1] + ' ' + str(schule_2[3]), sep='')
print('10) {schulname:0s}, {plz:4d} {ortsname:10s} {temp:4.1f}'.format(plz=schule_1[2], schulname=schule_1[0], temp=schule_1[3], ortsname=schule_1[1]))
print('10) {schulname:0s}, {plz:4d} {ortsname:10s} {temp:4.1f}'.format(plz=schule_2[2], schulname=schule_2[0], temp=schule_2[3], ortsname=schule_2[1]))
print('10) {schulname:0s}, {plz:4d} {ortsname:10s} {temp:4.1f}'.format(plz=schule_3[2], schulname=schule_3[0], temp=schule_3[3], ortsname=schule_3[1]))
print('\n\n\n\n')

format_str = '10) {schulname:0s}, {plz:4d} {ortsname:10s} {temp:4.1f}'
print(format_str.format(plz=schule_1[2], schulname=schule_1[0], temp=schule_1[3], ortsname=schule_1[1]))
print(format_str.format(plz=schule_2[2], schulname=schule_2[0], temp=schule_2[3], ortsname=schule_2[1]))
print(format_str.format(plz=schule_3[2], schulname=schule_3[0], temp=schule_3[3], ortsname=schule_3[1]))


eine_adresse = {
    'vorname': 'Walter',
    'nachname': 'Rothlin',
    'strasse': 'Peterliwiese 33',
    'plz': 8855,
    'ort': 'Wangen',
}

print(eine_adresse['plz'])
print(eine_adresse.get('Plz'))

adress_liste = [
    eine_adresse,
{
    'vorname': 'Fritz',
    'nachname': 'Müller',
    'strasse': 'Zürcherstr. 23',
    'plz': 8008,
    'ort': 'Zürich',
},
{
    'vorname': 'Hugo',
    'nachname': 'Bigi',
    'strasse': 'Knobelstr. 1',
    'plz': 3003,
    'ort': 'St. Gallen',
},
]

nummer = 9
print(f"{'--'}+{'----------'}+{'----------'}+{'--------------------'}+{'----'}+{'--------------------'}")
print(f"{'Nr'}|{'Vorname   '}|{'Nachname  '}|{'Strasse             '}|{'Plz '}|{'Ort                 '}")
print(f"{'--'}+{'----------'}+{'----------'}+{'--------------------'}+{'----'}+{'--------------------'}")
for eine_adresse in adress_liste:
    print(f"{nummer:2d}|{eine_adresse['vorname']:10s}|{eine_adresse['nachname']:10s}|{eine_adresse['strasse']:20s}|{eine_adresse['plz']:4d}|{eine_adresse['ort']:20s}")
    nummer += 1
print(f"{'--'}+{'----------'}+{'----------'}+{'--------------------'}+{'----'}+{'--------------------'}")
