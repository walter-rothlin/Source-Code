#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Fraction.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_05_DataLogger/WeatherLogger_05.py
#
# Description: Logs weather data received from a REST-Service (JSON)
#
# Autor: Walter Rothlin
#
# History:
# 03-Dec-2020   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import math

class Fraction:
    def __init__(self, numerator=0, denominator=1, bruch_str=None):
        if bruch_str is not None:
            parts = bruch_str.replace(' ', '').replace('[', '').replace(']', '').split('/')
            numerator = int(parts[0])
            denominator = int(parts[1])
        self.__numerator = int(numerator)
        self.__denominator = int(denominator)

    def __str__(self):
        return f"[{self.__numerator}/{self.__denominator}]"

    def shorten(self):
        gcd = math.gcd(self.__numerator, self.__denominator)
        return Fraction(self.__numerator // gcd, self.__denominator // gcd)

    def multiplication(self, other_fraction):
        new_numerator = self.__numerator * other_fraction.__numerator
        new_denominator = self.__denominator * other_fraction.__denominator
        return Fraction(new_numerator, new_denominator)

    def __mul__(self, other):
        return self.multiplication(other)

    def __eq__(self, other):
        print('in __eq__')
        return (self.__numerator == other.__numerator) and (self.__denominator == other.__denominator)

    def __ne__(self, other):
        print('in __ne__')
        # return (self.__numerator != other.__numerator) or (self.__denominator != other.__denominator)
        return not self.__eq__(other)

    def __clean_integer(n):
        if isinstance(n, int):
            return n
        elif isinstance(n, float):
            return int(n)
        elif isinstance(n, str):
            return int(n.replacer(' ', '').replace("'", ''))
        else:
            raise ValueError("Input must be an integer or a float.")

    @property
    def decimal_value(self):
        return self.__numerator / self.__denominator

    @decimal_value.setter
    def decimal_value(self, new_decimal_value):
        dec_val_str = str(new_decimal_value)
        exponent_str = dec_val_str.split('.')[1] if '.' in dec_val_str else 0
        exponent = len(exponent_str) if exponent_str else 0
        print(f'Decimal value: {new_decimal_value}, Exponent: {exponent}')
        self.__numerator = int(new_decimal_value * 10**exponent)
        self.__denominator = 10**exponent


    def primfaktoren_self(self, n):
        n = Fraction.__clean_integer(n)
        return Fraction.primfaktoren(n)

    def primfaktoren(n):
        n = Fraction.__clean_integer(n)
        faktoren = []

        while n % 2 == 0:
            faktoren.append(2)
            n //= 2
        teiler = 3
        while teiler * teiler <= n:
            while n % teiler == 0:
                faktoren.append(teiler)
                n //= teiler
            teiler += 2
        if n > 1:
            faktoren.append(n)
        return faktoren


    def is_prime(n):
        n = Fraction.__clean_integer(n)
        return Fraction.primfaktoren(n) == [n]

    def next_primefactor(n):
        n = Fraction.__clean_integer(n)
        n += 1
        while not Fraction.is_prime(n):
            n += 1
        return n

    def previous_primefactor(n):
        n = Fraction.__clean_integer(n)
        n -= 1
        while not Fraction.is_prime(n):
            n -= 1
        return n

    def get_primefactors(min, max=None):
        min = Fraction.__clean_integer(min)
        if max is None:
            max = min
            min = 2
        else:
            max = Fraction.__clean_integer(max)
            if min > max:
                min, max = max, min

        primefactors = []
        for i in range(min, max + 1):
            if Fraction.is_prime(i):
                primefactors.append(i)
        return primefactors

    def teiler(n):
        n = Fraction.__clean_integer(n)
        if n <= 0:
            raise ValueError("n muss größer als 0 sein")

        ergebnis = []

        i = 1
        while i * i <= n:
            if n % i == 0:
                ergebnis.append(i)

                if i != n // i:  # Doppelten Teiler bei Quadratzahlen vermeiden
                    ergebnis.append(n // i)

            i += 1

        return sorted(ergebnis)

if __name__ == "__main__":
    print(Fraction.primfaktoren(60), f'Expected:[2, 2, 3, 5]')
    print(Fraction.primfaktoren(61), f'Expected:[61]')
    print(Fraction.next_primefactor(60), f'Expected:[61]')
    print(Fraction.next_primefactor(61), f'Expected:[67]')
    print(Fraction.previous_primefactor(61), f'Expected:[59]')

    print(f'Fraction.teiler(36) = {Fraction.teiler(36)} Expected : [1, 2, 3, 4, 6, 9, 12, 18, 36]')

    print(f'INFO : 60 is prime: {Fraction.is_prime(60)} Expected : False')
    print(f'INFO : 61 is prime: {Fraction.is_prime(61)} Expected : True')
    print(f'INFO : primefactors from 2 to 20: {Fraction.get_primefactors(2, 20)} Expected : [2, 3, 5, 7, 11, 13, 17, 19]')

    fraction_1a = Fraction(2, 4)
    print(f'decimal-value from {fraction_1a} = {fraction_1a.decimal_value}  Expected:0.5')
    fraction_1a.decimal_value = 1.567
    print(f'new value from {fraction_1a} ')

    print(fraction_1a.primfaktoren_self(60))  # Output: [2, 2, 3, 5]

    fraction_1 = Fraction(bruch_str="2/4")
    fraction_2 = Fraction(1, 2)
    fraction_expected = Fraction(2, 8)
    fraction_result = fraction_1 * fraction_2

    fraction_expected_1 = Fraction(1, 4)
    fraction_result_1 = fraction_expected.shorten()

    print(f'{fraction_1} * {fraction_2} = {fraction_result}')
    if fraction_result != fraction_expected:
        print("Test failed!")
        print(f'ERROR: {fraction_1} * {fraction_2} = {fraction_result}    Expected: {fraction_expected}')
    else:
        print("Test passed!")

    if  fraction_result_1 != fraction_expected_1:
        print("Test failed!")
        print(f'ERROR: shorten{fraction_expected} = {fraction_result_1}    Expected: {fraction_expected_1}')
    else:
        print("Test passed!")
        print(f'INFO : shorten{fraction_expected} = {fraction_result_1}    Expected: {fraction_expected_1}')

