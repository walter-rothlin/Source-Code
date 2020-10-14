#!/usr/bin/python3

'''pruefung_9a_SenseHatLED.py'''

from sense_hat import SenseHat
from time      import sleep

sense = SenseHat()
sense.clear()

sense.set_pixel(2, 3, 255, 0,   0)
sleep(5)
sense.clear()

for i in (1, 2, 3):
    sense.set_pixel(i+2, 5-i, 255, 255,   0)
    sleep(1)
sleep(5)
sense.clear()

for i in range(5, 10):
    print(i)

print(".... successfully completed!")