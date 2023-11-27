#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_Fraction.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/Fraction/Class_Fraction_40.py
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
#
# ------------------------------------------------------------------
from waltisLibrary import *


class Fraction:
    """
    Provides basic support for math operations with fractions
    """

    # setter / getters and properties
    # -------------------------------
    def set_zaehler(self, zaehler_param):
        if zaehler_param is None:
            self.__zaehler = 1
        elif isinstance(zaehler_param, int):
            self.__zaehler = zaehler_param
        else:
            try:
                self.__zaehler = int(zaehler_param)
            except Exception:
                self.__zaehler = 0

        # elif re.fullmatch(r'[+-]?\d', zaehler_param):
        #     self.__zaehler = int(zaehler_param)
        # else:

    def get_zaehler(self):
        return self.__zaehler

    zaehler = property(get_zaehler, set_zaehler)

    def set_nenner(self, nenner_param):
        if nenner_param is None:
            self.__nenner = 1
        elif isinstance(nenner_param, int):
            self.__nenner = nenner_param
        else:
            try:
                self.__nenner = int(nenner_param)
            except Exception:
                self.__nenner = 1

    def get_nenner(self):
        return self.__nenner

    nenner = property(get_nenner, set_nenner)

    def __init__(self, zaehler=0, nenner=1, bruch=None, bruch_str=None):
        """
        - Check if nenner is not 0
        - only one sign
        - only Integers no floats nor string,....
        """
        if bruch is not None:
            zaehler = bruch.zaehler
            nenner  = bruch.nenner
        elif bruch_str is not None:
            parts = bruch_str.strip('[]').replace(':', '/').split('/')
            if len(parts) == 1:
                zaehler = parts[0]
            elif len(parts) == 2:
                zaehler = parts[0]
                nenner  = parts[1]

        self.zaehler = zaehler
        self.nenner = nenner

        if self.zaehler < 0 and self.nenner < 0:
            self.zaehler = abs(self.zaehler)
            self.nenner = abs(self.nenner)
        elif self.zaehler < 0 or self.nenner < 0:
            self.zaehler = -abs(self.zaehler)
            self.nenner = abs(self.nenner)

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
            divisor = 1
        self.__zaehler = int(self.__zaehler / divisor)
        self.__nenner = int(self.__nenner / divisor)
        return self

    def expand(self, factor=None):
        """
        - erweitert self [2/4] mit 2 ==> [4/8]
        """
        if factor is None:
            factor = 1
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

    # self (Grundoperationen)
    # -----------------------
    def __isub__(self, other):  # -=
        return self

    def __iadd__(self, other):  # +=
        return self

    def __imul__(self, other):  # *=
        return self

    def __idiv__(self, other):  # /=
        return self


