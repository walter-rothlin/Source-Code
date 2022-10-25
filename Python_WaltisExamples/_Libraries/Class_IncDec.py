#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_IncDec.py
#
# Description: Bildet eine Stepper ab.
#
# Autor: Walter Rothlin
#
# History:
# 24-Apr-2019	Initial Version
# 30-Sep-2021   Added Testing
#
# ------------------------------------------------------------------
class IncDec:
    """
    Inc or Dec in a given Intervall. If an over- resp under-flow happens it clips the value to the boundary

    """

    # Ctr (Konstruktor)
    # -----------------
    def __init__(self, current_value=0, step_up=1, step_down=-1, max=1000, min=0):
        self.__current_value = current_value
        self.__step_up = step_up
        self.__step_down = step_down
        self.__max = max
        self.__min = min

    # operator overloading
    # --------------------
    # toString()
    def __str__(self):
        return "Inc:" + str(self.__step_up) + "  Dec:" + str(self.__step_down) + " im Intervall:[" + str(
            self.__min) + " .. " + str(self.__max) + "] = " + str(self.__current_value)

    # Bussiness-Methods
    # -----------------
    def inc(self):
        self.__current_value = self.__current_value + self.__step_up
        if self.__current_value > self.__max:
            self.__current_value = self.__max
        return self.__current_value

    def dec(self):
        self.__current_value = self.__current_value - self.__step_down
        if self.__current_value < self.__min:
            self.__current_value = self.__min
        return self.__current_value

    # Methoden (setter / getter)
    # --------------------------
    def get_value(self):
        return self.__current_value

    def set_value(self, value):
        self.__current_value = value
        return self.__current_value

    def set_inc(self, value):
        self.__step_up = value
        return self.__step_up

    def set_dec(self, value):
        self.__step_down = value
        return self.__step_down


if __name__ == '__main__':
    testCount = 0
    testFailed = 0

    testCount += 1
    inc_1 = IncDec(current_value=990)
    if inc_1.get_value() != 990:
        testFailed += 1
        print("Test-Case 1 NOT OK")

    testCount += 1
    inc_1.inc()
    inc_1.inc()
    if inc_1.get_value() != 992:
        testFailed += 1
        print("Test-Case 2 NOT OK")

    testCount += 1
    if str(inc_1) != "Inc:1  Dec:-1 im Intervall:[0 .. 1000] = 992":
        testFailed += 1
        print("Test-Case 3 NOT OK")
        print("Result:", str(inc_1))

    testCount += 1
    inc_1.set_inc(5)
    inc_1.inc()
    if str(inc_1) != "Inc:5  Dec:-1 im Intervall:[0 .. 1000] = 997":
        testFailed += 1
        print("Test-Case 4 NOT OK")
        print("Result:", str(inc_1))

    testCount += 1
    inc_1.inc()
    if str(inc_1) != "Inc:5  Dec:-1 im Intervall:[0 .. 1000] = 1000":
        testFailed += 1
        print("Test-Case 5 NOT OK")
        print("Result:", str(inc_1))

    testCount += 1
    inc_2 = IncDec(current_value=20, step_up=2, step_down=-3, max=10, min=-10)
    if str(inc_2) != "Inc:2  Dec:-3 im Intervall:[-10 .. 10] = 20":
        testFailed += 1
        print("Test-Case 6 NOT OK")
        print("Result:", str(inc_2))

    print("executed Tests", testCount, "     Failed:", testFailed)
