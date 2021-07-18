# Beispiel 10.10
#
# Eingabefelder mit magischer Verbindung
#
import tkinter as tk


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        self.eingabe = tk.StringVar(value="Text: ")

        # Steuerelemente hinzufügen
        self.label = tk.Label(self, width=35)
        self.label["textvariable"] = self.eingabe
        self.label.pack()

        self.entry = tk.Entry(self, width=35)
        self.entry["textvariable"] = self.eingabe
        self.entry.pack()

        self.button = tk.Button(self, text="Reset", command=self.reset)
        self.button.pack()

    def reset(self):
        # Text ausgeben und zurücksetzen
        print("Inhalt des Eingabefelds:", self.entry.get())
        self.eingabe.set("")


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Magische Verbindung")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
