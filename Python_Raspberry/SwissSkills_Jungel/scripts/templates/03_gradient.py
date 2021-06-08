import time
from LEDController import LEDController

led = LEDController()

try:
    led.setRed(255)
    time.sleep(0.5)

except KeyboardInterrupt:
    pass
except: raise
finally:
    led.clear()

