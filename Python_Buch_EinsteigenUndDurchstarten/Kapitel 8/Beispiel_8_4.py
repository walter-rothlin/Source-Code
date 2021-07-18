"""Ein paar Berechnungsfunktionen"""


def addieren(wert_a, wert_b):
    """Liefert die Summe der übergebenen Werte zurück"""
    return wert_a + wert_b


def subtrahieren(wert_a, wert_b):
    """Liefert die Differenz der übergebenen Werte zurück"""
    return wert_a - wert_b


# Hauptprogramm
def main():
    """Überprüfen, ob die Berechnungen korrekt sind"""
    if addieren(3, 11) == 14 and subtrahieren(15, 10) == 5:
        print("Berechnungen liefern die erwarteten Ergebnisse!")
    else:
        print("Quellcode überprüfen, etwas stimmt nicht!")


# main nur aufrufen, wenn nicht als Modul importiert
if __name__ == "__main__":
    main()
