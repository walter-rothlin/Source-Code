from ev3robot import *

robot = LegoRobot()
gear = Gear()
robot.addPart(gear)
ts = TouchSensor(SensorPort.S2)
robot.addPart(ts)
gear.forward()

while not robot.isEscapeHit(): 
    if ts.isPressed():
        gear.backward(1500)
        gear.left(550)
        gear.forward()
robot.exit()