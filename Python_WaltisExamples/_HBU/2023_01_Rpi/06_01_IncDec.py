#!/usr/bin/python

# ------------------------------------------------------------------
# Name  : 06_01_IncDec.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2023_01_Rpi/06_01_IncDec.py
#
# Description: Classe eines inc/decrementers
#
# Autor: Walter Rothlin
#
# History:
# 02-Oct-2023   Walter Rothlin     Initial version
# 30-Sep-2026   Walter Rothlin     Initial version for HFU 2026
# ------------------------------------------------------------------

class IncDec:
    '''
        Klassenbeschreibung .....
    '''
    object_counter = 0  # Class Variable (static)

    def __init__(self, init_value=0, step=1, min=None, max=None, obj_name='Unknown'):  # methode
        '''
          Beschreibung von __init__()
          weitere Informationen
        '''

        # print(f"__init__(self, init_value={init_value})")
        self.__counter = init_value
        self.__step = step
        self.__min = min
        self.__max = max
        self.__name = obj_name

        if self.__max is not None and self.__counter > self.__max:
            self.__counter = self.__max
        if self.__min is not None and self.__counter < self.__min:
            self.__counter = self.__min

        IncDec.object_counter += 1

    # Business-Methods
    # ----------------
    def increment(self):
        self.__counter += self.__step
        if self.__max is not None and self.__counter > self.__max:
            self.__counter = self.__max

    def decrement(self):
        self.__counter -= self.__step
        if self.__min is not None and self.__counter < self.__min:
            self.__counter = self.__min

    # Operator overloading
    # --------------------
    def __str__(self):
        return self.__to_string()

    def __ne__(self, other):  # !=
        return self.get_counter() != other.get_counter()

    def __eq__(self, other):  # ==
        return self.__counter == other.__counter

    # private methods
    # ---------------
    def __to_string(self):
        return f'{self.__name}: [{self.__min} .. {self.__counter} .. {self.__max}]  ==> step:{self.__step}'

    # setter / getter methods
    # -----------------------
    def get_counter(self):
        return self.__counter

    def set_counter(self, init_value):
        self.__counter = init_value

    def get_step(self):
        return self.__step

    def set_step(self, step_value):
        self.__step = step_value


# ===============================
# Hauptprogramm / Test der Klasse
# ===============================
if __name__ == '__main__':
    print(f'IncDec.__doc__:{IncDec.__doc__}')
    print(f'IncDec.__init__.__doc__:{IncDec.__init__.__doc__}')
    print(f'IncDec.object_counter:{IncDec.object_counter}')

    speed = IncDec(step=15, min=10, max=50, obj_name='speed')
    print(f'IncDec.object_counter:{IncDec.object_counter}')
    print(speed)
    for i in range(5):
        speed.increment()
        print(speed)

    for i in range(5):
        speed.decrement()
        print(speed)

    distance = IncDec(init_value=100, obj_name='distance')
    print(f'IncDec.object_counter:{IncDec.object_counter}')
    print(f'distance.object_counter:{distance.object_counter}')
    distance.decrement()

    print(speed)
    print(distance)

    if speed == distance:
        print('speed == distance  ==> True')
    else:
        print('speed == distance  ==> False')

    distance_1 = distance
    distance.decrement()
    print(f'distance_1:{distance_1}')
    print(f'distance  :{distance}')

    if distance_1 == distance:
        print('distance_1 == distance  ==> True')
    else:
        print('distance_1 == distance  ==> False')

    speed_01 = IncDec(step=0, min=10, max=500, obj_name='speed_01')
    speed_02 = IncDec(step=15, min=11, max=50, obj_name='speed_02')
    if speed_01 == speed_02:
        print(speed_01, 'is gleich', speed_02)
    else:
        print(speed_01, 'is nicht gleich', speed_02)




    speed = IncDec(obj_name='Speed', init_value=6, step=3, min=0, max=10)

    print(speed)
    speed.increment()
    print(speed)
    speed.increment()
    print(speed)
    speed.increment()
    print(speed)
    speed.increment()
    print(speed)
    speed.increment()
    print(speed)
    speed.increment()
    print(speed)
    speed.decrement()
    print(speed)
    speed.decrement()
    print(speed)
    speed.decrement()
    print(speed)
    speed.decrement()
    print(speed)
    speed.decrement()
    print(speed)

    
    print('\n\n')
    distance = IncDec(step=7)
    print(distance)
    distance.set_counter(5)
    print(distance)
    distance.increment()
    print(distance)
    print(speed)
    
    
    print('\n\n')
    speed_1    = IncDec(obj_name='Speed', init_value=6, step=3, min=0, max=10)
    speed_1.increment()
    expected_res = IncDec(obj_name='Expec', init_value=5, step=1, min=-10, max=10)
    if speed_1 == expected_res:
        print('speed_1 == expected_res')
    else:
        print('speed_1 != expected_res')
    
    speed_2 = speed_1    
    if speed_1 == speed_2:
        print('speed_1 == speed_2')
    else:
        print('speed_1 != speed_2')
    
    # automated test
    if speed_1.get_counter() != expected_res.get_counter():
        print('ERROR: Test 1 failed')
        print('    ', speed_1)
        print('    ', expected_res)
    else:
        print('Testcase 1 went ok!')
        
    if speed_1 != expected_res:
        print('ERROR: Test 2 failed')
        print('    ', speed_1)
        print('    ', expected_res)
    else:
        print('Testcase 2 went ok!')
    

    