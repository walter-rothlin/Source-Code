#!/usr/bin/python3

# ------------------------------------------------------------------
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2023_03_PY2/01_Classes_SubClasses/Car.py
#
# Description: Beispiele
#
# Autor: Walter Rothlin
#
# History:
# 06-Sep-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
class Car:
    '''
    Diese Klasse representiert ein Auto.......

    Der Initializer kann....
    '''
    max_serien_nummer = 1000
    do_trace = False

    def __init__(self, auto_marke='BMW', farbe='Weiss'):
        self.__marke = auto_marke
        self.__color = farbe
        Car.max_serien_nummer += 1
        self.__seriennummer = Car.max_serien_nummer

    def __str__(self):
        if Car.do_trace:
            return f'''
            Object der Class Car:
            Marke: {self.__marke}
            Farbe: {self.__color}
            Serien-Nummer: {self.__seriennummer}
        '''
        else:
            return "Ein Objekt der Klasse Car"

    def get_marke(self):
        return self.__marke

    car_marke = property(get_marke)

    def set_color(self, new_color='Weiss'):
        self.__color = new_color

    def get_color(self):
        return self.__color

    car_color = property(get_color, set_color)

    @staticmethod
    def set_max_serial_number(new_init_value):
        Car.max_serien_nummer = new_init_value


print('Aufrufer:', __name__)
if __name__ == '__main__':
    Car.set_max_serial_number(2000)
    waltis_car = Car()
    waltis_car.set_max_serial_number(3000)
    remos_car = Car()
    fritz_car = Car()
    waltis_car.__marke = "Opel"     # dynamisches Attribut


    print(waltis_car)
    Car.do_trace = True
    print(fritz_car)
    print(remos_car)

    print(waltis_car.__marke)
    print(waltis_car.get_marke())
    waltis_car.get_color()

    waltis_car.set_color('Blue')
    print(waltis_car.get_color())
    print(waltis_car.car_marke)

    # waltis_car.car_marke = "Fiat"  # property only has a getter

    waltis_car.car_color = 'Pink'
    print(waltis_car.car_color)
