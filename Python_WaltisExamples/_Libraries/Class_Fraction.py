#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Fraction.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Class_Fraction.py
#
# Description: Implementiert einen Bruch (Farction) and the basics oparators
#
#
# Autor: Walter Rothlin
#
# History:
# 11-Oct-2022	Walter Rothlin  Initial Version __int__ __str__ and main
# 12-Oct-2022	Walter Rothlin  Kehrwert und automated testing
# 12-Oct-2022	Walter Rothlin  Add to_decimal(), mul(), div(), add(), sub() und automated testing
#                               Mod __str__
# 12-Oct-2022	Walter Rothlin  Implementing business methods
# 12-Oct-2022   Walter Rothlin  Implemented operators * / + and -
# 12-Oct-2022   Walter Rothlin  Simplifying automated testing
# 21-Nov-2023   Walter Rothlin  HBU Changes
# 22-Nov-2023   Walter Rothlin  Implemented TBI 21.11.23
#
# ------------------------------------------------------------------
from waltisLibrary import *
class Fraction:
    """
    Provides basic support for math operations with fractions
    """

    # Standard methods
    def __init__(self, zaehler=0, nenner=1, bruch=None, bruch_str=None):
        """
        - Check if nenner is not 0
        - only one sign
        - only Integers no floats nor string,....
        """
        if bruch is not None:        # TBI 21.11.2023: Clone
            pass
        elif bruch_str is not None:  # TBI 21.11.2023: String
            pass
        else:
            pass
        if nenner == 0:
            nenner = 1
        self.set_zaehler(zaehler)
        self.set_nenner(nenner)

    def __str__(self):
        """
        - Erzeugt eine String-Representation eines Bruches in der Form [3/4]
        """
        return self.to_string()


    def prettyprint(self):
        """Gibt den Bruch dreizeilig aus, wobei Zähler und Nenner
        zentriert gesetzt sind.
        """
        zaehler_str = str(self.__zaehler)
        nenner_str = str(self.__nenner)
        feldbreite = max(len(zaehler_str), len(nenner_str))
        bruchstrich = "-" * feldbreite
        return f'''
                {zaehler_str.center(feldbreite)}
                {bruchstrich}
                {nenner_str.center(feldbreite)}
                '''
    def to_string(self, sep="/", startChr="[", endChar="]"):
        return startChr + str(self.__zaehler) + sep + str(self.__nenner) + endChar


    # comparable methods (operators)
    # ------------------------------
    def __lt__(self, other):  # <
        """
        - True if self decimal value < other decimal value
        """
        return True

    def __gt__(self, other):  # >
        """
        - True if self decimal value > other decimal value
        """
        return True

    def __le__(self, other):  # <=
        """
        - True if self decimal value <= other decimal value
        """
        return True

    def __ge__(self, other):  # >=
        """
        - True if self decimal value >= other decimal value
        """
        return True

    def __eq__(self, other):  # ==
        """
        - True if Nenners and Zaehlers are equal (Not decimal value)
        """
        return True

    def __ne__(self, other):  # !=
        """
        - False if Nenners and Zaehlers are equal (Not decimal value)
        """
        return True


    # setter / getters and properties
    # -------------------------------
    def set_zaehler(self, zaehler):
        self.__zaehler = zaehler

    def get_zaehler(self):
        return self.__zaehler

    zaehler = property(get_zaehler, set_zaehler)

    def set_nenner(self, nenner):
        self.__nenner = nenner

    def get_nenner(self):
        return self.__nenner

    nenner = property(get_nenner, set_nenner)



    # unary business methods
    # ----------------------
    def reciprocal(self):
        """
        - setzt self auf dem Kehrwert [1/2] ==> [2/1]
        """
        tmp = self.__zaehler
        self.__zaehler = self.__nenner
        self.__nenner = tmp
        return self

    def to_decimal(self, roundAfter=2):
        """
        - gibt den Dezimal-Wert des Bruches zurück [1/2] ==> 0.5
        """
        return round(self.__zaehler / self.__nenner, roundAfter)

    def shorten(self, divisor=None):
        """
        - kürzt self [2/4] mit 2 ==> [1/2]
        """
        if divisor is None:
            divisor = 1   # TBI 21.11.23: TBI Use math.lcm() or math.gcd()
        self.__zaehler = int(self.__zaehler / divisor)
        self.__nenner = int(self.__nenner / divisor)
        return self

    def expand(self, factor=None):
        """
        - erweitert self [2/4] mit 2 ==> [4/8]
        """
        if factor is None:
            factor = 1   # TBI 21.11.23: Use math.lcm() or math.gcd()
        self.__zaehler = int(self.__zaehler * factor)
        self.__nenner = int(self.__nenner * factor)
        return self


    # binary business methods (Grundoperationen)
    # ------------------------------------------
    def mul(self, factor):
        return Fraction(self.__zaehler * factor.__zaehler, self.__nenner * factor.__nenner)

    # overload * operator
    def __mul__(self, factor):
        return self.mul(factor)



    def div(self, divisor):
        return Fraction(self.__zaehler * divisor.__nenner, self.__nenner * divisor.__zaehler)

    # overload / operator
    def __truediv__(self, divisor):
        return self.div(divisor)



    def add(self, summand):
        return Fraction(self.__zaehler * summand.__nenner + summand.__zaehler * self.__nenner, self.__nenner * summand.__nenner)

    # overload + operator
    def __add__(self, summand):
        return self.add(summand)



    def sub(self, subtrahend):
        return Fraction(self.__zaehler * subtrahend.__nenner - subtrahend.__zaehler * self.__nenner, self.__nenner * subtrahend.__nenner)

    # overload - operator
    def __sub__(self, subtrahend):
        return self.sub(subtrahend)




