import time, curses
from LEDController import LEDController

led = LEDController()

red = 0
green = 0
blue = 0

step = 15

def onInput(char):
    global red
    global green
    global blue



############################################


try:
    win = curses.initscr()
    curses.noecho()

    while True:
        char = chr(win.getch())
        if char in '1235789': onInput(char)
        # Empty spaces are to overwrite larger numbers
        win.addstr(0,0, 'R: ' + str(red) + '   ')
        win.addstr(1,0, 'G: ' + str(green) + '   ')
        win.addstr(2,0, 'B: ' + str(blue) + '   ')
        win.addstr(3,0, '') # Cursor on new line
        win.refresh()
        time.sleep(0.02)


except KeyboardInterrupt:
    pass
except: raise
finally:
    led.clear()
    curses.endwin()
