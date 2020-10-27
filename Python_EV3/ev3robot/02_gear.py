from ev3robot import *

robot = LegoRobot()
gear = Gear()
robot.addPart(gear)
gear.forward(2000)
gear.left(600)
gear.forward(2000)
robot.exit()