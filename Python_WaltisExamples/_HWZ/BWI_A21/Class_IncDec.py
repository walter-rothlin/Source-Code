class IncDec:

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



if __name__ == '__main__':
    print("Name des Aufrufers:", __name__)
    seaLevel = IncDec(20)
    print(seaLevel)



    print(seaLevel.get_counter())
    seaLevel.increment()
    seaLevel.increment()
    seaLevel.decrement()
    print(seaLevel.get_counter())




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