# static test methods
def AUTO_TEST_init_str(verbal=False):
    # Test Ctr and toString()
    test_suite = 'initializer'
    tests_performed = 0
    tests_failed = 0
    test_cases = """
        Nr|Type|Zaehler |Nenner |Bruch     |Bruch_Str |Expected
        # Ctr fraction by Nenner und Zähler
        01|Ctr |1       |2      |          |          |[1/2]
        02|Ctr |3       |4      |          |          |[3/4]
        03|Ctr |6       |7      |          |          |[6/7]
        04|Ctr |1       |4      |          |          |[1/4]
        05|Ctr |2       |7      |          |          |[2/7]
        06|Ctr |55      |72     |          |          |[55/72]
        07|Ctr |23      |       |          |          |[23/1]

        # Negative Nenner und/oder Zähler
        10|Ctr |-5      |40     |          |          |[-5/40]
        11|Ctr |5       |-40    |          |          |[-5/40]
        12|Ctr |-5      |-40    |          |          |[5/40]
        13|Ctr |-10     |2      |          |          |[-10/2]
        14|Ctr |88      |-40    |          |          |[-88/40]

        # Bruch_Str (Ctr fraction by a string)
        20|Ctr |        |       |          | [7/40]   |[7/40]
        21|Ctr |        |       |          | [-6]     |[-6/1]
        22|Ctr |        |       |          | [-7/40]  |[-7/40]
        23|Ctr |        |       |          | [-7:40]  |[-7/40]
        24|Ctr |        |       |          | -7/40    |[-7/40]
        25|Ctr |        |       |          | -7:40    |[-7/40]

        # Clone a fraction (Ctr fraction by another fraction)
        30|Ctr |        |       |[7/40]    |          |[7/40]
        31|Ctr |        |       |[-3/4]    |          |[-3/4]
        32|Ctr |        |       |[-7/40]   |          |[-7/40]
        33|Ctr |        |       |[-7:40]   |          |[-7/40]
        34|Ctr |        |       |-7/40     |          |[-7/40]
        35|Ctr |        |       |-7:40     |          |[-7/40]

        # Negativ Tests
        50|Ctr |34      |Hallo  |          |          |[34/1]
        51|Ctr |Hallo   |45     |          |          |[0/45]
        52|Ctr |Hallo   |Hallo  |          |          |[0/1]
    """

    if verbal:
        print("")
        print(unterstreichen(f"Testsuite: {test_suite}", aChar='='))

    list_of_test_cases = test_cases.split("\n")
    for a_test_case in list_of_test_cases[2:-1]:
        if a_test_case.strip() == "":
            continue

        if a_test_case.strip().startswith('#'):
            if verbal:
                sub_title = unterstreichen(a_test_case.strip(), aChar='-')
            continue

        # Prepare Test
        tests_performed += 1
        list_of_test_values = a_test_case.split("|")
        test_case = list_of_test_values[0].strip()

        param_1 = list_of_test_values[2].strip()
        param_1 = param_1 if param_1 != "" else None

        param_2 = list_of_test_values[3].strip()
        param_2 = param_2 if param_2 != "" else None

        param_3 = list_of_test_values[4].strip()
        param_3 = None if param_3 == "" else param_3

        param_4 = list_of_test_values[5].strip()
        param_4 = None if param_4 == "" else param_4

        expected_result = list_of_test_values[6].strip()

        # Perform Test
        if param_3 is not None:
            bruch_x = Fraction(bruch_str=param_3)
            bruch_1 = Fraction(bruch=bruch_x)
        elif param_4 is not None:
            bruch_1 = Fraction(bruch_str=param_4)
        else:
            bruch_1 = Fraction(zaehler=param_1, nenner=param_2)

        # Compare Test-Result with expectation
        if str(bruch_1) != expected_result:
            tests_failed += 1
            # print(f"{test_case} ({test_suite}) failed!!")
            print(sub_title)
            print(list_of_test_cases[1].strip())
            print(a_test_case.strip())

            if param_3 is not None:
                print(f"  ==> Fraction(bruch={param_3}) = {bruch_1}")
            elif param_4 is not None:
                print(f"  ==> Fraction(bruch_str='{param_4}') = {bruch_1}")
            else:
                print(f"  ==> Fraction(zaehler={param_1}, nenner={param_2}) = {bruch_1}")
            print(f"      Result  :'{bruch_1}'")
            print(f"      Expected:'{expected_result}'")
            print()

    if verbal:
        print("\n")
        print(f"     Test performed: {tests_performed}")
        print(f"     Test failed   : {tests_failed}")
        print(f"     Passed        : {round(100 - (100 * tests_failed / tests_performed), 1)}%")
        print("\n")


def AUTO_TEST_compareable(verbal=False):
    # Test Ctr and toString()
    test_suite = 'comparable'
    tests_performed = 0
    tests_failed = 0
    test_cases = """
    Nr|Type    |Fraction_1 |Compareable|Fraction_2 |Expected
    01|Compare |[1/2]      |==         |[1/2]      |True

    """


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
        print(f"     Passed        : {round(100 - (100 * error_count / test_count), 1)}%")
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
        print(f"     Passed        : {round(100 - (100 * error_count / test_count), 1)}%")
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
    bruch_2 = bruch.add(bruch_1)
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
        print(f"     Passed        : {round(100 - (100 * error_count / test_count), 1)}%")
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
        print(f"     Passed        : {round(100 - (100 * error_count / test_count), 1)}%")
        print("\n")


if __name__ == '__main__':
    # lcm = math.lcm(30, 60, 90)
    # gcd = math.gcd(45, 15, 30)
    # print('lcm(30, 90, 60):', lcm)
    # print('gcd(45, 15, 30):', gcd)
    AUTO_TEST_init_str(verbal=True)
    # AUTO_TEST_compareable(verbal=True)
    # TEST_setter_getter_properties(verbal=True)
    # TEST_reciprocal_to_decimal_shorten_expand(verbal=True)
    # TEST_mul_div_add_sub(verbal=True)
    # TEST_mul_div_add_sub_operators(verbal=True)
