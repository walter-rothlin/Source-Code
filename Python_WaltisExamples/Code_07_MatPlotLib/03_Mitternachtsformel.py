#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 02_drawGraph.py
#
# Description: Zeichnet einen linearen Graphen
#
# Autor: Walter Rothlin
#
# !!!! Falls Fehler “runtimeError: package fails to pass a sanity check”
# !!!!   check File | Settings | Python Interpreter
# !!!! 1.19.4 hat auf Windows einen Fehler!
# !!!!    pip install numpy==1.19.3
#
# History:
# 22.4.21   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from math import sqrt as wurzel
import matplotlib.pyplot as plt
import numpy as np

def Mitternachtsformel():
    print('Mitternachtsformel:')
    print()
    global a
    global b
    global c
    a = float(input('a: '))
    b = float(input('b: '))
    c = float(input('c: '))
    global x1
    global x2
    diskriminante = b**2 - 4*a*c
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


def Mitternachtsformel_Test():
    a = 2
    b = 1
    c = -4
    diskriminante = b**2 - 4*a*c
    x1 = round(float(-b + wurzel(diskriminante)) / (2*a), 2)
    x2 = round(float(-b - wurzel(diskriminante)) / (2*a), 2)
    if diskriminante == 33 and x1 == 1.19 and x2 == -1.69:
        print('Es wurden keine Fehler bei der Mitternachtsformel gefunden')
        print()
        Mitternachtsformel()
    else:
        print('Es wurde ein Fehler in der Funktion Mitternachtsformel() entdeckt!')
Mitternachtsformel_Test()

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