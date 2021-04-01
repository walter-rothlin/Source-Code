
import math

pi = math.pi

def celsiusToFahrenheit(aCelsiusValue):
    return (aCelsiusValue * 1.8) + 32

def fahrenheitToCelsius(aFahrenheitValue):
    return (aFahrenheitValue - 32) / 1.8

def radToGrad(radVal):
    return radVal * 180 / pi

def gardToRad(gradVal):
    return gradVal * pi / 180

def halt(prompt = "Weiter?"):
    nop = input(prompt)
