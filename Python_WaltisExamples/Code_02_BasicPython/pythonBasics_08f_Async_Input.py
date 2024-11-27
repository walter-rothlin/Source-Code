#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_08f_Async_Input.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08f_Async_Input.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 26.11.2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import threading
import queue
import time

# Queue to communicate between threads
input_queue = queue.Queue()

def read_input():
    while True:
        user_input = input()
        input_queue.put(user_input)

# Start the input thread
thread = threading.Thread(target=read_input, daemon=True)
thread.start()

print("Type something (Ctrl+C to exit):")
while True:
    # Check for new input without blocking
    if not input_queue.empty():
        user_input = input_queue.get()
        print(f"You typed: {user_input}")
    time.sleep(0.1)  # Simulate doing other work
