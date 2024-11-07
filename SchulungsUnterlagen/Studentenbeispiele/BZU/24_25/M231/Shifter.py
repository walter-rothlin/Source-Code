#
# ================================================
# ================================================


print('Shifter')
print('=======')

print('Hallo' + "BZU", 123+5, '123', 3.14, True, False, 'True', sep=';;', end='--->')
print('Ha"\'ll####o', "Ha'l\"l\\\"o", sep=' ', end='\n') # Default Values for sep and end
print("\nHallo\nBZU")
pi = 3.1415926

print(pi)

radius = float(input('Kreisradius:'))
print(f'Radius:{radius:7.2f} --> Umfang:{2 * radius * pi:0.2f}')

