# Beispiel 10.20
#
# Menüs
#
import tkinter as tk
from tkinter import messagebox


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        # Ein Label einfügen, damit das Fenster nicht leer ist
        self.label = tk.Label(self, text="Es gibt hier nichts zu sehen!")
        self.label.pack()

        # Menüleiste erstellen
        self.menueleiste = tk.Menu(parent)
        parent["menu"] = self.menueleiste

        # Menü "Browser" erstellen und mit Einträgen versehen
        self.menue_browser = tk.Menu(self.menueleiste, tearoff=False)
        self.menue_browser.add_command(label="Neues Fenster")
        self.menue_browser.add_command(label="Neuer Tab")
        self.menue_browser.add_command(label="Drucken...")
        self.menue_browser.add_separator()
        self.menue_browser.add_command(label="Alle Tabs schließen",
                                       command=self.tabs_schliessen)
        self.menueleiste.add_cascade(label="Browser", menu=self.menue_browser)

        # Menü "Verlauf" erstellen und mit Einträgen versehen
        self.menue_verlauf = tk.Menu(self.menueleiste, tearoff=False)
        self.menue_verlauf.add_command(label="Verlauf anzeigen")
        self.menue_verlauf.add_command(label="Verlauf löschen")
        self.menueleiste.add_cascade(label="Verlauf", menu=self.menue_verlauf)

    def tabs_schliessen(self):
        ergebnis = tk.messagebox.askyesno(title="Schließen",
                                          message="Wirklich alle Tabs schließen?")

        if ergebnis:
            print("Alle Tabs werden geschlossen")


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Menüs")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
