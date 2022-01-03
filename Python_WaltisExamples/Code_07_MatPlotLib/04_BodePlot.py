#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 04_BodePlot.py
#
# Description: Zeichnet die verschiedenen Fälle des Bodediagrammes
#
# Autor: Walter Rothlin
#
# History:
# 29.12.21   Tobias Rothlin      Initial Version
# ------------------------------------------------------------------
import os

import numpy as np
import matplotlib.pyplot as plt

class PolNullStellen:
    def __init__(self, n, z):
        self.__n = n
        self.__z = z

    def show(self, fileName = "test"):
        nullstellen = np.roots(np.array(self.__n))
        polstellen  = np.roots(np.array(self.__z))
        print(nullstellen)
        print(polstellen)

        plt.grid(True, which='both', linestyle = '--')
        plt.axhline(0, color='#110000')
        plt.axvline(0, color='#110000')

        plt.scatter(np.real(nullstellen), np.imag(nullstellen), marker="o", c = ['#31517A'], label = "Nullstellen", s=100)
        plt.scatter(np.real(polstellen), np.imag(polstellen), marker="x" , c=['#DC505F'], label = "Polstellen" , s=100)
        plt.legend(loc='upper center')
        plt.savefig(fileName + "_PolNullStellen.svg", format="svg")

        plt.show()


class BodePlot:
    def __init__(self, n, z):
        self.__n = n
        self.__z = z

        self.__max = 2
        self.__min = -2

    def show(self, fileName = "test"):
        print("-----", fileName, "-----")
        print(self.__n)
        print(self.__z)

        w = np.logspace(self.__min, self.__max, 10000)
        w_img = w*1j

        m = self.__calculate_magnitude(w_img, self.__n, self.__z)

        p = self.__calculate_phase(w_img, self.__n, self.__z)
        plt.subplot(2, 1, 1)
        plt.plot(w, m, c = '#73BF94')
        plt.xscale("log")
        plt.ylim((-50, 50))
        plt.grid(True, which='both')

        plt.ylabel("Magnetude [dB]")

        plt.subplot(2, 1, 2)
        plt.plot(w, p, c = '#73BF94')
        plt.xscale("log")
        plt.ylabel("Phase [°]")
        plt.xlabel("Frequency [rad/s]")
        if max(p) - min(p) < 10:
            plt.ylim(max(p)-45, max(p) + 45)
        plt.grid(True, which='both')
        plt.savefig(fileName + "_Bode.svg", format="svg")
        plt.show()

    def __calculate_magnitude(self, w, n, z):
        res = self.__calculate_function(w, n, z)
        return 20 * np.log10(np.abs(res))

    def __calculate_phase(self, w, n, z):
        res = self.__calculate_function(w, n, z)
        return 90 + (360/(2*np.pi)) * -np.arctan(np.real(res)/np.imag(res))

    def __calculate_function(self, w, n, z):
        magnitude = []
        for f in w:
            sumN = 0
            sumZ = 0
            for i in range(len(n)):
                sumN += n[i] * np.power(f, len(n) - 1 - i)

            for i in range(len(z)):
                sumZ += z[i] * np.power(f, len(z) - 1 - i)

            magnitude.append(sumN / sumZ)
        return np.array(magnitude)

# Main
# ====
FuctionsToPlot = [
    [[1, 0.2, 1.01], [1], "PlotOutput/1"],
    [[1, 0.4, 1.04], [1], "PlotOutput/2"],
    [[1, 0.000001, 1], [1], "PlotOutput/3"],
    [[1], [1, 0.2, 1.01], "PlotOutput/4"],
    [[1, 0.000001, -1], [1], "PlotOutput/5"],
    [[1], [1, 0.000001, -1], "PlotOutput/6"],
    [[1], [1, 0.000001, 1], "PlotOutput/7"],
    [[1, 2.8, 2.84, 1.232, 0.192], [1], "PlotOutput/8"],
    [[1, 0.9428, 0.4444], [1, 1.414, 1], "PlotOutput/9"],
    [[1, 1.414, 1], [1, 0.9428, 0.4444], "PlotOutput/10"],
    [[1, -1], [1, 0.000000000000001], "PlotOutput/11"],
    [[1, 0.0000001], [1, 1], "PlotOutput/12"],
    [[1, -1, 5], [1, 1, 5], "PlotOutput/13"],
    [[1], [1.0000, 2.6000, 2.5100, 1.0660, 0.1680], "PlotOutput/14"]
]


def drawAllPlots(value):
    try:
        os.mkdir("PlotOutput")
    except:
        print("Dir Exists")

    bode = BodePlot(value[0], value[1])
    bode.show(value[2])

    polNull = PolNullStellen(value[0], value[1])
    polNull.show(value[2])


for func in FuctionsToPlot:
    drawAllPlots(func)
