#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_05b_OperatorOverloading.py
#
# Description: Example for Operator Overloading
#
# Autor: Walter Rothlin
#
# History:
# 26-Sep-2020   Walter Rothlin      Initial Version
# 26-Sep-2020   Walter Rothlin      Added to GitHub
#
# ------------------------------------------------------------------
import math

class Point:  # analog für Class Komplex, Bruch

    def __init__(self, xCoord=0, yCoord=0):
        self.__xCoord = xCoord
        self.__yCoord = yCoord

    # get x coordinate
    def get_xCoord(self):
        return self.__xCoord

    # set x coordinate
    def set_xCoord(self, xCoord):
        self.__xCoord = xCoord

    # get y coordinate
    def get_yCoord(self):
        return self.__yCoord

    # set y coordinate
    def set_yCoord(self, yCoord):
        self.__yCoord = yCoord

    # get current position
    def get_position(self):
        return self.__xCoord, self.__yCoord

    # change x & y coordinates by p & q
    def move(self, p, q):
        self.__xCoord += p
        self.__yCoord += q

    # toString()
    def __str__(self):
        return "(" + str(self.__xCoord) + "/" + str(self.__yCoord) + ")"

    # Math operators
    # --------------

    # overload + operator
    def __add__(self, point_ov):
        return Point(self.__xCoord + point_ov.__xCoord, self.__yCoord + point_ov.__yCoord)

    # overload - operator
    def __sub__(self, point_ov):
        return Point(self.__xCoord - point_ov.__xCoord, self.__yCoord - point_ov.__yCoord)

    # overload * operator
    def __mul__(self, point_ov):
        return Point(self.__xCoord * point_ov.__xCoord, self.__yCoord * point_ov.__yCoord)

    # overload / operator
    def __truediv__(self, point_ov):
        return Point(self.__xCoord / point_ov.__xCoord, self.__yCoord / point_ov.__yCoord)

    # overload % operator
    def __mod__(self, point_ov):
        return Point(self.__xCoord % point_ov.__xCoord, self.__yCoord % point_ov.__yCoord)

    # Logic operators
    # ---------------

    # overload < (less than) operator
    def __lt__(self, point_ov):
        return math.sqrt(self.__xCoord ** 2 + self.__yCoord ** 2) < math.sqrt(point_ov.__xCoord ** 2 + point_ov.__yCoord ** 2)

    # overload > (greater than) operator
    def __gt__(self, point_ov):
        return math.sqrt(self.__xCoord ** 2 + self.__yCoord ** 2) > math.sqrt(point_ov.__xCoord ** 2 + point_ov.__yCoord ** 2)

    # overload <= (less than or equal to) operator
    def __le__(self, point_ov):
        return math.sqrt(self.__xCoord ** 2 + self.__yCoord ** 2) <= math.sqrt(point_ov.__xCoord ** 2 + point_ov.__yCoord ** 2)

    # overload >= (greater than or equal to) operator
    def __ge__(self, point_ov):
        return math.sqrt(self.__xCoord ** 2 + self.__yCoord ** 2) >= math.sqrt(point_ov.__xCoord ** 2 + point_ov.__yCoord ** 2)

    # overload == (equal to) operator
    def __eq__(self, point_ov):
        return math.sqrt(self.__xCoord ** 2 + self.__yCoord ** 2) == math.sqrt(point_ov.__xCoord ** 2 + point_ov.__yCoord ** 2)

    # overload != (not equal to) operator
    def __ne__(self, point_ov):
        return math.sqrt(self.__xCoord ** 2 + self.__yCoord ** 2) != math.sqrt(point_ov.__xCoord ** 2 + point_ov.__yCoord ** 2)

if __name__ == '__main__':
    point1 = Point(2, 4)
    point2 = Point(12, 8)
    point3 = Point(2)
    point4 = Point(yCoord=3)

    print("point1:", point1, "   point2:", point2, "   point3:", point3, "   point4:", point4)
    print("point1:", point1, "+", point2, " = ", point1 + point2)
    print("point1:", point1, "+", point2, "=", point1 + point2,sep="")
    print("point1:", str(point1) + " + " + str(point2), " + ", point3, " = ", point1 + point2 + point3)
    print("point1 < point2:", point1 < point2)
    print("point1 > point2:", point1 > point2)
    print("point1 <= point2:", point1 <= point2)
    print("point1 >= point2:", point1 >= point2)
    print("point1 == point2:", point1 == point2)
    print("point1 != point2:", point1 != point2)
