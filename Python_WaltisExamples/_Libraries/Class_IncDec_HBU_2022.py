#!/usr/bin/python3
# ------------------------------------------------------------------
# Name: Class_IncDec_HBU_2022.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Class_IncDec_HBU_2022.py
#
# Description: Incrementer / Decrementer Klasse
#
# Autor: Walter Rothlin
#
# History:
# 03-Oct-2022   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
class IncDec:
    """
        Class IncDec
    """
    object_counter = 0


    # Overwrite standard methods
    # --------------------------
    def __init__(self, counter=0, min=0, max=99):
        self.__min = min
        self.__max = max
        self.set_counter(counter)
        IncDec.object_counter += 1

    def __str__(self):
        return "IncDec (" + str(IncDec.object_counter) + "): [" + str(self.__min) + ".." + str(self.__counter)+ ".." + str(self.__max) + "]"

    # Business methods
    # ----------------
    """
        Increment
    """
    def increment(self):
        """
            Increment 1
        """
        if self.__counter < self.__max:
            self.__counter += 1

    def decrement(self):
        if self.__counter > self.__min:
            self.__counter -= 1

    # setter / getter methods
    # -----------------------
    def set_counter(self, counter):
        print("calling set_counter(" + str(counter) + ")")
        if counter >= self.__max:
            self.__counter = self.__max
        elif counter <= self.__min:
            self.__counter = self.__min
        else:
            self.__counter = counter

    def get_counter(self):
        return self.__counter

    aktueller_zaehler = property(get_counter, set_counter)

    @staticmethod
    def zeige_statistik():
        print("Statistics:" + str(IncDec.object_counter))



if __name__ == '__main__':
    print("Hallo World Class")
    ## help(IncDec)
    print(IncDec.__doc__)
    print(IncDec.increment.__doc__)

    speed = IncDec(counter=9, min=0, max=10)
    speed_1 = speed

    print("Speed  :"  , speed)
    print("Speed_1:", speed_1)
    speed.increment()
    speed.increment()
    print("Speed  :"  , speed)
    
    speed.set_counter(-10)
    print("Speed_1:", speed_1)
    speed_1.decrement()
    speed_1.decrement()
    speed.decrement()
    print("Speed  :"  , speed)
    print("Speed_1:", speed_1)

    level = IncDec(100)
    print("Level  :", level)
    print("Speed  :", speed)
    print("Speed_1:", speed_1)
    
    # Properties
    level.aktueller_zaehler = 67
    level.increment()
    print(level.aktueller_zaehler)

    # Class variables
    print(IncDec.object_counter)
    print(speed_1.object_counter)
    print(level.object_counter)

    IncDec.object_counter = 4711
    print(IncDec.object_counter)
    print(speed_1.object_counter)
    print(level.object_counter)

    speed_1.object_counter = 4712
    print(IncDec.object_counter)
    print(speed_1.object_counter)
    print(level.object_counter)

    IncDec.zeige_statistik()
    