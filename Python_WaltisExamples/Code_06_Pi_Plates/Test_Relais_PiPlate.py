#!/usr/bin/python3

# http://pi-plates.com/relayplate-users-guide
# https://pi-plates.com/downloads/RELAYplateQuickReferenceGuide.pdf

### To install the pi-plates module use:   
##    Enable SPI unter einstellungen --> Interfaces
##    sudo pip3 install pi-plates

import time
import piplates.RELAYplate as RELAY

print("Test Relais-Karte (Adr=3)...")
print("Turns relays 1-7 on and off again")
for i in range(1,8):
    RELAY.relayON(3,i)
    time.sleep(1)
for i in range(7,0,-1):
    RELAY.relayOFF(3,i)
    time.sleep(1)

print("Test completed")

