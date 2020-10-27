# Python_EV3: 04b_Functions.py

from grobot import *

def warnBlink():
    setLED(1)
    delay(500)
    setLED(0)
    delay(500)


# warnBlink Test
clearDisplay()
drawString("warnBlink-Test...", 0, 4)
forward()
delay(2000)
stop()
warnBlink()
backward()
warnBlink()
delay(2000)
left(550)
drawString("warnBlink-Test done", 0, 4)
delay(4000)

def blink(color=1, anzahl=1, blinkRate=500, withTone=False, onFreq=440, offFreq=100, onTime=500, offTime=500, offColor=0):
    setVolume(100)
    repeat anzahl:
        setLED(color)
        if withTone:
            playTone(onFreq, onTime)   # Cis ==> 1108.73Hz
        else:
            delay(blinkRate)

        setLED(offColor)
        if withTone:
            playTone(offFreq, offTime)  # Gis ==> 830.609Hz
        else:
            delay(blinkRate)

'''
schaltet LEDs: 
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
LED_Colors = {
    "off": 0,
    "red": 1,
    "green":2,
    "orange":3,
    "greenBlinking":4,
}

# LED Test
clearDisplay()
drawString("LED-Test...", 0, 4)
setLED(1)     # rot
delay(2000)
setLED(2)     # gruen
delay(2000)
setLED(3)     # orange
delay(2000)
setLED(0)     # off

drawString("LED-Test with Dicts", 0, 5)
delay(2000)
setLED(LED_Colors["red"])
delay(2000)
setLED(LED_Colors["green"])
delay(2000)
setLED(LED_Colors["orange"])
delay(2000)
setLED(LED_Colors["off"])

drawString("LED-Test done", 0, 4)
delay(4000)

# blink Test
clearDisplay()
drawString("Blink-Test...", 0, 4)
blink()
blink(1)
blink(2, 3)
blink(3, 3, 2000)
blink(1, 3, 2000, True, offColor=2)
blink(withTone=True)
blink(color=2, onFreq=500, offFreq=1000, anzahl=5, blinkRate=1000, withTone=True, onTime=300, offTime=800, offColor=1)
drawString("Blink-Test done", 0, 4)
delay(4000)
