import time
from LEDController import LEDController

led = LEDController()

try:
    
    led.setRed(255)
    time.sleep(1)

except KeyboardInterrupt:
    pass
except: raise
finally:
    led.clear()
