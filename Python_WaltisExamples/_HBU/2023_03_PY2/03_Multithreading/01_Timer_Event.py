#!/usr/bin/python3

# ------------------------------------------------------------------
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2023_03_PY2/03_Multithreading/01_Timer_Event.py
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


def timer_function(firstname='Nobody'):
    print(f"{get_timestamp()}: timer_function('{firstname}') called!")


timer = threading.Timer(15, timer_function)
timer.start()

for i in range(10):
    print(f'{get_timestamp()}: Working....{i}')
    time.sleep(1)

print(f'{get_timestamp()}: Wait for Join')
timer.join()
print(f'{get_timestamp()}: Main done!!!')
