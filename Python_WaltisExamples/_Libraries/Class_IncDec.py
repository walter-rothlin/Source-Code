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
    def __init__(self, currentValue=0, stepUp=1, stepDown=-1, max=1000, min=0):
        self.__currentValue = currentValue
        self.__stepUp = stepUp
        self.__stepDown = stepDown
        self.__max = max
        self.__min = min

    # operator overloading
    # --------------------
    # toString()
    def __str__(self):
        return "Inc:" + str(self.__stepUp) + "  Dec:" + str(self.__stepDown) + " im Intervall:[" + str(
            self.__min) + " .. " + str(self.__max) + "] = " + str(self.__currentValue)

    # Bussiness-Methods
    # -----------------
    def inc(self):
        self.__currentValue = self.__currentValue + self.__stepUp
        if self.__currentValue > self.__max:
            self.__currentValue = self.__max
        return self.__currentValue

    def dec(self):
        self.__currentValue = self.__currentValue - self.__stepDown
        if self.__currentValue < self.__min:
            self.__currentValue = self.__min
        return self.__currentValue

    # Methoden (setter / getter)
    # --------------------------
    def getValue(self):
        return self.__currentValue

    def setValue(self, newValue):
        self.__currentValue = newValue
        return self.__currentValue

    def setInc(self, newValue):
        self.__stepUp = newValue
        return self.__stepUp

    def setDec(self, newValue):
        self.__stepDown = newValue
        return self.__stepDown


if __name__ == '__main__':
    testCount = 0
    testFailed = 0

    testCount += 1
    inc_1 = IncDec(currentValue=990)
    if inc_1.getValue() != 990:
        testFailed += 1
        print("Test-Case 1 NOT OK")

    testCount += 1
    inc_1.inc()
    inc_1.inc()
    if inc_1.getValue() != 992:
        testFailed += 1
        print("Test-Case 2 NOT OK")

    testCount += 1
    if str(inc_1) != "Inc:1  Dec:-1 im Intervall:[0 .. 1000] = 992":
        testFailed += 1
        print("Test-Case 3 NOT OK")
        print("Result:", str(inc_1))

    testCount += 1
    inc_1.setInc(5)
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
    inc_2 = IncDec(currentValue=20, stepUp=2, stepDown=-3, max=10, min=-10)
    if str(inc_2) != "Inc:2  Dec:-3 im Intervall:[-10 .. 10] = 20":
        testFailed += 1
        print("Test-Case 6 NOT OK")
        print("Result:", str(inc_2))

    print("executed Tests", testCount, "     Failed:", testFailed)
