# Beispiel 10.15
#
# Listboxen
#
import tkinter as tk


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        # Eine kleine Rezeptsammlung
        rezepte = ["Rinderbraten", "Lachsgratin", "Spaghetti Arrabiata",
                   "Erbsensuppe", "Chili con carne", "Chili sin carne"]

        # Steuerelemente hinzufügen
        self.listbox = tk.Listbox(self)
        self.listbox.pack()

        # Listbox mit Rezepten füllen
        for item in rezepte:
            self.listbox.insert(tk.END, item)

        self.entry = tk.Entry(self)
        self.entry.pack()

        # Buttons für das Hinzufügen und Löschen von Rezepten
        self.button = tk.Button(self, text="Neues Rezept hinzufügen")
        self.button["command"] = self.neues_rezept
        self.button.pack()

        self.button2 = tk.Button(self, text="Ausgewähltes Rezept löschen")
        self.button2["command"] = self.rezept_loeschen
        self.button2.pack()

    def neues_rezept(self):
        # Neuen Eintrag am Ende der Liste einfügen
        if self.entry.get():
            self.listbox.insert(tk.END, self.entry.get())

    def rezept_loeschen(self):
        # Gewählten Eintrag löschen
        if self.listbox.curselection():
            index = self.listbox.curselection()[0]
            self.listbox.delete(index)


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Rezeptsammlung")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
