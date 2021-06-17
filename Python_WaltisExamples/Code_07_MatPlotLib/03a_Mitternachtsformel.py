from math import sqrt as wurzel
import matplotlib.pyplot as plt
import numpy as np

#Inputs
print('Mitternachtsformel:')
print()
a = str(input('a: '))
b = str(input('b: '))
c = str(input('c: '))

def Mitternachtsformel():
    #Berschnungen Mitternachtsformel
    diskriminante = b**2 - 4*a*c
    #Schaut ob die diskriminante unter 0 ist
    if diskriminante < 0:
        print('Keine lösung:')
    else:
        x1 = round(float(-b + wurzel(diskriminante)) / (2*a), 2)
        x2 = round(float(-b - wurzel(diskriminante)) / (2*a), 2)
        print()
        print('Diskriminante:', diskriminante)
        print('x1:', x1)
        print('x2:', x2)
        print()

def graph():
    # 100 linearly spaced numbers
    x = np.linspace(-5,5,100)

    # the function

    y = ((a * (x**2) ) + (b*x)) + c

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
    plt.plot(x,y, 'r')

    # show the plot
    plt.show()

#Check if a or b or c is a str or not
if a.isalpha() or b.isalpha() or c.isalpha() == True:
    print('ERROR Bitte Gebe keine Buchstaben an.')
else:
    #Konvertiert a,b,c zurück zu floats
    a = float(a)
    b = float(b)
    c = float(c)
    Mitternachtsformel()
    graph()



