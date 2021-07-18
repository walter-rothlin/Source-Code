# Beispiel 10.4
#
# Fenster mit grid-Layout
#
import tkinter as tk

# Fenster erstellen und Titel festlegen
root = tk.Tk()
root.title("Grid-Layout")
root.resizable(False, False)

# Steuerelemente im Gitter anordnen
label = tk.Label(root, text="Oben links\nMehrzeiliger\nText")
label.grid(row=0, column=0)

button1 = tk.Button(root, text="Oben rechts")
button1.grid(row=1, column=0)

button2 = tk.Button(root, text="Unten links")
button2.grid(row=0, column=1)

label2 = tk.Label(root, text="Unten rechts, langer Text")
label2.grid(row=1, column=1)

# Fenster anzeigen
root.mainloop()
