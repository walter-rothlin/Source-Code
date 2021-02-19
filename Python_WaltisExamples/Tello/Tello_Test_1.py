from djitellopy import tello
import cv2 as cv


mySpeed = 30

me = tello.Tello()
me.connect()
print(me.get_battery())

me.takeoff()
## me.send_rc_control(0, 30, 0, 0)

me.land()