# source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2024_04_PY2/01_Classes_SubClasses/car_tester.py
#
from car import Car

if __name__ == '__main__':
    waltis_car = Car(marke='Porsche')
    claudias_car = Car()
    waltis_car.set_speed()
    Car.do_trace = True
    print(waltis_car)
    print('Hallo')
