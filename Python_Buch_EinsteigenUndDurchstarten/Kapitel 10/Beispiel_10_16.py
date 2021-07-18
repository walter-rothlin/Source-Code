# Beispiel 10.16
#
# Listbox mit Scrollbalken
#
import tkinter as tk


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        # Listbox mit Scrollbalken hinzufügen

        self.scrollbar = tk.Scrollbar(self, orient=tk.VERTICAL)
        self.listbox = tk.Listbox(self, yscrollcommand=self.scrollbar.set)
        self.scrollbar["command"] = self.listbox.yview
        self.listbox.grid(row=0, column=0)
        self.scrollbar.grid(row=0, column=1, sticky="NSW")

        # Listbox mit Einträgen füllen
        for i in range(20):
            self.listbox.insert(tk.END, "Listbox-Eintrag {0}".format(i))


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Scrollbalken")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
