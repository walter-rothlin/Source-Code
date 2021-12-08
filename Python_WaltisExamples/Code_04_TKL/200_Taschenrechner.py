#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 200_Taschenrechner.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_04_TKL/200_Taschenrechner.py
#
# Description: Taschenrechner
#
#
#
# Autor: Walter Rothlin
#
# History:
# 05-Dec-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from tkinter import *

root = Tk()

# Text input area
e = Entry(root, width=35, borderwidth=5)
e.grid(row=0, column=0, columnspan=3, padx=30)

list_of_numbers = []
# function to get numbers
def number_input(number):
    current_value = e.get()
    e.delete(0, END)
    e.insert(0, str(current_value) + str(number))

def clear_values():
    list_of_numbers.clear()
    e.delete(0, END)

def sum_of_values():
    num1 = e.get()
    list_of_numbers.append(num1)
    e.delete(0, END)

def equals():
    num1 = e.get()
    list_of_numbers.append(int(num1))
    e.delete(0, END)

    SUM = 0
    for values in list_of_numbers:
        SUM += int(values)

    e.insert(0, SUM)


# Buttons 9-0, add, clear, equals
buttn9 = Button(root, text="9", padx=40, pady=20, command = lambda : number_input(9)).grid(row= 1, column=0)
buttn8 = Button(root, text="8", padx=40, pady=20, command = lambda : number_input(8)).grid(row= 1, column=1)
buttn7 = Button(root, text="7", padx=40, pady=20, command = lambda : number_input(7)).grid(row= 1, column=2)

buttn6 = Button(root, text="6", padx=40, pady=20, command = lambda : number_input(6)).grid(row= 2, column=0)
buttn5 = Button(root, text="5", padx=40, pady=20, command = lambda : number_input(5)).grid(row= 2, column=1)
buttn4 = Button(root, text="4", padx=40, pady=20, command = lambda : number_input(4)).grid(row= 2, column=2)

buttn3 = Button(root, text="3", padx=40, pady=20, command = lambda : number_input(3)).grid(row= 3, column=0)
buttn2 = Button(root, text="2", padx=40, pady=20, command = lambda : number_input(2)).grid(row= 3, column=1)
buttn1 = Button(root, text="1", padx=40, pady=20, command = lambda : number_input(1)).grid(row= 3, column=2)

buttn0 = Button(root, text="0", padx=40, pady=20, command = lambda : number_input(0)).grid(row= 4, column=0)

buttn_add    = Button(root, text="+",   padx=40, pady=20, command = sum_of_values).grid(row= 4, column=1, columnspan=2)
buttn_clear  = Button(root, text="cls", padx=40, pady=20, command = clear_values).grid(row= 5, column=0)
buttn_equals = Button(root, text="=",   padx=40, pady=20, command = equals).grid(row= 5, column=1, columnspan=2)

root.mainloop()

