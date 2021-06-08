import time
from LEDController import LEDController

led = LEDController()

try:
    
    led.setRed(255)
    led.setGreen(0)
    led.setBlue(0)
    
    time.sleep(5)

except KeyboardInterrupt:
    pass
except: raise
finally:
    led.clear()

