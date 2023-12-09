import time
from LEDController import LEDController

led = LEDController()

try:
    
    led.setRed(255)
    time.sleep(1)
    
    led.setRed(0)
    led.setGreen(255)
    time.sleep(1)

    led.setGreen(0)
    led.setBlue(255)
    time.sleep(1)
    
    led.clear()

except KeyboardInterrupt:
    pass
except: raise
finally:
    led.clear()
