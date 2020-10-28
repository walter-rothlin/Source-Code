# Python_EV3: Test_01_SpureZeichnen.py

from grobot import *

# Schweizerkreuz
# --------------
repeat 4:
    forward()
    delay(2000)
    left(550)    # macht 90° Ecke
    forward()
    delay(2000)
    right(550)    # macht 90° Ecke
    forward()
    delay(2000)
    right(550)    # macht 90° Ecke
stop()

# Wilde Spur
# ----------
forward(2000)
right(550)    # macht 90° Ecke
forward(4000)
right(550)    # macht 90° Ecke
forward(2000)
left(550)    # macht 90° Ecke
repeat 2:
    forward(2000):
left(550)    # macht 90° Ecke
forward(2000)
right(550)    # macht 90° Ecke
forward(2000)
left(550)    # macht 90° Ecke
forward(2000)
forward(2000)
forward(2000)
left(550)    # macht 90° Ecke
repeat 2:
    forward(3000)
    forward(3000)
forward(2000)
left(550)    # macht 90° Ecke
forward(2000)
stop()


# Schnecke
# --------
delay = 200
time = 1000
repeat 9:
    forward(time)
    left(550)   # macht 90° Ecke
    time = time + delay

# Prüfungsfragen zum Funktionsaufruf und kompatibler Erweiterung
def blink():
    setLED(1)
    delay(500)
    setLED(0)
    delay(500)

# Erweiterung, so dass die Funktion abwärtskompatible bleibt
def blink(colorOn = 2, colorOff=1):
    setLED(colorOn)
    delay(500)
    setLED(colorOff)
    delay(500)


repeat 4:
    blink()

# Mögliche aufrufe nach der Abwärts-Kompatiblen Aenderung
blink()
blink(colorOn = 2, colorOff=1)
blink(colorOff=1, colorOn = 2)
blink(colorOff=1)
blink(colorOn = 2, colorOff=1)

# Frage zu blocking and non-blocking calls
delay = 2000
time = 1000
forward(3 * time)
delay(500)
left(550)

forward(time)          # 1000
time = time * 2
forward()
delay(delay)           # 2000
playTone(500, 1000)    # 1000
repeat 2:
    forward(time)      # 2 * 2000
delay(1000)            # 1000
left(550)
stop()
