# Beispiel 10.21
#
# Untermenüs
#
import tkinter as tk


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        # Ein Label einfügen, damit das Fenster nicht leer ist
        self.label = tk.Label(self, text="Es gibt hier nichts zu sehen!")
        self.label.pack()

        # Menüleiste erstellen
        self.menueleiste = tk.Menu(self)
        parent["menu"] = self.menueleiste

        # Menü "Start" erstellen und mit Einträgen versehen
        self.menue_start = tk.Menu(self.menueleiste, tearoff=False)
        self.menue_start.add_command(label="Neu")
        self.menueleiste.add_cascade(label="Start", menu=self.menue_start)

        # Menü "Vorige öffnen" erstellen und mit Einträgen versehen
        self.menue_zuletzt = tk.Menu(self.menueleiste, tearoff=False)
        self.menue_zuletzt.add_command(label="Rezeptsammlung.txt")
        self.menue_zuletzt.add_command(label="Zu Erledigen.txt")
        self.menue_start.add_cascade(label="Vorige öffnen",
                                     menu=self.menue_zuletzt)


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Untermenüs")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
