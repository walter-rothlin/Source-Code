# Python_EV3: 01_EinfacheBewegungen.py

from grobot import *

forward()
delay(4000)
backward()
setLED(1)
delay(3000)
setLED(2)
delay(1000)
setLED(0)

leftArc(0.2)
delay(5000)
rightArc(0.2)
delay(5000)

motL.rotate(50)
delay(3000)
motL.rotate(-30)
delay(3000)
motL.rotate(0)

stop()