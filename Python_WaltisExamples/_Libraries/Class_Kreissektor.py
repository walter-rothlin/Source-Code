#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Kreissektor.py
#
# Description:
#
#
# Autor: Walter Rothlin
#
# History:
# 27-Sep-2021	Initial Version
#
# ------------------------------------------------------------------
import math


class Kreissektor:

    # Ctr (Konstruktor)
    # -----------------
    def __init__(self, radius=-1.0, durchmesser=-1.0, flaeche=-1.0, zentrieWinkel=-1.0):
        #  | r | d | A | z | CASE |
        #  +---+---+---+---+------+
        #  | x |   | x |   |   1  |
        #  +---+---+---+---+------+
        #  | x |   |   | x |   2  |
        #  +---+---+---+---+------+
        #  |   | x | x |   |   3  |
        #  +---+---+---+---+------+
        #  |   | x |   | x |   4  |
        #  +---+---+---+---+------+
        #  |   |   | x | x |   5  |
        #  +---+---+---+---+------+

        if (durchmesser == -1.0) and (radius == -1.0):
            self.case = 5
            # print("Fall 5")
            self.flaeche = flaeche
            self.zentrieWinkel = zentrieWinkel
            self.radius = math.sqrt(flaeche * 360 / (zentrieWinkel / math.pi))
            self.durchmesser = 2 * self.radius

        elif durchmesser == -1.0:
            self.radius = radius
            self.durchmesser = 2 * self.radius
            if (zentrieWinkel == -1.0):
                self.case = 1
                # print("Fall 1")
                self.flaeche = flaeche
                self.zentrieWinkel = (((self.radius ** 2) * math.pi)/self.flaeche) * 360
            else:
                self.case = 2
                # print("Fall 2")
                self.zentrieWinkel = zentrieWinkel
                self.flaeche = (((self.radius ** 2) * math.pi) * 360 / self.zentrieWinkel)

        elif radius == -1.0:
            self.durchmesser = durchmesser
            self.radius = self.durchmesser / 2
            if (zentrieWinkel == -1.0):
                self.case = 3
                # print("Fall 3")
                self.flaeche = flaeche
                self.zentrieWinkel = (((self.radius ** 2) * math.pi)/self.flaeche) * 360
            else:
                self.case = 4
                print("Fall 4")
                self.zentrieWinkel = zentrieWinkel
                self.flaeche = (((self.radius ** 2) * math.pi) * 360 / self.zentrieWinkel)
        else:
            self.radius = "ERROR"


    # Ctr (Konstruktor)
    # -----------------
    def __str__(self):
        # return ("r=" + str(self.radius) + "  d=" + str(self.durchmesser)+ "  A=" + str(self.flaeche)+ "  alpha=" + str(self.zentrieWinkel))
        return ("r={r:5.2f}  d={d:5.2f} A={A:6.2f} alpfa={ag:5.2f}° ({ar:5.2f})".format(r=self.radius, d=self.durchmesser, A=self.flaeche, ag=self.zentrieWinkel, ar=self.getZentrieWinkel(inGrad=False)))


    # getter Methoden
    # ---------------
    def getRadius(self):
        return self.radius

    def getDurchmesser(self):
        return self.durchmesser

    def getFlaeche(self):
        return self.flaeche

    def getZentrieWinkel(self, inGrad=True):
        if inGrad:
            return self.zentrieWinkel
        else:
            return self.zentrieWinkel * math.pi / 180




# Test Program
# ============
print("Kreissektor Test")
k1 = Kreissektor(radius=5,flaeche=157.079)
print("Fall 1   k1:", k1)

k2 = Kreissektor(radius=5,zentrieWinkel=180)
print("Fall 2   k2:", k2)

k3 = Kreissektor(durchmesser=10,flaeche=157.079)
print("Fall 3   k3:", k3)

k4 = Kreissektor(radius=5,flaeche=157.079)
print("Fall 4   k4:", k4)

k5 = Kreissektor(flaeche=157.079, zentrieWinkel=180)
print("Fall 5   k5:", k5)

# asciiRingbuffer.shiftRight()
# print(">", asciiRingbuffer.getAsList(), "\n")
# asciiRingbuffer.shiftRight()
# print(">", asciiRingbuffer.getAsList(), "\n")
#
# asciiRingbuffer.shiftLeft()
# print("<", asciiRingbuffer.getAsList(), "\n")
