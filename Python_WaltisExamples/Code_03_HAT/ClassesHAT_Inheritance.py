#!/usr/bin/python3

from sense_hat import SenseHat
from time import sleep


class WR_SenseHat(SenseHat):

   def __init__(self):
      self.__sense = SenseHat()

   def clearPixel(self,x,y):
       self.__sense.set_pixel(x,y,0,0,0)

   def setPixelYellow(self,x,y):
       self.__sense.set_pixel(x,y,255,255,0)

wr_senseHat = WR_SenseHat()
print("1")
wr_senseHat.setPixelYellow(0,0)
# Aufrufen einer Methode in der Basisklasse Funktioniert nicht!!!!!
# wr_senseHat.set_pixel(0, 0, 255, 255,0)
print("2")
sleep(5)
print("3")
wr_senseHat.clearPixel(0, 0)
print("Done")
