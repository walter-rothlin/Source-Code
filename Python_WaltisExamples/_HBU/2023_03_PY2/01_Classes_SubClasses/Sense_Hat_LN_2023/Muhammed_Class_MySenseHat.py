#!/usr/bin python3

from sense_hat import SenseHat


class MySenseHat(SenseHat):
    def __init__(self):
        super().__init__()

    def set_pixel(self, x, y, color):
        # Umwandlung von x und y in Ganzzahlen, falls nötig
        try:
            x = int(round(float(x)))
            y = int(round(float(y)))
        except ValueError:
            print(f"Fehler: x und y müssen numerische Werte sein. Erhalten: x={x}, y={y}")
            return

        # Überprüfung der Grenzen
        if 0 <= x < 8 and 0 <= y < 8:
            super().set_pixel(x, y, color)
            # print(f"Erhalten: x={x}, y={y}, Farbe={color}")
        else:
            print(f"Fehler: x und y müssen innerhalb der Grenzen 0-7 liegen. Erhalten: x={x}, y={y}")

    # def draw_line(self, start_point, end_point, color):
    def draw_line(self, x0, y0, x1, y1, color):
        # x0, y0 = start_point
        # x1, y1 = end_point
        # print(f"Erhalten: x0={x0}, y0={y0}, x1={x1}, y1={y1}, Farbe={color}")
        # Vertikale Linie
        if x0 == x1:
            for y in range(min(y0, y1), max(y0, y1) + 1):
                self.set_pixel(x0, y, color)
            return

        # Lineare Funktion: y = ax + b
        a = (y1 - y0) / (x1 - x0)
        b = y0 - a * x0

        # Zeichnen der Linie
        if abs(a) <= 1:
            for x in range(min(x0, x1), max(x0, x1) + 1):
                y = int(a * x + b)
                self.set_pixel(x, y, color)
        else:
            for y in range(min(y0, y1), max(y0, y1) + 1):
                x = int((y - b) / a)
                self.set_pixel(x, y, color)

    def sense_hat_clearen(self):
        input("Drücken Sie die Eingabetaste, um fortzufahren...")
        my_sense.clear()


# Hauptprogramm
if __name__ == "__main__":

    my_sense = MySenseHat()

    # Setzen eines Pixels auf rot Aufgabe 1.1
    print("Setzen eines Pixels auf rot Aufgabe 1.1")
    try:
        my_sense.set_pixel(4, 5, (255, 0, 0))  # Rot
    except Exception as e:
        print(f"Fehler beim Setzen des roten Pixels: {e}")

    my_sense.sense_hat_clearen()
    # Versuch, einen Pixel ausserhalb des gültigen Bereichs auf grün zu setzen Aufgabe 1.2
    print("Versuch, einen Pixel ausserhalb des gültigen Bereichs auf grün zu setzen Aufgabe 1.2")
    try:
        my_sense.set_pixel(8, 5, (0, 255, 0))  # Grün
    except Exception as e:
        print(f"Fehler beim Setzen des grünen Pixels: {e}")
    my_sense.sense_hat_clearen()

    # Testfälle für Aufgabe 2.1
    print("Testfälle für Aufgabe 2")
    my_sense.set_pixel(2, 5, [255, 0, 0])  # Korrekte Werte
    my_sense.sense_hat_clearen()
    my_sense.set_pixel(6.7, 5.3, [0, 255, 0])  # Dezimalzahlen
    my_sense.sense_hat_clearen()
    my_sense.set_pixel(8.7, 5.3, [0, 255, 0])  # Dezimalzahlen, ausserhalb gültigen Bereichs
    my_sense.sense_hat_clearen()
    my_sense.set_pixel("3", "4", [0, 0, 255])  # String-Werte
    my_sense.sense_hat_clearen()
    my_sense.set_pixel("a", "b", [255, 255, 0])  # Ungültige String-Werte
    my_sense.sense_hat_clearen()

    print("Testfälle für Aufgabe 3")
    my_sense.draw_line((0, 0), (7, 7), [255, 0, 0])  # Diagonale Linie
    my_sense.sense_hat_clearen()
    my_sense.draw_line((3, 0), (3, 7), [0, 255, 0])  # Vertikale Linie
    my_sense.sense_hat_clearen()
    my_sense.draw_line((0, 1), (7, 5), [0, 0, 255])  # Andere Linie
    my_sense.sense_hat_clearen()