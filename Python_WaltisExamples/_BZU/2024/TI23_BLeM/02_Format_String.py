


ort_1   = ['BZU', 'Uster', 8610, 9.7]
ort_2 = ['HWZ', 'Zürich', 8000, 10.2]
ort_3 = ['Uni', 'Bern', 3000, 20]

print(ort_1)
print(ort_1[1])

print('BZU, 8610 Uster')
print(ort_1[0] + ', ', str(ort_1[2]) + ' ', ort_1[1], sep='')      # BZU, 8610 Uster

print('HWZ, 8000 Zürich 10.20°C')
print('{schule:0s}, {plz:0d} {ort:10s} {temp:7.2f}°C'.format(ort=ort_2[1], schule=ort_2[0], plz=ort_2[2], temp=ort_2[3]))
print('{schule:0s}, {plz:0d} {ort:10s} {temp:7.2f}°C'.format(ort=ort_1[1], schule=ort_1[0], plz=ort_1[2], temp=ort_1[3]))
print('{schule:0s}, {plz:0d} {ort:10s} {temp:7.2f}°C'.format(ort=ort_3[1], schule=ort_3[0], plz=ort_3[2], temp=ort_3[3]))

format_string = '{schule:15s}, {plz:5d} {ort:15s} {temp:7.1f}°C'
print(format_string.format(ort=ort_2[1], schule=ort_2[0], plz=ort_2[2], temp=ort_2[3]))
print(format_string.format(ort=ort_1[1], schule=ort_1[0], plz=ort_1[2], temp=ort_1[3]))
print(format_string.format(ort=ort_3[1], schule=ort_3[0], plz=ort_3[2], temp=ort_3[3]))

formatted_string = format_string.format(ort=ort_3[1], schule=ort_3[0], plz=ort_3[2], temp=ort_3[3])
print(formatted_string)



print(f'{ort_3[0]:0s}, {ort_3[2]:0d} {ort_3[1]:10s} {ort_3[3]:7.2f}°C')


print('\n\n\n')
schulen = [['BZU', 'Uster', 8610, 9.7], ['HWZ', 'Zürich', 8000, 10.2], ['Uni', 'Bern', 3000, 20]]
schulen.append(['HSG', 'St. Gallen', 1000, 25.234])
print(schulen[1][1], schulen[2][2])

s_nummer = 9
for eine_schule in schulen:
    print(f'{s_nummer:2d}) {eine_schule[0]:0s}, {eine_schule[2]:0d} {eine_schule[1]:10s} {eine_schule[3]:7.2f}°C')
    s_nummer += 1

print('\n\n\n')
adressen = [
{
    'vorname': 'Walti',
    'nachname': 'Rothlin',
    'alter': 64
},
{
    'vorname': 'Fritz',
    'nachname': 'Meier',
    'alter': 21
},
{
    'vorname': 'Ruth',
    'nachname': 'Müller',
    'alter': 51
}
]

print(adressen[0]['nachname'])

for eine_adresse in adressen:
    print(f"{eine_adresse['vorname']}")
