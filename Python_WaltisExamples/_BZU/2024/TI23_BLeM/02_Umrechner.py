menu_text = '''
  Umrechnungen
  ============
  1: Grad in Bogenmass
  2: Bogenmass in Grad

  3: Fahrenheit in Celsius
  4: Celsius in Fahrenheit

  0: Schluss
'''

do_loop = True
while do_loop:
    print(menu_text)
    auswahl = input('Wähle (0, 1..4):')
    if auswahl == '1':
        print('Grad in Bogenmass')     # rad  = grad*pi/180
        grad_value = float(input('Grad:'))
        rad_value = grad_value * 3.1415926 / 180
        print(f'{grad_value}°  --> {rad_value:0.3f}rad')

    elif auswahl == '2':
        print('Bogenmass in Grad')
    elif auswahl == '3':
        print('Fahrenheit in Celsius')
    elif auswahl == '4':
        print('Celsius in Fahrenheit')
    elif auswahl == '0':
        do_loop = False
        print('Schluss')
    else:
        print('Falsche Eingabe')