# static test methods
def TEST_SIMPLE_init_str(verbal=False):
    # Test Ctr and toString()
    testsPerformed = 0
    testsFailed = 0
    testCases = """
    Nr|Type|Zaehler |Nenner |Bruch_Str |Expected
    01|Ctr |1       |2      |          |[1/2]
    02|Ctr |3       |4      |          |[3/4]
    03|Ctr |6       |7      |          |[6/7]
    04|Ctr |1       |4      |          |[1/4]
    05|Ctr |2       |7      |          |[2/7]
    06|Ctr |55      |72     |          |[55/72]
    07|Ctr |-5      |40     |          |[-5/40]
    08|Ctr |5       |-40    |          |[-5/40]
    09|Ctr |-5      |-40    |          |[5/40]
    10|Ctr |        |       | [7/40]   |[7/40]
    11|Ctr |        |       | [-6]     |[-6/1]
    12|Ctr |        |       | [-7/40]  |[-7/40]
    """

    listOfTestCases = testCases.split("\n")
    for aTestCase in listOfTestCases[2:-1]:
        testsPerformed += 1
        listOfTestValues = aTestCase.split("|")
        param_1 = listOfTestValues[2].strip()
        if param_1 != "":
            param_1 = int(param_1)
        else:
            param_1 = None

        param_2 = listOfTestValues[3].strip()
        if param_2 != "":
            param_2 = int(param_2)
        else:
            param_2 = None

        param_3 = listOfTestValues[4].strip()
        if param_3 == "":
            param_3 = None

        expectedResult = listOfTestValues[5].strip()

        if param_3 is None:
            bruch_1 = Fraction(zaehler=param_1, nenner=param_2)
        else:
            bruch_1 = Fraction(bruch_str=param_3)
        if str(bruch_1) != expectedResult:
            testsFailed += 1
            print(f"\nError: Testcase {testsPerformed}")
            if param_3 is None:
                print(f"==> Fraction(zaehler={param_1}, nenner={param_2}) = '{str(bruch_1)}'      Expected:'{expectedResult}'")
            else:
                print(f"==> Fraction(bruch_str='{param_3}') = {str(bruch_1)}      Expected:{expectedResult}")
    if verbal:
        print("\n1) ctr Tests")
        print("------------")
        print(f"     Test performed: {testsPerformed}")
        print(f"     Test failed   : {testsFailed}")
        print(f"     Passed        : {round(100-(100 * testsFailed / testsPerformed),1)}%")
        print("\n")

def TEST_setter_getter_properties(verbal=False):
    error_count = 0
    test_count = 0

    bruch = Fraction()
    bruch.set_zaehler(1)
    bruch.set_nenner(2)
    expected = "[1/2]"
    test_count += 1
    if str(bruch) != expected:
        print("2." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction()
    bruch.zaehler = 7
    bruch.nenner = 8
    expected = "[7/8]"
    test_count += 1
    if str(bruch) != expected:
        print("2." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    if verbal:
        print("2) Test Setter / Getter and Properties")
        print("--------------------------------------")
        print(f"     Test performed: {test_count}")
        print(f"     Test failed   : {error_count}")
        print(f"     Passed        : {round(100-(100 * error_count / test_count),1)}%")
        print("\n")

def TEST_reciprocal_to_decimal_shorten_expand(verbal=False):
    error_count = 0
    test_count = 0

    # reciprocal
    bruch = Fraction(7, 8)
    bruch.reciprocal()
    expected = "[8/7]"
    test_count += 1
    if str(bruch) != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1

    bruch = Fraction(3, 4)
    bruch.reciprocal()
    expected = "[4/3]"
    test_count += 1
    if str(bruch) != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch)
        error_count += 1


    # to_decimal
    bruch = Fraction(1, 8)
    actual = bruch.to_decimal(3)
    expected = 0.125
    test_count += 1
    if actual != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + str(expected) + "    Actual:" + str(actual))
        error_count += 1

    bruch = Fraction(1, 3)
    actual = bruch.to_decimal(2)
    expected = 0.33
    test_count += 1
    if actual != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + str(expected) + "    Actual:" + str(actual))
        error_count += 1

    # shorten
    bruch = Fraction(2, 8)
    actual = bruch.shorten(2)
    expected = "[1/4]"
    test_count += 1
    if str(bruch) != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + str(expected) + "    Actual:" + str(actual))
        error_count += 1

    # expand
    bruch = Fraction(2, 8)
    actual = bruch.expand(2)
    expected = "[4/16]"
    test_count += 1
    if str(bruch) != expected:
        print("3." + str(test_count) + ") ERROR:: Expected: " + str(expected) + "    Actual:" + str(actual))
        error_count += 1


    if verbal:
        print("3) Test methode: reciprocal, to_decimal, shorten,  expand")
        print("---------------------------------------------------------")
        print(f"     Test performed: {test_count}")
        print(f"     Test failed   : {error_count}")
        print(f"     Passed        : {round(100-(100 * error_count / test_count),1)}%")
        print("\n")

