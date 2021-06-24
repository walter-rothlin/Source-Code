from math import sqrt as wurzel
import matplotlib.pyplot as plt
import numpy as np


# INFO mit Parameter arbeiten    NOT def Mitternachtsformel():
def Mitternachtsformel(a, b, c):
    # Berechnungen Mitternachtsformel
    diskriminante = b**2 - 4*a*c

    # Schaut ob die diskriminante unter 0 ist
    if diskriminante < 0:
        print('Keine Lösung:')
    else:
        x1 = round(float(-b + wurzel(diskriminante)) / (2*a), 2)
        x2 = round(float(-b - wurzel(diskriminante)) / (2*a), 2)
        print()
        print('Diskriminante:', diskriminante)
        print('x1:', x1)
        print('x2:', x2)
        print()

# INFO mit Parameter arbeiten # def graph():
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
a1 = input('a: ')     # INFO: str(input('a: ')  str ist nicht nötig da input return value is String
b1 = input('b: ')
c1 = input('c: ')

# Check if a or b or c is a str or not
# INFO nicht optimal #  if a.isalpha() or b.isalpha() or c.isalpha():  # INFO nicht nötig == True:
if a1.isdecimal() and b1.isdecimal() and c1.isdecimal():
    # Konvertiert a,b,c zurück zu floats
    a1 = float(a)
    b1 = float(b)
    c1 = float(c)
    Mitternachtsformel(a=a1, b=b1, c=c1)  # INFO Function immer mit Parameter aufrufen!
    graph(a, b, c)               # INFO Function immer mit Parameter aufrufen!
else:
    print('ERROR Bitte gebe keine Buchstaben an.')




