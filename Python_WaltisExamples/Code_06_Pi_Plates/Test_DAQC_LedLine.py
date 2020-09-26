#!/usr/bin/python3


# Notepad++ Spaces instead of TAB: Settings --> Preferences... --> 	

# http://pi-plates.com/daqc-users-guide/

### To install the pi-plates module use:   
##    Enable SPI unter einstellungen --> Interfaces
##    sudo pip3 install pi-plates

import os
import sys
import time
import datetime
import piplates.DAQCplate as DAQC
from   CLASS_DAQC_LedLine import *

print("Test CLASS_DAQC_LedLine (Adr=1)...")
ledLine_1 = CLASS_DAQC_LedLine("Test-Balken", 1)
ledLine_1.drawBalken(3)
time.sleep(1)
ledLine_1.incBalken()
time.sleep(1)
ledLine_1.incBalken()
time.sleep(1)
ledLine_1.incBalken()
time.sleep(1)
ledLine_1.incBalken()
time.sleep(5)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.decBalken()
time.sleep(1)
ledLine_1.incBalken()
time.sleep(1)
ledLine_1.incBalken()
time.sleep(1)
ledLine_1.incBalken()
time.sleep(1)
ledLine_1.incBalken()
time.sleep(1)
ledLine_1.incBalken()

ledLine_1.clearAll()
time.sleep(1)
ledLine_1.setLED(0)
ledLine_1.setLED(6)
time.sleep(1)
ledLine_1.unsetLED(0)
ledLine_1.unsetLED(6)


print("Wait 5s")
time.sleep(5)
print("Test completed")
