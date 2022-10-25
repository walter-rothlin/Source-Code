#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_IncDec.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HWZ/BWI_A21/Class_IncDec.py
#
# Description: Incrementer / Decrementer Klasse
#
# Autor: Walter Rothlin
#
# History:
# 27-Sep-2022   Walter Rothlin      Initial Version
# 11-Oct-2022   Walter Rothlin      Dynamische Attribute, Properties
# ------------------------------------------------------------------


class IncDec:
    """
    Dies ist unsere 1. Klasse!!!!

    """

    object_counter = 0   # Classvariable
    debug = True

    def __init__(self, counter=10, min_value=0, max_value=100, step_width=1):
        """
        Initalizer for Class IncDec:
            Parameter:
                counter:   Inital Value
                min_value: Min Value in a case of decrement lower than min value
                           set value to min value

        """
        self.__counter = counter
        self.__min_value = min_value
        self.__max_value = max_value
        self.__step_width = step_width
        self.__aValue = "Hallo HWZ!!!"
        IncDec.object_counter += 1    # Classvariable increment

    def __str__(self):
        return """
         min_value: """ + str(self.__min_value) + """
         max_value: """ + str(self.__max_value) + """
        """

    def increment(self):
        if self.__counter + self.__step_width <= self.__max_value:
            self.__counter = self.__counter + self.__step_width
        else:
            self.__counter = self.__max_value

    def decrement(self):
        if self.__counter - self.__step_width >= self.__min_value:
            self.__counter = self.__counter - self.__step_width
        else:
            self.__counter = self.__min_value

    def get_counter(self):
        return self.__counter

    def set_counter(self, counter):
        if counter <= self.__max_value and counter >= self.__min_value:
            self.__counter = counter


    def set_aValue(self, aValue):
        if IncDec.debug:
            print("set_aValue(" + aValue + ") called....")
        self.__aValue = aValue

    def get_aValue(self):
        print("get_aValue called....")
        return self.__aValue

    aktueller_value = property(get_aValue, set_aValue)

    @staticmethod
    def zeige_statistik():
        return "Statistics:" + str(IncDec.object_counter)

def zeige_statistik():   # Normale Funktion
    return "Keine Statistic!!!"

if __name__ == '__main__':
    # help(IncDec)
    # print(IncDec.__doc__)

    print("Name des Aufrufers:", __name__)
    print("IncDec.object_counter:", IncDec.object_counter)
    seaLevel = IncDec(20)
    print("IncDec.object_counter:", IncDec.object_counter)
    print(seaLevel)

    # Dynamisches Attribute
    # seaLevel.__aValue = "Guten Abend!!!"
    # print("seaLevel.__aValue:", seaLevel.__aValue)

    print("seaLevel.get_aValue():", seaLevel.get_aValue())
    seaLevel.set_aValue("Hallo Zuerich")
    print("seaLevel.get_aValue():", seaLevel.get_aValue())
    # print("seaLevel.__aValue:", seaLevel.__aValue)

    print("seaLevel.get_aValue():", seaLevel.get_aValue())
    print("\n\nSetzen und lesen einer Property")
    seaLevel.aktueller_value = "Setze die Property"
    print(seaLevel.aktueller_value)
    print("\n\n")
    print("seaLevel.get_aValue():", seaLevel.get_aValue())


    print(seaLevel.get_counter())
    seaLevel.increment()
    seaLevel.increment()
    seaLevel.decrement()
    print(seaLevel.get_counter())




    print("\nIncrement Tests:")
    tesla_speed = IncDec(counter=32, min_value=10, max_value=50, step_width=10)
    print("IncDec.object_counter:", IncDec.object_counter)
    print(tesla_speed)
    print(tesla_speed.get_counter())
    tesla_speed.set_counter(200)
    print(tesla_speed.get_counter())
    tesla_speed.set_counter(45)
    print(tesla_speed.get_counter())
    tesla_speed.increment()
    tesla_speed.increment()
    tesla_speed.increment()
    tesla_speed.increment()
    tesla_speed.increment()
    tesla_speed.increment()
    tesla_speed.increment()
    print(tesla_speed.get_counter())

    print("\nDecrement Tests:")
    tesla_speed.set_counter(22)
    print(tesla_speed.get_counter())
    tesla_speed.decrement()
    print(tesla_speed.get_counter())
    tesla_speed.decrement()
    print(tesla_speed.get_counter())


    print("\n\nAccessing Class-Variable")
    print("IncDec.object_counter     :", IncDec.object_counter)
    IncDec.object_counter = 5
    print("IncDec.object_counter     :", IncDec.object_counter)
    print("seaLevel.object_counter   :", seaLevel.object_counter)
    print("tesla_speed.object_counter:", tesla_speed.object_counter)

    IncDec.object_counter = 6666
    print("IncDec.object_counter     :", IncDec.object_counter)
    print("seaLevel.object_counter   :", seaLevel.object_counter)
    print("tesla_speed.object_counter:", tesla_speed.object_counter)

    seaLevel.object_counter = 7777
    print("IncDec.object_counter     :", IncDec.object_counter)
    print("seaLevel.object_counter   :", seaLevel.object_counter)
    print("tesla_speed.object_counter:", tesla_speed.object_counter)

    seaLevel_1 = seaLevel      # Object-Reference copy!! not a clone

    print(IncDec.zeige_statistik())
    print(seaLevel_1.zeige_statistik())


    print(seaLevel_1.zeige_statistik())
    print(zeige_statistik())

