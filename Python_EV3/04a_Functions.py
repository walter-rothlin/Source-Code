# Python_EV3: 04a_Functions.py

from grobot import *

def warnBlink():
    setLED(1)
    delay(500)
    setLED(0)
    delay(500)


forward()
delay(2000)
stop()
warnBlink()
backward()
warnBlink()
delay(2000)
left(550)












