class Car:

    def __init__(self, marke="Alfa", farbe="weiss", v=0, maxSpeed=130):
        self.__marke = marke
        self.__color = farbe
        self.__speed = v
        self.__maxSpeed = maxSpeed

    def __str__(self):
        return """
           Marke:""" + self.__marke + """
           Farbe:""" + self.__color + """
           Speed:""" + str(self.__speed)


    def setMarke(self, newMarke):
        self.__marke = newMarke

    def getMarke(self):
        return self.__marke

    def setColor(self, newColor):
        self.__color = newColor

    def getColor(self):
        return self.__color

    def setSpeed(self, newSpeed):
        if newSpeed > self.__maxSpeed:
            self.__speed = self.__maxSpeed
        else:
            self.__speed = newSpeed

    def getSpeed(self):
        return self.__speed

    def increaseSpeed(self, vDiff):
        self.setSpeed(self.__speed + vDiff)

class Racecar(Car):
    def __init__(self, marke="Ferrari", farbe="rot", v=0, maxSpeed=200, gewicht=800):
        super().__init__(marke=marke, farbe=farbe, v=v, maxSpeed=maxSpeed)
        self.__gewicht = gewicht

    def __str__(self):
        return "Racecar::" + "Gewicht:" + str(self.__gewicht) + super().__str__()

    def setSpeed(self, newSpeed):
        super().setSpeed(newSpeed)





if __name__ == '__main__':
    waltisCar = Car("BMW", "weiss")
    print("Waltis Car after init:", waltisCar)
    waltisCar.setSpeed(300)
    print("Waltis Car after setSpeed:", waltisCar)

    felixsCar = Car("Fiat", "blau")
    print("Felixs Car:", felixsCar)
    felixsCar.increaseSpeed(10)
    felixsCar.increaseSpeed(125)
    print("Felixs Car:", felixsCar)

    claudiasCar = Car(farbe="gruen")
    print("Claudias Car:", claudiasCar, "\n\n")


    schumisCar = Racecar(marke="Ferrari", farbe="rot", maxSpeed=340)
    print(schumisCar)
    schumisCar.setSpeed(223)
    print(schumisCar)



