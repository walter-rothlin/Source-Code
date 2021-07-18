# Beispiel 10.3
#
# Frames
#
import tkinter as tk

# Fenster erstellen und Titel festlegen
root = tk.Tk()
root.title("Frames")

# Zwei Buttons in einen Frame packen
frame1 = tk.Frame(root)

button1 = tk.Button(frame1, text="Button 1")
button1.pack(side="left")

button2 = tk.Button(frame1, text="Button 2")
button2.pack(side="right")

# Ein weiterer Frame, ebenfalls mit zwei Buttons
frame2 = tk.Frame(root)

button3 = tk.Button(frame2, text="Button 3")
button3.pack(side="left")

button4 = tk.Button(frame2, text="Button 4")
button4.pack(side="right")

# Das obere Textfeld
label = tk.Label(root, text="Textfeld oben")
label.pack()

# Nun die beiden Frames packen
frame1.pack()
frame2.pack()

# Das untere Textfeld
label2 = tk.Label(root, text="Textfeld unten")
label2.pack()

# Fenster anzeigen
root.mainloop()
