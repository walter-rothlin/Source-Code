# Python_EV3: 04c_VariablesFunctions.py

from grobot import *

delayTime_1 = 1000      # int / long / short
delayTimeLong = 4 * delayTime_1   # int operation

pi = 3.1415926          # float / double
zweiPi = 2 * pi         # float operation impliziten typen convertierung

vorname = "Otto's"      # String
nachname = 'Schlosser'  # String
adresse = """Walter Rothlin
Peterliwiese 33
8855 Wangen"""          # Multiline String

doLoop = True           # Boolean
doLoop = False

name = vorname + " " + nachname   # Otto'sSchlosser
adresse = vorname + str(pi)

count = 1
count = count + 1        # count++
count += 1               # count++
count -= 1               # count--
count += 5               # count = count + 5

unterstreichen = "="
unterstreichen += "55"   # unterstreichen "=55"
unters = "-"
unters *= 5              # "-----"
unters = "+-+"
unters *= 2              # "+-++-+"

def blinker(ledOnColor=1, ledOffColor=0, timeOn=1000, timeOff=1000, repeatCount=1, led3Color=0, time3=1000):
    ## repeat repeatCount:
    count = 0
    while count < repeatCount:
        count += 1
        setLED(ledOnColor)
        delay(timeOn)
        setLED(ledOffColor)
        delay(timeOff)
        if led3Color > 0:
            setLED(led3Color)
            delay(time3)
    
# Main
# ====
blinker()
forward(2000)
blinker(2)
blinker(2, 1, 1000, 500)
blinker(2, 1, timeOff=250)
blinker(ledOnColor=2, timeOff=250, ledOffColor=1)
