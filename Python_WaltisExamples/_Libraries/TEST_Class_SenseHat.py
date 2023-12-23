#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Class_SenseHat.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_Libraries/TEST_Class_SenseHat.py
#
# Description: Tests for Sub-Class of SenseHat
#
# Autor: Walter Rothlin
#
# History:
# 23-Dec-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from waltisLibrary import *
from time import sleep
from Class_SenseHat import MySenseHat



# =============================
# Functions to Test the Class #
# =============================
def AUTO_TEST_SubClass_Sense_Hat(sense, test_cases=None, verbal=False):
    testsPerformed = 0
    testsFailed = 0

    test_suite = 'TEST_SubClass_Sense_Hat'  # getMyFctName()[auto_test_fct_prefix_len:]

    if test_cases is None:
        test_cases = '''
        Nr    |Fct                |x1     |y1    |x2     |y2    |time |r  |g  |b  |Manual|Expected
              |clear              |       |      |       |      |     |   |   |   |      |
             1|set_pixel          |0      |0     |       |      |     |  0|  0|255|True  |set_pixel(0, 0)
             2|set_pixel          |5.1    |6.2   |       |      |     |  0|255|  0|True  |set_pixel(5.1, 6.2)
             3|set_pixel          |'6.1'  |'7.2' |       |      |     |255|255|  0|True  |set_pixel('6.1', '7.2')
             4|set_pixel          |'Hallo'|5     |       |      |     |255|  0|  0|True  |set_pixel('Hallo', 5) Wrong Parameter Type
             5|set_pixel          |8      |5     |       |      |     |255|  0|  0|True  |set_pixel(8, 5) Out of Range
             6|set_pixel          |4      |5     |       |      |     |255|255|  0|True  |set_pixel(4, 5)

              |clear              |2      |      |       |      |     |   |   |   |True  |
            10|draw_line          |0      |0     |7      |7     |0.3  |255|  0|  0|True  |draw_line(0, 0, 7, 7, 255,0,0)  Diagonale
            11|draw_line          |0      |7     |7      |0     |0.3  |255|  0|  0|True  |draw_line(0, 7, 7, 0, 255,0,0)  Diagonale
              |clear              |2      |3     |       |      |     |   |   |   |      |
            12|draw_line          |7      |7     |0      |0     |0.2  |255|  0|255|True  |draw_line(7, 7, 0, 0, 255,0,255)  Diagonale
            13|draw_line          |7      |0     |0      |7     |0.2  |255|  0|255|True  |draw_line(7, 0, 0, 7, 255,0,255)  Diagonale

              |clear              |2      |      |       |      |     |   |   |   |      |
            20|draw_line          |0      |0     |7      |0     |     |255|255|  0|True  |draw_line(0, 0, 7, 0, 255,255,0)   Border
            21|draw_line          |0      |7     |7      |7     |     |255|255|  0|True  |draw_line(0, 7, 7, 7, 255,255,0)   Border
            22|draw_line          |0      |0     |0      |7     |     |  0|255|255|True  |draw_line(0, 0, 0, 7, 255,255,0)   Border
            23|draw_line          |7      |0     |7      |7     |     |0  |255|255|True  |draw_line(7, 0, 7, 7, 255,255,0)   Border

              |clear              |2      |      |       |      |     |   |   |   |      |
            30|draw_line          |0      |0     |1      |7     |     |255|  0|  0|True  |draw_line(0, 0, 1, 7, 255,0,0)    Fast vertikale Linie
            31|draw_line          |0      |3     |7      |2     |     |255|255|  0|True  |draw_line(0, 3, 7, 2, 255,255,0)  Fast horizontale Linie
            32|draw_line          |-1.6   |-1.5  |9.1    |10.5  |     |0  |0  |255|True  |draw_line(-1.6, -1.5, 9.1, 10.5, 0,0,255)   

              |clear              |5       |     |       |      |     |   |   |   |      |
            '''

    print(unterstreichen('Test-Protokoll: ' + test_suite, '='))
    listOfTestCases = test_cases.split("\n")
    for aTestCase in listOfTestCases[2:-1]:
        if aTestCase.strip() == '' or aTestCase.startswith('#'):
            continue

        listOfTestValues = aTestCase.split("|")
        case = listOfTestValues[0].strip()
        fct = listOfTestValues[1].strip()
        x1 = convert_str_to_int_float_str(listOfTestValues[2].strip(), default=0)
        y1 = convert_str_to_int_float_str(listOfTestValues[3].strip(), default=0)
        x2 = convert_str_to_int_float_str(listOfTestValues[4].strip(), default=0)
        y2 = convert_str_to_int_float_str(listOfTestValues[5].strip(), default=0)
        delay_time = convert_str_to_int_float_str(listOfTestValues[6].strip(), default=0)
        r = convert_str_to_int_float_str(listOfTestValues[7].strip(), default=0)
        g = convert_str_to_int_float_str(listOfTestValues[8].strip(), default=0)
        b = convert_str_to_int_float_str(listOfTestValues[9].strip(), default=0)

        is_manual_test = convert_str_to_int_float_str(listOfTestValues[10].strip(), default=False)
        # print(f'is_manual_test: {is_manual_test} {type(is_manual_test)}')

        expectedResult = listOfTestValues[11].strip()

        if fct == 'clear':
            # testsPerformed += 1
            if False:
                print(f'\n\nTest:{case}::{fct}({x1}, {y1}))\n           ==> {expectedResult}')
            if isinstance(x1, int) or isinstance(x1, float):
                sleep(x1)
            sense.clear()
            if isinstance(y1, int) or isinstance(y1, float):
                sleep(y1)

        if fct == 'set_pixel':
            testsPerformed += 1
            if verbal or is_manual_test:
                print(f'\n\nTest:{case}::{fct}({x1} {type(x1)}, {y1} {type(y1)}, {r}, {g}, {b})\n          ==> {expectedResult}')
            try:
                sense.set_pixel(x1, y1, r, g, b)
            except Exception as e:
                try:
                    sense.set_pixel(x1, y1, (r, g, b))
                except Exception as e:
                    try:
                        sense.set_pixel(x1, y1)
                    except Exception as e:
                        print(f'ERROR: {listOfTestCases[1]}')
                        print(f'     : {aTestCase}')
                        print(f'     : {e}')
                        # testsFailed += 1
            if is_manual_test:
                ant = input('Check LED-Matrix. Ok? (Y/N):').upper()[0]
                # print(f'ant:{ant}  {type(ant)}')
                if ant == 'N' or ant == '0':
                    testsFailed += 1

        if fct == 'draw_line':
            testsPerformed += 1
            if verbal or is_manual_test:
                print(f'\n\nTest:{case}::{fct}({x1} {type(x1)}, {y1} {type(y1)}, {x2} {type(x2)}, {y2} {type(y2)}, {r}, {g}, {b})\n          ==> {expectedResult}')
            try:
                # print('Call 0...')
                sense.draw_line(x1, y1, x2, y2, r, g, b)
            except Exception as e:
                try:
                    # print('Call 1...')
                    sense.draw_line(x1, y1, x2, y2, r, g, b, draw_speed=delay_time)
                except Exception as e:
                    try:
                        # print('Call 2...')
                        sense.draw_line(x1, y1, x2, y2, (r, g, b))
                    except Exception as e:
                        try:
                            # print('Call 3...')
                            sense.draw_line(x1, y1, x2, y2)
                        except Exception as e:
                            print(f'ERROR: {listOfTestCases[1]}')
                            print(f'     : {aTestCase}')
                            print(f'     : {e}')
                            # testsFailed += 1
            if is_manual_test:
                ant = input('Check LED-Matrix. Ok? (Y/N):').upper()[0]
                # print(f'ant:{ant}  {type(ant)}')
                if ant == 'N' or ant == '0':
                    testsFailed += 1

    if verbal:
        print(f'Test performed: {testsPerformed} Failed: {testsFailed}')
    return {'test_name': test_suite, 'tests_performed': testsPerformed, 'tests_failed': testsFailed}


if __name__ == '__main__':
    sense = MySenseHat()
    AUTO_TEST_SubClass_Sense_Hat(sense, verbal=True)