def TEST_mul_div_add_sub(verbal=False):
    error_count = 0
    test_count = 0

    bruch = Fraction(7, 8)
    bruch_1 = Fraction(7, 8)
    bruch_2 = bruch.mul(bruch_1)
    expected = "[49/64]"
    test_count += 1
    if str(bruch_2) != expected:
        print(f"4.{test_count}) ERROR:: Expected: {expected}   Actual:{bruch}")
        error_count += 1

    bruch = Fraction(7, 8)
    bruch_1 = Fraction(1, 2)
    bruch_2 = bruch.mul(bruch_1)
    expected = "[7/16]"
    test_count += 1
    if str(bruch_2) != expected:
        print(f"4.{test_count}) ERROR:: Expected: {expected}   Actual:{bruch_2}")
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 4)
    bruch_2 = bruch.div(bruch_1)
    expected = "[4/6]"
    test_count += 1
    if str(bruch_2) != expected:
        print(f"4.{test_count}) ERROR:: Expected: {expected}   Actual:{bruch_2}")
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 4)
    bruch_2= bruch.add(bruch_1)
    expected = "[10/8]"
    test_count += 1
    if str(bruch_2) != expected:
        print(f"4.{test_count}) ERROR:: Expected: {expected}   Actual:{bruch_2}")
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 8)
    bruch_2 = bruch.sub(bruch_1)
    expected = "[2/16]"
    test_count += 1
    if str(bruch_2) != expected:
        print(f"4.{test_count}) ERROR:: Expected: {expected}   Actual:{bruch_2}")
        error_count += 1

    if verbal:
        print("4) Test method: mul, div, add, sub")
        print("----------------------------------")
        print(f"     Test performed: {test_count}")
        print(f"     Test failed   : {error_count}")
        print(f"     Passed        : {round(100-(100 * error_count / test_count),1)}%")
        print("\n")

def TEST_mul_div_add_sub_operators(verbal=False):
    error_count = 0
    test_count = 0

    bruch = Fraction(7, 8)
    bruch_1 = Fraction(7, 8)
    bruch_resultat = bruch * bruch_1
    expected = "[49/64]"
    test_count += 1
    if str(bruch_resultat) != expected:
        print("5." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch_resultat)
        error_count += 1

    bruch = Fraction(7, 8)
    bruch_1 = Fraction(1, 2)
    bruch_resultat = bruch * bruch_1
    expected = "[7/16]"
    test_count += 1
    if str(bruch_resultat) != expected:
        print("5." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch_resultat)
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 4)
    bruch_resultat = bruch / bruch_1
    expected = "[4/6]"
    test_count += 1
    if str(bruch_resultat) != expected:
        print("5." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch_resultat)
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 4)
    bruch_resultat = bruch + bruch_1
    expected = "[10/8]"
    test_count += 1
    if str(bruch_resultat) != expected:
        print("5." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch_resultat)
        error_count += 1

    bruch = Fraction(1, 2)
    bruch_1 = Fraction(3, 8)
    bruch_resultat = bruch - bruch_1
    expected = "[2/16]"
    test_count += 1
    if str(bruch_resultat) != expected:
        print("5." + str(test_count) + ") ERROR:: Expected: " + expected + "    Actual:", bruch_resultat)
        error_count += 1


    if verbal:
        print("5) Test method: mul, div, add, sub Operators")
        print("--------------------------------------------")
        print(f"     Test performed: {test_count}")
        print(f"     Test failed   : {error_count}")
        print(f"     Passed        : {round(100-(100 * error_count / test_count),1)}%")
        print("\n")

if __name__ == '__main__':
    lcm = math.lcm(30, 60, 90)
    gcd = math.gcd(45, 15, 30)
    print('lcm(30, 90, 60):', lcm)
    print('gcd(45, 15, 30):', gcd)
    TEST_SIMPLE_init_str(verbal=True)
    TEST_setter_getter_properties(verbal=True)
    TEST_reciprocal_to_decimal_shorten_expand(verbal=True)
    TEST_mul_div_add_sub(verbal=True)
    TEST_mul_div_add_sub_operators(verbal=True)
