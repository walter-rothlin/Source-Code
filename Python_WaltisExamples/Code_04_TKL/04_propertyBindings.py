#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 04_propertyBindings.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_04_TKL/04_propertyBindings.py
#
# Description: Example for GUI programming
# Beispiel 10.9
#
# Kontrollvariablen
#
#
#
# Autor: Walter Rothlin
#
# History:
# 05-Dec-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import tkinter as tk


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        self.zaehler = tk.IntVar()

        # Steuerelemente hinzufügen
        self.label = tk.Label(self, width=35)
        self.label["textvariable"] = self.zaehler
        self.label.pack()

        self.button = tk.Button(self, text="Zähler erhöhen", command=self.plus)
        self.button.pack()

        self.button2 = tk.Button(self, text="Zähler verdoppeln")
        self.button2["command"] = self.verdoppeln
        self.button2.pack()

    def plus(self):
        self.zaehler.set(self.zaehler.get() + 1)

    def verdoppeln(self):
        self.zaehler.set(self.zaehler.get() * 2)


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Kontrollvariablen")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()