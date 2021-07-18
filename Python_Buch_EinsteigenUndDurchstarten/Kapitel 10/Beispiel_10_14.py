# Beispiel 10.14
#
# Lösung zur Aufgabenstellung
#
import tkinter as tk


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        antworten = [("Jederzeit, mein absoluter Favorit!", 4),
                     ("Ja, wenn es nicht zu viel Umweg ist", 3),
                     ("Falls es nichts günstigeres gibt, gern", 2),
                     ("Ich sehe erstmal, wie die anderen Hotels sind", 1),
                     ("Nein! Unter der Autobahnbrücke ist es gemütlicher!", 0)]

        # Es gibt nur eine einzige Kontrollvariable
        self.ergebnis = tk.IntVar()
        self.ergebnis.set(4)

        # Radiobuttons erzeugen
        for text, wertung in antworten:
            radiobutton = tk.Radiobutton(self, text=text)
            radiobutton["variable"] = self.ergebnis
            radiobutton["value"] = wertung
            radiobutton.pack(anchor="w")

        self.label = tk.Label(self, text="----------------------------")
        self.label.pack()

        self.label = tk.Label(self, text="Dürfen wir Ihre Daten weitergeben?")
        self.label.pack(anchor="w")

        self.datenweitergabe = tk.BooleanVar()
        self.radio1 = tk.Radiobutton(self, text="Ja, sicher")
        self.radio1["variable"] = self.datenweitergabe
        self.radio1["value"] = True
        self.radio1.pack(anchor="w")

        self.radio2 = tk.Radiobutton(self, text="Nein, natürlich nicht")
        self.radio2["variable"] = self.datenweitergabe
        self.radio2["value"] = False
        self.radio2.pack(anchor="w")

        self.button = tk.Button(self, text="Umfrage beenden", command=self.click)
        self.button.pack()

    def click(self):
        print("Sie haben uns {0} Sterne verliehen".format(self.ergebnis.get()))
        print("Vielen Dank für die Teilnahme!")

        if self.datenweitergabe.get():
            print("Sie haben der Datenweitergabe zugestimmt")
        else:
            print("Ihre Daten werden nicht weitergegeben")


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Würden Sie unser Hotel wieder besuchen?")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
