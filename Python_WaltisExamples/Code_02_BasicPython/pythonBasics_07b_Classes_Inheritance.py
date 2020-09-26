#!/usr/bin/python3

from sense_hat import SenseHat
from time import sleep


class WR_SenseHat(SenseHat):

   def __init__(self):
      self.sense = SenseHat()
   
   def clearPixel(self,x,y):
       sense.set_pixel(x,y,0,0,0)
	

senseHat = WR_SenseHat()
print("1")
senseHat.set_pixel(0, 0, 255, 255,0)
print("2")
sleep(5)
print("3")
senseHat.clearPixel(0, 0)
print("Done")
