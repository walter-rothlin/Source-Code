#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 06_01_IncDec.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/_HBU/2023_Rpi/06_01_IncDec
#
# Description: Classe eines inc/decrementers
#
# Autor: Walter Rothlin
#
# History:
# 02-Oct-2023   Walter Rothlin     Initial version

# ------------------------------------------------------------------

class IncDec:
    '''
        Klassenbeschreibung .....
    '''
    object_counter = 0

    def __init__(self, init_value=0, step=1, min=None, max=None, obj_name='Unknown'):
        '''
          Beschreibung von __init__()
          weitere Informationen
        '''
        # print('__init__')
        self.__counter = init_value        
        self.__step    = step
        self.__min     = min
        self.__max     = max
        self.__name    = obj_name
        
        
        if self.__max is not None and self.__counter > self.__max:
            self.__counter = self.__max
        if self.__min is not None and self.__counter < self.__min:
            self.__counter = self.__min
            
        IncDec.object_counter += 1


    def __str__(self):
        return self.to_string()
        
        
    # Operator overloading
    def __ne__(self, other):   # != 
        return self.get_counter() != other.get_counter()
        
    def __eq__(self, other):   # == 
        return self.get_counter() == other.get_counter()
        
        
        
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

    def to_string(self):
        return str(IncDec.object_counter) + ') ' + self.__name + ':   [' + str(self.__min) + '..' + str(self.__max) + ']   step:' + str(self.__step) + '   counter:' + str(self.__counter)
        
        
    # setter / getter methods
    def get_counter(self):
        return self.__counter
        
    def set_counter(self, init_value):
        self.__counter = init_value
        
    def get_step(self):
        return self.__step
        
    def set_step(self, step_value):
        self.__step = step_value




# Hauptprogramm / Test der Klasse
if __name__ == '__main__':
    print(IncDec.__doc__)
    print(IncDec.__init__.__doc__)




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
    

    