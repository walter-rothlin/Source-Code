#!/usr/bin/python3

# ------------------------------------------------------------------
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2023_03_PY2/03_Multithreading/03_Timer_Event.py
#
# Description: Beispiele
#
# Autor: Walter Rothlin
#
# History:
# 18-Nov-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import time
import threading

def get_timestamp():
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())

class CustomTimer(threading.Timer):
    def __init__(self, interval, function, args=None, kwargs=None):
        super().__init__(interval, self._run, args, kwargs)
        self.function = function

    def _run(self, *args, **kwargs):
        self.function(*args, **kwargs)
        self.finished.set()

def custom_timer_function(firstname, lastname):
    print(f"{get_timestamp()}: Hello, {lastname} {firstname}!")

# Create a custom timer that says hello after 3 seconds
print(f"{get_timestamp()}: Main started")
custom_timer = CustomTimer(3, custom_timer_function, args=("Alice", "Diethelm"))
custom_timer.start()
print(f"{get_timestamp()}: Wait to join")
custom_timer.join()
print(f"{get_timestamp()}: Main finished")
