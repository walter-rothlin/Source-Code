#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 02_widgets.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_04_TKL/02_widgets.py
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


rootWindow = tk.Tk()
rootWindow.title("Widget Collection")
rootWindow.geometry('800x500')
rootWindow.resizable(width=True, height=True)

label_hallo = tk.Label(rootWindow, text='Label', font=("Arial Bold", 50), foreground="red", background="black", width=10, height=3)
label_hallo.grid(column=0, row=0)

button_1 = tk.Button(rootWindow,
    text="Button!",
    width=25,
    height=5,
    bg="blue",
    fg="yellow"
)
button_1.grid(column=1, row=0)

entry = tk.Entry(fg="red", bg="blue", width=50)
entry.grid(column=0, row=1)

textBox = tk.Text(fg="black", bg="yellow", width=50, height=20)
textBox.grid(column=1, row=1)

rootWindow.mainloop()
