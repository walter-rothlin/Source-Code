#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 03_interaktivitaet.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_04_TKL/03_interaktivitaet.py
#
# Description: Example for GUI programming
#
#
# Autor: Walter Rothlin
#
# History:
# 05-Dec-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import tkinter as tk


def plusPressed():  # Eventhandler for button
    print("Button pressed")
    label_hallo["text"] += "!"


rootWindow = tk.Tk()
rootWindow.title("Ein bisschen mehr Interaktion")
rootWindow.geometry('350x400')
rootWindow.resizable(width=True, height=True)

label_hallo = tk.Label(rootWindow, text='hello', font=("Arial Bold", 20), foreground="red", background="black", width=10, height=5)
label_hallo.pack(padx=50, pady=50)

button_1 = tk.Button(rootWindow,
    text="Click me!",
    width=25,
    height=5,
    bg="blue",
    fg="yellow",
    command=plusPressed
)
button_1.pack(padx=50, pady=50)


rootWindow.mainloop()
