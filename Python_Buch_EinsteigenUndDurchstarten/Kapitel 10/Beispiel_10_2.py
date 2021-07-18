# Beispiel 10.2
#
# Einschränkungen beim pack-Manager
#
import tkinter as tk

# Fenster erstellen und Titel festlegen
root = tk.Tk()
root.title("Das zweite Fenster")

# Ein paar Steuerelemente hinzufügen
label = tk.Label(root, text="Textfeld oben")
label.pack()

button1 = tk.Button(root, text="Button links")
button1.pack(side="left")

button2 = tk.Button(root, text="Button rechts")
button2.pack(side="right")

button3 = tk.Button(root, text="Button unten")
button3.pack(side="bottom")

# Fenster anzeigen
root.mainloop()
