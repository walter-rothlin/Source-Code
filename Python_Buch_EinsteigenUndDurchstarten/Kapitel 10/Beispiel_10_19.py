# Beispiel 10.19
#
# Dialogfenster
#
import tkinter as tk
from tkinter import messagebox


# Klasse für die Anwendung
class App(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        # Zwei Buttons zu Demonstrationszwecken hinzufügen
        self.button1 = tk.Button(self, text="Abfrage 1", command=self.btn1_click)
        self.button1.pack()

        self.button2 = tk.Button(self, text="Abfrage 2", command=self.btn2_click)
        self.button2.pack()

    def btn1_click(self):
        # Anzeigen eines Dialogfensters mit "Ja, Nein, Abbruch"
        ergebnis = tk.messagebox.askyesnocancel(title="Vorsicht!",
                                                message="Aktion durchführen?",
                                                icon=tk.messagebox.WARNING)
        print("Ergebnis: ", ergebnis)

    def btn2_click(self):
        # Anzeigen eines Dialogfensters mit "Abbruch, Wiederholen, Ignorieren"
        ergebnis = tk.messagebox.showerror(title="Fehler!",
                                           message="Schwerer Fehler aufgetreten!",
                                           type=tk.messagebox.ABORTRETRYIGNORE,
                                           default=tk.messagebox.RETRY)
        print("Ergebnis: ", ergebnis)


# Hauptprogramm
def main():
    # Fenster erstellen und Titel festlegen
    root = tk.Tk()
    root.title("Messageboxen")
    root.resizable(False, False)

    # Instanz der App-Klasse erzeugen und ins Fenster packen
    app = App(root)
    app.pack()

    root.mainloop()


main()
