from car import Car

if __name__ == '__main__':
    waltis_car = Car(marke='Porsche')
    claudias_car = Car()
    waltis_car.set_speed()
    Car.do_trace = True
    print(waltis_car)
    print('Hallo')
