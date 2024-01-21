
print('Hel"l\'o', 'BZ\nU', 12*3.1415926)
print("Hal'\".\\lo")
print('''
Hallo ihr 

lieben Lernenden!

Ihr verwendet gerade einen Multi-Line String
''')

anrede = 'Hallo'
first_name = 'Walter'
last_name = 'Rothlin'

print(anrede, first_name, last_name)
print(anrede, first_name, last_name, sep=' ')

print(anrede + first_name + last_name)
print(anrede + ' ' + first_name + " " + last_name)

print('\n')
print('Hallo', end='\n')
print(first_name)

durchmesser = 12.4
pi = 3.1415916
kreis_umfang = durchmesser * pi

print(durchmesser, " cm *", pi, '=', kreis_umfang, 'cm')
print(f'{durchmesser:10.1f}cm * pi = {kreis_umfang:10.2f}cm')
print(f'{0.5:10.1f}cm * pi = {0.5*pi:10.2f}cm')


print(f'{durchmesser:0.1f}cm * pi = {kreis_umfang:0.2f}cm')

