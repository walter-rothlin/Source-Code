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


def blink(color=1, anzahl=1, blinkRate=500, withTone=False, onFreq=440, offFreq=100, onTime=500, offTime=500, offColor=0):
    setVolume(100)
    repeat anzahl:
        setLED(color)
        if withTone:
            playTone(onFreq, onTime)
        else:
            delay(blinkRate)

        setLED(offColor)
        if withTone:
            playTone(offFreq, offTime)
        else:
            delay(blinkRate)

clearDisplay()
drawString("LED-Test", 0, 4)
setLED(1)     # rot
delay(2000)
setLED(2)     # gruen
delay(2000)
setLED(3)     # orange
delay(2000)
setLED(4)     # off

drawString("Blink-Test....", 0, 4)
blink()
blink(1)
blink(2, 3)
blink(3, 3, 2000)
blink(1, 3, 2000, True, offColor=2)
blink(withTone=True)
blink(color=2, onFreq=500, offFreq=1000, anzahl=5, blinkRate=1000, withTone=True, onTime=300, offTime=800, offColor=1)

drawString("Blink-Test done", 0, 4)
delay(4000)















