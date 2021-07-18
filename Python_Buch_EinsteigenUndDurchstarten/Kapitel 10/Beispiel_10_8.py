# Beispiel 10.8
#
# Buttons
#
import tkinter as tk


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        self.zaehler = 0

        # Steuerelemente hinzufügen
        self.label = tk.Label(self, text="Zähler: 0", width=35)
        self.label.pack()

        self.button = tk.Button(self, text="Zähler erhöhen", command=self.plus)
        self.button.pack()

    def plus(self):
        # Zähler erhöhen und Label aktualisieren
        self.zaehler += 1
        self.label["text"] = "Zähler: {0}".format(self.zaehler)


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Ein bisschen mehr Interaktion")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
