#!/usr/bin/python3

#Silvan Brändli
#showIP Loading Bar
#BZU 30.05.2023

import os
import sys

from sense_hat import SenseHat


sense = SenseHat()
import time

X = [255, 255, 255]   # White
O = [0, 0, 0]    # Black

loadingtime = 1.5 #Loadingtime per Pixel, Total time = Loadingtime *8


print("\n\n")
print("# Show IP Adresse (V1.0.0.0)")
print("# --------------------------")
name    = "Silvan"
displayMsg = "Hello " + name

print(displayMsg)
sense.show_message(displayMsg, text_colour=(0,125,125))

loadingbar = [
O,O,O,O,O,O,O,O,
O,O,O,O,O,O,O,O,
O,O,O,O,O,O,O,O,
X,X,X,X,X,X,X,X,
O,O,O,O,O,O,O,O,
X,X,X,X,X,X,X,X,
O,O,O,O,O,O,O,O,
O,O,O,O,O,O,O,O]
 
sense.set_pixels(loadingbar)

pixel = 0
green = 0
red = 255

for x in range(0, 8):
    sense.set_pixel(pixel, 4, (red, green, 0))
    pixel += 1
    red = red - 32
    green = green + 32
    
    time.sleep(loadingtime)
    


question_mark = [
O, O, O, X, X, O, O, O,
O, O, X, O, O, X, O, O,
O, O, O, O, O, X, O, O,
O, O, O, O, X, O, O, O,
O, O, O, X, O, O, O, O,
O, O, O, X, O, O, O, O,
O, O, O, O, O, O, O, O,
O, O, O, X, O, O, O, O
]

finished = False
while not finished:
    sense.set_pixels(question_mark)
    
    # wait for events, but delete all events happen before this call
    event = sense.stick.wait_for_event(emptybuffer=True)
    print("The joystick was {} {}".format(event.action, event.direction))
    if (event.direction == "right"):
        finished = True
    elif (event.direction == "left"):
        myHostname = os.popen('/bin/hostname').read().strip()
        print("  Hostname:" + myHostname + "::")
        sense.show_message(str(myHostname), text_colour=(125,125,0))

    ipArray = os.popen('/bin/hostname -I').read().strip().split(" ")
    for ip in ipArray:
        ipStr = str(ip).strip('\r\n')
        print("  IP:" + ipStr + "::")
        sense.show_message(str(ipStr), text_colour=(125,125,125))

    sense.clear()   # clear LED matrix

sense.show_message("Done & Closed!!!", text_colour=(0,125,125))