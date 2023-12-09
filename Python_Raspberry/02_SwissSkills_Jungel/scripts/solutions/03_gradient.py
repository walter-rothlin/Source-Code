import time
from LEDController import LEDController

led = LEDController()

try:
    led.setRed(255)
    for i in range(255):
        led.setRed(255 - i)
        led.setBlue(i)
        time.sleep(0.02)

    for i in range(255):
        led.setBlue(255 - i)
        led.setGreen(i)
        time.sleep(0.02)

    for i in range(255):
        led.setGreen(255 - i)
        led.setRed(i)
        time.sleep(0.02)

    time.sleep(0.5)

except KeyboardInterrupt:
    pass
except: raise
finally:
    led.clear()

