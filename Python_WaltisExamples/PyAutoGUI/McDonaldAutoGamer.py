#!/usr/bin/python3



import pyautogui, time, keyboard
# https://pyautogui.readthedocs.io/en/latest/




def AutoJumper():
     try:
          while True:
               # pyautogui.pixelMatchesColor(x-Koordinate,y-Koordinate, expectedRGBColor=(RGB Wert))
               if pyautogui.pixelMatchesColor(1840, 635, expectedRGBColor=(55, 24, 10)):
                    pyautogui.leftClick(1840, 635)
     except:
          print("Programm Absturz")

def drawSpirale():
     time.sleep(5)
     distance = 200
     while distance > 0:
          pyautogui.drag(distance, 0, duration=0.5)  # move right
          distance -= 5
          pyautogui.drag(0, distance, duration=0.5)  # move down
          pyautogui.drag(-distance, 0, duration=0.5)  # move left
          distance -= 5
          pyautogui.drag(0, -distance, duration=0.5)  # move up

# AutoJumper()
# drawSpirale()
# pyautogui.mouseInfo()
# help(pyautogui)
im2 = pyautogui.screenshot('my_screenshot.png')

