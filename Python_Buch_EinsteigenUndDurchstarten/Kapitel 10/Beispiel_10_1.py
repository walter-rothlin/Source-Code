# Beispiel 10.1
#
# Fenster mit pack-Layout
#
import tkinter as tk

# Fenster erstellen und Titel festlegen
root = tk.Tk()
root.title("Das erste Fenster")

# Ein paar Steuerelemente hinzufügen
label1 = tk.Label(root, text="Textfeld oben")
label1.pack(anchor="w")

button1 = tk.Button(root, text="Button Mitte")
button1.pack()

button2 = tk.Button(root, text="Button links")
button2.pack(side="left")

button3 = tk.Button(root, text="Button rechts")
button3.pack(side="right")

# Fenster anzeigen
root.mainloop()
