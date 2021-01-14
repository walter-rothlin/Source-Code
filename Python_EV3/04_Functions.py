# Python_EV3: 04a_Functions.py

from grobot import *

forward(2000)
stop()

# Blinken
setLED(1)
delay(500)
setLED(0)
delay(500)

backward()

# Blinken
setLED(1)
delay(500)
setLED(0)
delay(500)

delay(2000)
left(550)
