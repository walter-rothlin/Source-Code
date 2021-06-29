#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_10_exceptionHandling.py
#
# Description: Berechnet die Nullstellen einer quadratischen Funktion
#
# Autor: Walter Rothlin
#
# History:
# 26-May-2021   Walter Rothlin      Initial Version
# 10-Jun-2021   Walter Rothlin      Created readFloat()
# 17-Jun-2021   Walter Rothlin      Extended readFloat()
# 24-Jun_2021   Walter Rothlin      Use of own library
# ------------------------------------------------------------------
from waltisLibrary import *
import matplotlib.pyplot as plt
import numpy as np

def drawParabel(a, b, c):
    # 100 linearly spaced numbers
    x = np.linspace(-10, 10, 100)

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

# ====
# Main
# ====

print(unterstreichen("Quadratische Gleichung"))
# help("waltisLibrary.calcNullstellen")
help(calcNullstellen)

TEST_calcNulstellen()



a = readFloat("a=")
b = readFloat("b=")
c = readFloat("c=")
print("0 = ax\u00B2 + bx + c  ==> 0 = {a:1.2f}x\u00B2 + ({b:1.2f})x + ({c:1.2f})   x12=?".format(a=a, b=b, c=c))
loesungen = calcNullstellen(a, b, c)
print("Loesung      : ", loesungen)
print("Diskriminante: ", loesungen["Diskriminante"])
print("Solution Text: ", loesungen['Solution Text'])
print("Solutions    : ", loesungen['Solutions'])
drawParabel(a, b, c)
