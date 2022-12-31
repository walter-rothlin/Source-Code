#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01_hello.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_04_TKL/01_hello.py
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
rootWindow.title("Hallo Schweiz")
rootWindow.resizable(width=True, height=True)

label_hallo = tk.Label(rootWindow, text='Hello World!\nBZU\nHWZ', foreground="blue", background="black", width="20", height="10")
label_hallo.pack(padx=100, pady=10)

rootWindow.mainloop()
