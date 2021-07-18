# Beispiel 10.5
#
# Zellen im Grid verbinden
#
import tkinter as tk

# Fenster erstellen und Titel festlegen
root = tk.Tk()
root.title("Zellen verbinden")
root.resizable(False, False)

# Diese Buttons erscheinen links im Fenster
button = tk.Button(root, text="A")
button.grid(row=0, column=0)

button2 = tk.Button(root, text="B")
button2.grid(row=1, column=0)

button3 = tk.Button(root, text="C")
button3.grid(row=2, column=0)

# Diese Buttons erscheinen unten im Fenster
button4 = tk.Button(root, text="Button 1")
button4.grid(row=2, column=1)

button5 = tk.Button(root, text="Button 2")
button5.grid(row=2, column=2)

# Dieses Textfeld nimmt den oberen rechten Bereich des Fensters ein
label = tk.Label(root, text="Das ist ein\nmehrzeiliger\nText")
label.grid(row=0, column=1, rowspan=2, columnspan=2)

# Fenster anzeigen
root.mainloop()
