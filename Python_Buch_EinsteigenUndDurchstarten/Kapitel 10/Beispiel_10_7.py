# Beispiel 10.7
#
# Widgets konfigurieren
#
import tkinter as tk

# Fenster erstellen und Titel festlegen
root = tk.Tk()
root.title("Widgets konfigurieren")

# Ein Textfeld hinzufügen
label = tk.Label(root, text="Ein einfaches Label")
label.pack()

# Aktuellen Text ausgeben, dann ändern
print("Inhalt des Textfeldes:", label.cget("text"))
label.configure(text="Immer noch ein einfaches Label, nur jetzt mit mehr Text!")

# Text erneut ausgeben
print("Inhalt des Textfeldes:", label["text"])

# Hintergrundfarbe des Labels ändern
label["background"] = "purple"

# Fenster anzeigen
root.mainloop()
