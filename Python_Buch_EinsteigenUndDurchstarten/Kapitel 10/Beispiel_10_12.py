# Beispiel 10.12
#
# Checkboxen
#
import tkinter as tk


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        # Checkbox für Komprimierung
        self.log_komprimieren = tk.BooleanVar()

        self.checkbox1 = tk.Checkbutton(self, text="Komprimieren (.zip)")
        self.checkbox1["variable"] = self.log_komprimieren
        self.checkbox1["command"] = self.checkbox_clicked
        self.checkbox1.pack(anchor="w")

        # Checkbox für detaillierte Ausgabe
        self.log_detailgrad = tk.IntVar(value=1)

        self.checkbox2 = tk.Checkbutton(self, text="Detaillierte Ausgabe")
        self.checkbox2["onvalue"] = 5
        self.checkbox2["offvalue"] = 1
        self.checkbox2["variable"] = self.log_detailgrad
        self.checkbox2["command"] = self.checkbox_clicked
        self.checkbox2.pack(anchor="w")

        # Button zum Exportieren
        self.button = tk.Button(self, text="Logfiles exportieren", width=25)
        self.button["command"] = self.log_exportieren
        self.button.pack()

    def checkbox_clicked(self):
        print("Die Optionen wurden geändert")

    def log_exportieren(self):
        print("Logfile wird exportiert...")
        print("Komprimieren: ", self.log_komprimieren.get())
        print("Detailgrad: ", self.log_detailgrad.get())


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Logfile exportieren")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
