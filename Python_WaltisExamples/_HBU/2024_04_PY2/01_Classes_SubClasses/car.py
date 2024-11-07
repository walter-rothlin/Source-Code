from copy import copy

class Car:
    '''Das ist Waltis Auto-Klasse'''

    do_trace = False

    def __init__(self, marke, farbe='rot', vMax=120, v=0):
        '''
        Initialisiert ein Car Objekt

        :param marke: Automarke
        :param farbe: Autofarbe
        :param vMax:  Maximale Geschwindigkeit
        :param v:     Aktuelle Geschwindigkeit ist <= vMax

        '''
        self.__marke = marke
        self.__farbe = farbe
        self.__vMax = vMax
        self.__v = v

    def __str__(self):
        if Car.do_trace:
            return f'''
            Marke: {self.__marke}
            Farbe: {self.__farbe}
            vMax : {self.__vMax}
            v    : {self.__v}
            '''
        else:
            return "Ein Objekt der Klasse Car()"
    def __eq__(self, other):
        return self.__marke == other.__marke

    def get_speed(self):
        return self.__vMax

    def set_speed(self, new_v=0):
        if new_v > self.__vMax:
            self.__v = self.__vMax
        else:
            self.__v = new_v

    car_speed = property(get_speed, set_speed)



    @staticmethod
    def say_hello():
        print('Hallo BZU')

class Racecar(Car):

    def __init__(self, marke, farbe='rot', rennklasse=None, vMax=120, v=0):
        '''
        Initialisiert ein Car Objekt

        :param marke: Automarke
        :param farbe: Autofarbe
        :param rennklasse: F1, F2, F3, Nascar
        :param vMax:  Maximale Geschwindigkeit
        :param v:     Aktuelle Geschwindigkeit ist <= vMax

        '''
        super().__init__(marke=marke, farbe=farbe, v=v, vMax=vMax)
        self.__rennklasse = rennklasse

    def __str__(self):
        return f'''
        {super().__str__()}
                Rennklasse: {self.__rennklasse}
        '''


print(f'Caller:{__name__}')
if __name__ == '__main__':
    waltis_car = Car(marke='Porsche')
    waltis_car.Power = 1000
    waltis_car.set_speed(130)
    waltis_car.car_speed = 60
    stefans_car = Car(marke='Dodge')
    maxs_car = stefans_car
    fritzs_car = copy(stefans_car)
    stefans_car_1 = Car(marke='Porsche')

    Car.do_trace = True
    print(waltis_car)
    print(waltis_car.Power)
    # print(stefans_car.Power) # Power ist dynamisches Attribute


    print(stefans_car)
    print(maxs_car)
    print(fritzs_car)

    Car.say_hello()
    waltis_car.say_hello()
    Car.set_speed(waltis_car, 100)
    print(waltis_car)

    print(stefans_car)
    print(maxs_car)
    print(fritzs_car)

    print('\n\nTest EQ')
    if stefans_car_1 == waltis_car:
        print('Stefan hat das gleiche Auto wie Walti')
    else:
        print('Stefan hat ein anderes Auto wie Walti')



    print('Test der Racecars')
    maxes_car = Racecar(marke='Ferrari', farbe='rot', vMax=350, rennklasse='F1')
    print(maxes_car)