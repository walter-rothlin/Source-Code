# Python_EV3: 04a_Functions.py

from grobot import *

'''
LED Farben: 
    0: aus,
    1: rot,
    2: grün,
    3: orange,
    4: grün blinkend,
    5: rot blinkend,
    6: rot blinkend hell,
    7: grün doppelblinkend,
    8: rot doppelblinkend,
    9: rot doppelblinkend hell
'''
def warnBlink(farbeOn=1, timeOn=500, farbeOff=0, timeOff=500):
    setLED(farbeOn)
    delay(timeOn)
    setLED(farbeOff)
    delay(timeOff)


forward()
delay(2000)
stop()
warnBlink()   # Rot
backward()
warnBlink(2, 300, 1, 600)  # Gruen / Rot
warnBlink(2, 300)          # Gruen / Nichts
warnBlink(timeOff=1000, farbeOff=2)
delay(2000)
left(550)












