from ev3robot import *

robot = LegoRobot()
n = 0
while n < 10:
   robot.drawString("n = " + str(n), 0, 1)
   Tools.delay(1000)
   n += 1
robot.exit()