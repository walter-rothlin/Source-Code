class IncDec:
    """
    CLASS Beschreibung

    """

    obj_counter = 0          # Klassenattribute
    # self.__counter = 0     # erzeugt ein Compilations-Fehler

    def __init__(self, counter=10, min_value=0, max_value=100, step_width=1):
        """
        Initalizer for Class IncDec:
            Parameter:
                counter:   Inital Value
                min_value: Min Value in a case of decrement lower than min value
                           set value to min value

        """
        IncDec.obj_counter += 1       # Klassenattribute
        self.__counter = counter
        self.__min_value = min_value
        self.__max_value = max_value
        self.__step_width = step_width
        self.name_public     = "Walti_public"
        self._name_protected = "Walti_protected"
        self.__name_private  = "Walti_private"


    def __str__(self):
        return """
         Name_public     : """ + self.name_public + """
         Name_protected  : """ + self._name_protected + """
         Name_private    : """ + self.__name_private + """\n         Nr:""" + str(IncDec.obj_counter) + """
         [""" + str(self.__min_value) + ".." + str(self.__counter) + ".." + str(self.__max_value) + "]"


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
        print("calling get_counter()")
        return self.__counter

    def set_counter(self, counter):
        print("calling set_counter(" + str(counter) + ")")
        if counter <= self.__max_value and counter >= self.__min_value:
            self.__counter = counter

    aktueller_zaehler = property(get_counter, set_counter)   # Property definieren, danach kann auf aktuellerzaehler "normal" zugegriffen werden

    @staticmethod
    def zeige_statistik():
        print("Statistic: ", IncDec.obj_counter)



if __name__ == '__main__':
    #   help(IncDec)   #
    print(IncDec.__doc__)


    print("Name des Aufrufers:", __name__)
    seaLevel = IncDec(20)
    print(seaLevel)
    seaLevel.name_public     = "Fritz_public"
    seaLevel._name_protected = "Fritz_protected"
    seaLevel.__name_private  = "Fritz_private"
    print(seaLevel.name_public)
    print(seaLevel._name_protected)
    print(seaLevel.__name_private)
    print(seaLevel)


    print(seaLevel.get_counter())
    print("direct-access to __counter (dynamisches Attribute)")
    seaLevel.__counter = 700
    print("---> (should be 700)", seaLevel.__counter)
    print(seaLevel)

    print("access via property")
    seaLevel.aktueller_zaehler = 77
    print("---> (should be 77)", seaLevel.aktueller_zaehler)
    print(seaLevel)

    seaLevel.increment()
    seaLevel.increment()
    seaLevel.increment()
    seaLevel.decrement()
    print(seaLevel.get_counter())

    # Zugriff auf Class-Attributes
    print(seaLevel.obj_counter, " ---> ", IncDec.obj_counter, " ---> ")




    print("\nIncrement Tests:")
    tesla_speed = IncDec(counter=32, min_value=10, max_value=50, step_width=10)
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

    # Zugriff auf Class-Attributes
    print("Zugriff auf Class-Attributes:", seaLevel.obj_counter, " ---> ", IncDec.obj_counter, " ---> ", tesla_speed.obj_counter)
    seaLevel.obj_counter = 5     # dynamisches Attribut crerated
    IncDec.obj_counter = 6
    tesla_speed.obj_counter = 7  # dynamisches Attribut crerated
    print("Zugriff auf Class-Attributes:", seaLevel.obj_counter, " ---> ", IncDec.obj_counter, " ---> ", tesla_speed.obj_counter)
    IncDec.zeige_statistik()
