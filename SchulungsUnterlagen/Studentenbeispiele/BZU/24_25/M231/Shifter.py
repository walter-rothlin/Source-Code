print('Shifter')
print('=======')

print(-133 * 3, '133' + '5', 3.1415, 3.0, True and not False)
print('Hallo \'\n"Walti"', "'8610' Uster")

print('Hallo', end='') # Zeilenend Kommentar
print(end='')
print("Walti", "!", sep='')
print('\n\nKreisberechnungen')

pi = 3.1414926
# radius = float(input('Radius r:'))
radius = 10
resultat_str = f'''
    Radius:{radius:10.2f}  
    Umfang:{2 * radius * pi:10.2f}
    Fläche:{radius**2 * pi:10.2f}
'''
print(resultat_str)


ein_multiline_str = '''
      Hallo 
      Uster
'''

print(ein_multiline_str)

klar_text = input('Klartext:')
for a_chr in klar_text:
    print(a_chr, ' --> ', ord(a_chr), chr(ord(a_chr) + 3))


