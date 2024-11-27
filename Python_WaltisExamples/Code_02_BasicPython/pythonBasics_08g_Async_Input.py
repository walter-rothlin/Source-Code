#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_08g_Async_Input.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08g_Async_Input.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 26.11.2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import keyboard
import asyncio

async def my_input(prompt='Input:', default_value=''):

    while True:
        print(f'{prompt}{default_value}')
        event = keyboard.read_event(suppress=True)  # Get key events suppress echo()
        if event.event_type == "down":  # Only process key press events
            if len(str(event.name)) == 1:
                default_value += str(event.name)
                # print(f"Regular char: {event.name}")
            else:
                print(f"Key pressed: {str(event.name)}")
        await asyncio.sleep(0.01)  # Prevent tight-loop hogging CPU



async def detect_keys():
    print("Press any key (Ctrl+C to exit):")
    while True:
        event = keyboard.read_event(suppress=True)  # Get key events suppress echo()
        if event.event_type == "down":  # Only process key press events
            if len(str(event.name)) == 1:
                print(f"Regular char: {event.name}")
            else:
                print(f"Key pressed: {str(event.name)}")
        await asyncio.sleep(0.01)  # Prevent tight-loop hogging CPU

# Run the async loop
try:
    # asyncio.run(detect_keys())
    asyncio.run(my_input('Dein Name:', "Walter"))
except KeyboardInterrupt:
    print("Stopped.")
