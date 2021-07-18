# Beispiel 10.6
#
# Automatische Größenanpassung
#
import tkinter as tk

# Fenster erstellen und Titel festlegen
root = tk.Tk()
root.title("Automatische Größenanpassung")

# Das Textfeld soll den freien Raum einnehmen
root.grid_rowconfigure(0, weight=1)
root.grid_columnconfigure(0, weight=1)

# Die folgende Zeile kann zur Veranschaulichung einkommentiert werden
# root.grid_rowconfigure(1, weight=2)

# Diese Buttons erscheinen unten im Fenster
button1 = tk.Button(root, text="Neues Dokument")
button1.grid(row=1, column=0, sticky="W")

button2 = tk.Button(root, text="Laden")
button2.grid(row=1, column=1, sticky="E")

button3 = tk.Button(root, text="Speichern")
button3.grid(row=1, column=2, sticky="E")

# Dieses Textfeld nimmt den oberen Bereich des Fensters ein und
# passt sich automatisch an die Fenstergröße an
textbox = tk.Text(root, width=60, height=10)
textbox.grid(row=0, column=0, rowspan=1, columnspan=3, sticky="NESW")

# Dimension des Fensters ermitteln und als Mindestgröße verwenden
root.update()
root.minsize(root.winfo_width(), root.winfo_height())

# Fenster anzeigen
root.mainloop()
