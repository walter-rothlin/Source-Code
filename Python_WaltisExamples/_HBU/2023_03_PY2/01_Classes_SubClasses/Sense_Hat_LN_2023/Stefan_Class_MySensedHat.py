#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: /home/sfrei/Documents/Source/2023_python/Class_MySensedHat.py
#
# Description: Erweiterte SenseHat Klasse LZK2
#
# Autor: Stefan Frei
#
# History:
# 11.12.2023   Stefan Frei      Initial Version
#
# ------------------------------------------------------------------

from sense_hat import SenseHat
from time import sleep

class MySenseHat(SenseHat):

    #def __init__(self):
    #    return
    
    # override methods

    def set_pixel(self, x, y, r=255, g=255, b=255):
        x = convert_coordinate(x)
        y = convert_coordinate(y)
        if not (xy_param_valid(x, y)):
            return
        super().set_pixel(x, y, r, g, b)

    def draw_line(self, x1, y1, x2, y2):
        if x1 == x2:
            for i in range(y1, y2+1):
                self.set_pixel(x1, i)
        else:
            slope = (get_slope(x1, y1, x2, y2))
            print(f'Slope = {slope}')

            if slope < 0:
                print('Slope is negative')
                slope = abs(slope)
                for i in range(y1, y2+1):
                    print(f'i={i}, i*slope={i*slope}')
                    self.set_pixel(i, i*slope)
            elif slope < 1:     
                for i in range(y1, y2+1):
                    self.set_pixel(i*slope, i)
            else:     
                for i in range(y1, y2+1):
                    self.set_pixel(i*slope, i)

    
    # setter / getter | Properties

# auxiliary methods

def xy_param_valid(x, y):
    min_coordinate, max_coordinate = 0, 7
    result = True
    params = (x, y)
    for coordinate in params:
        print(coordinate)
        if not (min_coordinate <= coordinate <= max_coordinate):
            print(coordinate, " out of range")
            result = False
    return result

def get_slope(x1, y1, x2, y2):

    return (x1-x2)/(y1-y2)

def convert_coordinate(coordinate):
    if isinstance(coordinate, int):
        return coordinate
    else:
        try:
            return round(coordinate)
        except Exception as e:
            print(e)
        try:
            return int(float(coordinate))
        except Exception as e:
            print(e)




if __name__ == '__main__':
    print('Automated Testing of class MySenseHat.py')
    test_cases_processed = 0
    test_cases_failed = 0

    sense = MySenseHat()
    sense.set_rotation(180)

    # Aufgabe 1.1, x=4, y=5, rot
    print('Aufgabe 1.1, x=4, y=5, rot')
    try:
        sense.set_pixel(4, 5, 255, 0, 0)
        sleep(3)
        sense.clear()
    except Exception as e:
        print(f'ERROR:{e}')
        test_cases_failed +=1
    test_cases_processed += 1

    #Aufgabe 1.2, x=8, y=5, grün
    print('Aufgabe 1.2, x=8, y=5, grün')
    try:
        sense.set_pixel(8, 5, 0, 255, 0)
        sleep(3)
        sense.clear()
    except Exception as e:
        print(f'ERROR:{e}')
        test_cases_failed +=1
    test_cases_processed += 1

    #Aufgabe 2.2, x=6.3, y=3.7, grün
    try:
        print('Aufgabe 2.2, x=6.3, y=3.7, grün')
        sense.set_pixel(6.3, 3.4, 0, 255, 0)
        sleep(3)
        sense.clear()
    except Exception as e:
        print(f'ERROR:{e}')
        test_cases_failed +=1
    test_cases_processed += 1

    #Aufgabe 2.3, x='5.6', y='2.2', blau
    try:
        print('Aufgabe 2.3, x="5.6", y="2.2", blau')
        sense.set_pixel("5.6", "2.2", 0, 0, 255)
        sleep(2)
        sense.clear()
    except Exception as e:
        print(f'ERROR:{e}')
        test_cases_failed +=1
    test_cases_processed += 1

#Aufgabe 3.1, 
    A = [0,0]
    B = [5,7]
    sense.set_pixel(A[0], A[1], 0, 255, 0)
    sense.set_pixel(B[0], B[1], 255, 0, 0)

    sleep(1.5)
    sense.draw_line(A[0], A[1], B[0], B[1])

    sleep(3)
    sense.clear()

#Aufgabe 3.2 vertikale Linie
    A = [5,1]
    B = [5,6]
    sense.set_pixel(A[0], A[1], 0, 255, 0)
    sense.set_pixel(B[0], B[1], 255, 0, 0)

    sleep(1.5)
    sense.draw_line(A[0], A[1], B[0], B[1])

    sleep(3)
    sense.clear()

#Aufgabe 3.3, 
    A = [0,7]
    B = [4,4]
    sense.set_pixel(A[0], A[1], 0, 255, 0)
    sense.set_pixel(B[0], B[1], 255, 0, 0)

    sleep(1.5)
    sense.draw_line(A[0], A[1], B[0], B[1])

    sleep(3)
    sense.clear()
        
    
    print('Statistics:')
    print('test_cases_processed:', test_cases_processed)
    print('test_cases_failed:', test_cases_failed)

