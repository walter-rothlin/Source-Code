#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: printIP.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_01_UtilityScripts/printIP.py
#
# Description: Zeigt die IP-Adresse auf der Sense-Hat LED Matrix
#
# Autor: Walter Rothlin
#
# History:
# 16-May-2023   Walter Rothlin      Added header to initial version
# ------------------------------------------------------------------


import os
import sys

from sense_hat import SenseHat


sense = SenseHat()


print("\n\n")
print("# Show IP Adresse (V1.0.0.0)")
print("# --------------------------")
name    = "BZU:"
vorname = "Waiting for Joystick Event"
displayMsg = "Hello " + name + " " + vorname

print(displayMsg)
sense.show_message(displayMsg, text_colour=(0, 125, 125))


X = [255, 0, 0]   # Red
O = [70, 70, 0]    # Yellow

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
        sense.show_message(str(myHostname), text_colour=(125, 125, 0))

    ipArray = os.popen('/bin/hostname -I').read().strip().split(" ")
    for ip in ipArray:
        ipStr = str(ip).strip('\r\n')
        print("  IP:" + ipStr + "::")
        sense.show_message(str(ipStr), text_colour=(125, 125, 125))

    sense.clear()   # clear LED matrix

sense.show_message("Done & Closed!!!", text_colour=(0, 125, 125))