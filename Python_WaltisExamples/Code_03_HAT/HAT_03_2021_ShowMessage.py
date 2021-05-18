#!/usr/bin/python3

from sense_hat import SenseHat
from time import sleep

sense = SenseHat()
sense.clear(0,50,0)

red = (255, 0, 0)
green = (0, 255,0)
blue = (0, 0, 255)

yellow = (255, 255, 0)
cyan = (0, 255, 255)
magenta = (255, 0, 255)

white = (255, 255, 255)
grey = (100, 100, 100)

sense.set_pixel(0,0,255,0,0)
sleep(1)
sense.show_message(back_colour=[10, 10, 10], text_colour=[255, 0, 0], text_string="Hallo!!!")
    
sense.set_rotation(180)

sense.set_pixel(0,0,255,255,255)   
sleep(1)
sense.show_message(back_colour=[10, 10, 10], text_colour=[255, 255, 255], text_string="Tschüss")

sense.set_rotation(90)

sense.set_pixel(0,0,255,255,0)   
sleep(1)
sense.show_message(back_colour=[10, 10, 10], text_colour=[255, 255, 0], text_string="Tschüss")


sleep(20)
sense.clear()