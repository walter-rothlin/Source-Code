#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: snake.py
#
# Description: Methodisch didaktischer Aufbau eines Snake-Programmes.
#              IST SO NICHT LAUFFàHIG!
#
# Autor: Walter Rothlin
#
# History:
# 02-July-2020   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------


# Start-Variante
# ==============
from sense_hat import SenseHat
import time

sense = SenseHat()
sense.set_pixel(0,3,255,255,255)
time.sleep(.75)

sense.set_pixel(1,3,255,255,255)
time.sleep(.75)

# Mit For-Loop
# ============
from sense_hat import SenseHat
import time

sense = SenseHat()
for xPos in range(8):
  sense.clear()
  sense.set_pixel(xPos,3,255,255,255)
  time.sleep(.75)

# Ohne Eventhandler
# =================
from sense_hat import SenseHat
import time

xPos = 0
yPos = 0
xShift = 1
yShift =  1

sense = SenseHat()

doLoop = True
while doLoop:
  sense.clear()
  sense.set_pixel(xPos,yPos,255,255,255)
  time.sleep(.75)
  xPos = xPos + xShift
  yPos = yPos + yShift
  if (xPos > 7):
    xPos = 6
    xShift = -1
  if (xPos < 0):
    xPos = 1
    xShift = 1
    
  if (yPos > 7):
    yPos = 6
    yShift = -1
  if (yPos < 0):
    yPos = 1
    yShift = 1

# Schluss-Variante
# ================
from sense_hat import SenseHat, ACTION_PRESSED, ACTION_HELD, ACTION_RELEASED
import time

sense = SenseHat()

xPos = 0
xShift = 1
yPos = 3
yShift = 1

def pushed_up(event):
    global xShift
    global yShift
    if event.action != ACTION_RELEASED:
      xShift = 0
      yShift =  -1

def pushed_down(event):
    global xShift
    global yShift
    if event.action != ACTION_RELEASED:
      xShift = 0
      yShift =  1

def pushed_left(event):
    global xShift
    global yShift
    if event.action != ACTION_RELEASED:
      xShift = -1
      yShift =  0

def pushed_right(event):
    global xShift
    global yShift
    if event.action != ACTION_RELEASED:
      xShift = 1
      yShift =  0

sense.stick.direction_up    = pushed_up
sense.stick.direction_down  = pushed_down
sense.stick.direction_left  = pushed_left
sense.stick.direction_right = pushed_right
doLoop = True
while doLoop:
  sense.clear()
  sense.set_pixel(xPos,yPos,255,255,0)

  if (xPos >= 7):
    xShift = -1
  if (xPos <= 0):
    xShift = 1
  
  if (yPos >= 7):
    yShift = -1
  if (yPos <= 0):
    yShift = 1
    
  xPos = xPos + xShift
  yPos = yPos + yShift
  time.sleep(.75)
