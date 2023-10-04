#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 06_01_IncDec.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_PY1/06_01_IncDec.py
#
# Description: Inc- / Decrement-Class
#
# Autor: Walter Rothlin
#
# History:
# 04-Oct-2023   Walter Rothlin      Initial Version
# ----------------------------------------------------------------

class IncDec:
    """
    Inc or Dec in a given Intervall. If an over- resp under-flow happens it clips the value to the boundary

    """

    # Basic overloads
    # ---------------
    def __init__(self, init_value=0, step_up=1, step_down=None, min_value=None, max_value=None):
        # print('__init__ has been called!')
        self.__counter = init_value
        self.__step_up = step_up
        self.__step_down = step_down
        self.__min = min_value
        self.__max = max_value
        if self.__step_down is None:
            self.__step_down = self.__step_up
        if self.__min is not None and self.__counter < self.__min:
            self.__counter = self.__min
        if self.__max is not None and self.__counter > self.__max:
            self.__counter = self.__max   
    
    def __str__(self):
        return 'Counter:' + str(self.__counter) + '    ['+ str(self.__min) + '..' + str(self.__max) + ']' + '   Step_Up:' + str(self.__step_up) + '   Step_Down:' + str(self.__step_down)

    # coparable operators
    # --------------------
    def __ne__(self, other):   # !=
        return not self.__eq__(other)

    def __eq__(self, other):   # ==
        if isinstance(other, (int, float)):
            return self.get_counter() == other
        elif isinstance(other, str):
            return self.get_counter() == int(other)
        elif isinstance(other, IncDec):
            return self.get_counter() == other.get_counter()
        else:
            raise TypeError("Unsupported operand type")
    
    
    # Business-Methods
    def decrement(self, step=None):
        if step is not None:
            self.set_step_down(step)
        self.__counter -= self.__step_down
        if self.__min is not None and self.__counter < self.__min:
            self.__counter = self.__min

    def dec(self, step=None):
       self.decrement(step)

    def increment(self, step=None):
        if step is not None:
            self.set_step_up(step)
        self.__counter += self.__step_up
        if self.__max is not None and self.__counter > self.__max:
            self.__counter = self.__max

    def inc(self, step=None):
       self.increment(step)


    # setter / getter  |  Properties
    def get_counter(self):
        return self.__counter
    
    def set_step_up(self, new_step=1):
        self.__step_up = new_step
        
    def set_step_down(self, new_step=1):
        self.__step_down = new_step


if __name__ == '__main__':
    print('Automated Testing of Class: 06_01_IncDec.py')
    test_cases_processed = 0
    test_cases_failed = 0
    
    speed = IncDec()
    lenkung = IncDec(init_value=10, step_up=15, min_value=100, max_value=120)
    print('lenkung:', lenkung)
    print('speed  :', speed)
    print('Type:', str(type(speed)))
    
    
    test_cases_processed += 1
    if lenkung != IncDec(100):
        test_cases_failed += 1

        print('ERROR (1): lenkung.__counter:', lenkung.get_counter(), 'Expected:100')
    lenkung.increment()
    
    test_cases_processed += 1
    if lenkung != 115:
        test_cases_failed += 1
        print('ERROR (2): lenkung.__counter:', lenkung.get_counter(), 'Expected:115')
    
    test_cases_processed += 1
    if speed.get_counter() != 0:
        test_cases_failed += 1    
        print('ERROR (3): speed.__counter:', speed.get_counter(), 'Expected:0')
        
    speed.increment()
    
    test_cases_processed += 1
    if speed != '1':
        test_cases_failed += 1
        print('ERROR (4): speed.__counter:', speed.get_counter(), 'Expected:1')
    speed.decrement()
    speed.decrement()
    # speed.__counter += 10 # Not possible __ means private
    speed.decrement()
    
    test_cases_processed += 1
    if speed.get_counter() != -2:
        test_cases_failed += 1
        print('ERROR (5): speed.__counter:', speed.get_counter(), 'Expected:-2')
    
    test_cases_processed += 1
    if lenkung.get_counter() != 115:
        test_cases_failed += 1
        print('ERROR (6): lenkung.__counter:', lenkung.get_counter(), 'Expected:115')
    lenkung.set_step_up(17)
    lenkung.increment()
    lenkung.increment()
    
    test_cases_processed += 1
    if lenkung.get_counter() != 120:
        test_cases_failed += 1
        print('ERROR (7): lenkung.__counter:', lenkung.get_counter(), 'Expected:120')
    lenkung.decrement()
    lenkung.decrement()
    
    test_cases_processed += 1
    if lenkung.get_counter() != 100:
        test_cases_failed += 1
        print('ERROR (8): lenkung.__counter:', lenkung.get_counter(), 'Expected:100')
        
    print('\n')    
    print('Statistics:')
    print('Testcases executed: ', test_cases_processed)
    print('Testcases failed  : ', test_cases_failed)
