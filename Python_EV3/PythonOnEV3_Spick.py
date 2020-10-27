# Python_EV3: PythonOnEV3_Spick.py

from grobot import *

forward()
delay(2000)
stop()

# --------------------------------------------------

from grobot import *


# Dies ist ein Komentar
setSpeed(100)
setVolume(100)   # Volumen wird bleibend gesetzt

forward()
delay(2000)
playTone(1000, 1000)
delay(2000)
backward(2000)
stop()


# --------------------------------------------------

from ev3robot import *

robot = LegoRobot()
n = 0
while n < 10:
   robot.drawString("n = " + str(n), 0, 1)
   Tools.delay(1000)
   n += 1
robot.exit()

# --------------------------------------------------

from ev3robot import *

robot = LegoRobot()
gear = Gear()
robot.addPart(gear)
gear.forward(2000)
gear.left(600)
gear.forward(2000)
robot.exit()