# Beispiel 10.11
#
# Textboxen
#
import tkinter as tk


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        # Textbox erzeugen
        self.textbox = tk.Text(self, width=40, height=10, wrap=tk.WORD,
                               font="Courier 18 bold", bg="blue", fg="white")

        # Ein wenig Text einfügen
        self.textbox.insert("0.0", "Wasser\nToastbrot\nWurst\nEier\n")
        self.textbox.insert("4.0", "Roggenbrot\n")
        self.textbox.insert(tk.END, "Ende der Einkaufsliste")

        self.textbox.pack()

        # Steuerelemente für Textsuche erzeugen
        self.eingabe = tk.Entry(self)
        self.eingabe.pack(side="left")

        self.button = tk.Button(self, text="Suchen", command=self.suchen)
        self.button.pack()

    def suchen(self):
        # Text suchen
        start = "0.0"
        suchtext = self.eingabe.get()
        print("Suche nach", suchtext)

        while True:
            # So lange suchen, bis kein Ergebnis mehr geliefert wird
            pos = self.textbox.search(suchtext, start, stopindex=tk.END)

            if not pos:
                break

            # Nach der Fundstelle weitersuchen
            start = pos + "+1c"

            print("Gefunden an Position:", pos)

        print("Suche beendet")


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Textboxen")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
