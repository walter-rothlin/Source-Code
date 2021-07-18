# Beispiel 10.17
#
# Fehlerquelltext
#
import tkinter as tk


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        # Textbox mit Scrollbalken hinzufügen
        self.scrollbar_x = tk.Scrollbar(self, orient=tk.VERTICAL)
        self.scrollbar_y = tk.Scrollbar(self, orient=tk.HORIZONTAL)
        self.textbox = tk.Text(self, wrap=tk.NONE, width=24, height=8)
        self.textbox["xscrollcommand"] = self.scrollbar_x.set
        self.textbox["yscrollcommand"] = self.scrollbar_y.set
        self.scrollbar_x["command"] = self.textbox.xview()
        self.scrollbar_y["command"] = self.textbox.yview()
        self.textbox.grid(row=0, column=0)
        self.scrollbar_x.grid(row=1, column=0, sticky="EWS")
        self.scrollbar_y.grid(row=0, column=1, sticky="NWS")


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Fehlerquelltext")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
