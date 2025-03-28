#!/usr/bin/python3

# ------------------------------------------------------------------
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2023_03_PY2/03_Multithreading/02_Timer_Event.py
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


def timer_function():
    print(f'{get_timestamp()}: timer_function() called!')
    # Restart the timer
    start_timer()


def start_timer():
    global timer
    # Cancel the existing timer (if any)
    if timer and timer.is_alive():
        timer.cancel()
    # Create and start a new timer
    timer = threading.Timer(5, timer_function)
    timer.start()

# Initialize the timer
timer = None
start_timer()

for i in range(10):
    print(f'{get_timestamp()} Working....{i}')
    time.sleep(1)

print(f'{get_timestamp()} Wait for Join')
timer.join()
print(f'{get_timestamp()} Back to main and waiting...')
time.sleep(20)
timer.cancel()
print(f'{get_timestamp()} Main done!!!')
