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
# 04-Dec-2023   Walter Rothlin  Perform Test in try-except block
#
# ------------------------------------------------------------------
def generateStringRepeats(len, aStr=" "):
    return (aStr * len)[:len]

def unterstreichen(title, aChar="=", end="\n"):
    return title + end + generateStringRepeats(len(title), aChar)

class Fraction:
    """
    Provides basic support for math operations with fractions
    """

    def __init__(self, zaehler=0, nenner=1, bruch=None, bruch_str=None):
        """
        Initialisiert ein Fraction-Objekt. Unterstützt die Initialisierung durch
        Zähler und Nenner, ein anderes Fraction-Objekt oder einen Bruch-String.
        """
        if bruch is not None:
            pass
        elif bruch_str is not None:
            pass
        else:
            self.__zaehler = zaehler
            self.__nenner = nenner

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

# =================
# Automated Testing
# =================

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
        try:
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
        except Exception as e:
            tests_failed += 1
            print(sub_title)
            print(list_of_test_cases[1].strip())
            print(a_test_case.strip())
            print(f'   ==> ERROR:{e}')
            print()

    if verbal:
        percent = round(100-(100 * tests_failed / tests_performed),1)
        print("\n")
        print(f"     Test performed: {tests_performed}")
        print(f"     Test failed   : {tests_failed}")
        print(f"     Passed        : {percent}%     Teilnote: {(percent/20) + 1:1.1f} ")
        print("\n")


if __name__ == '__main__':
    AUTO_TEST_init_str(verbal=True)

