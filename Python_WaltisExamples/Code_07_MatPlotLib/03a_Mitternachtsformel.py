from math import sqrt as wurzel
import matplotlib.pyplot as plt
import numpy as np


def Mitternachtsformel(a, b, c):
    # Berechnungen Mitternachtsformel
    diskriminante = b**2 - 4*a*c

    # Schaut ob die diskriminante unter 0 ist
    if diskriminante < 0:
        return [diskriminante]
    else:
        x1 = round(float(-b + wurzel(diskriminante)) / (2*a), 2)
        x2 = round(float(-b - wurzel(diskriminante)) / (2*a), 2)
        return [diskriminante, x1, x2]


def graph(a, b, c):
    # 100 linearly spaced numbers
    x = np.linspace(-5, 5, 100)

    # the function

    y = ((a * (x**2)) + (b*x)) + c

    # setting the axes at the centre
    fig = plt.figure()
    ax = fig.add_subplot(1, 1, 1)
    ax.spines['left'].set_position('center')
    ax.spines['bottom'].set_position('zero')
    ax.spines['right'].set_color('none')
    ax.spines['top'].set_color('none')
    ax.xaxis.set_ticks_position('bottom')
    ax.yaxis.set_ticks_position('left')

    # plot the function
    plt.plot(x, y, 'r')

    # show the plot
    plt.show()

# User Inputs
print('Mitternachtsformel:')
print()
a = input('a: ')     # INFO: str(input('a: ')  str ist nicht nötig da input return value is String
b = input('b: ')
c = input('c: ')

# Check if a or b or c is a str or not
# INFO nicht optimal #  if a.isalpha() or b.isalpha() or c.isalpha():  # INFO nicht nötig == True:
if a.isnumeric() and b.isnumeric() and c.isnumeric():
    # Konvertiert a,b,c zurück zu floats
    a = float(a)
    b = float(b)
    c = float(c)
    loesungen = Mitternachtsformel(a, b, c)  # INFO Function immer mit Parameter aufrufen!
    print(loesungen)
    print("Diskriminante:", loesungen[0])
    graph(a, b, c)               # INFO Function immer mit Parameter aufrufen!
else:
    print('ERROR Bitte gebe keine Buchstaben an.')