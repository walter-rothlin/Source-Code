import time
from LEDController import LEDController

led = LEDController()

try:
    
    led.setRed(255)
    led.setGreen(255)
    led.setBlue(255)
    
    time.sleep(5)

except KeyboardInterrupt:
    pass
except: raise
finally:
    led.clear()

