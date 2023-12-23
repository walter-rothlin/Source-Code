from sense_hat import SenseHat

class MySenseHat(SenseHat):
    def __init__(self):
        super().__init__()
        try:
            self.sense.get_imu()
        except AttributeError:
            print("Farbsensor nicht vorhanden")
    def clear_pixels(self):
        for x in range(8):
            for y in range(8):
                self.set_pixel(x, y, 0, 0, 0)

    def set_pixel(self, x, y, r, g, b):
        if isinstance(x, str) and isinstance(y, str):
            try:
                x = int(x)
                y = int(y)
            except ValueError:
                print("Fehler: Ungültige Eingabe für x und y")
                return
        elif isinstance(x, float) and isinstance(y, float):
            x = round(x)
            y = round(y)

        if x < 0 or x >= 8 or y < 0 or y >= 8:
            print("Fehler: Pixel außerhalb des Bereichs")
            return

        super().set_pixel(x, y, r, g, b)

    def draw_line(self, start_x, start_y, end_x, end_y):
        # Konvertiere alle Eingaben zuerst in Integers
        try:
            start_x = int(float(start_x))
            start_y = int(float(start_y))
            end_x = int(float(end_x))
            end_y = int(float(end_y))
        except ValueError:
            print("Fehler: Ungültige Eingabe für Start- und Endpunkte")
            return

        # Berechne die Steigung a
        if end_x != start_x:  # Vermeide Division durch Null
            a = (end_y - start_y) / (end_x - start_x)
        else:
            a = float('inf')  # Unendliche Steigung für vertikale Linie

        # Zeichne die Linie basierend auf der Steigung
        if abs(a) <= 1:
            step = 1 if start_x <= end_x else -1
            for x in range(start_x, end_x + step, step):
                # Grosse Auflösung. Erst rechnen, dann Runden...
                y = round(a * (x - start_x) + start_y)
                if 0 <= x < 8 and 0 <= y < 8:
                    self.set_pixel(x, y, 255, 255, 255)
        else:
            step = 1 if start_y <= end_y else -1
            for y in range(start_y, end_y + step, step):
                if a != float('inf'):
                    x = round((y - start_y) / a + start_x)
                else:
                    x = start_x  # Für vertikale Linien bleibt x konstant
                if 0 <= x < 8 and 0 <= y < 8:
                    self.set_pixel(x, y, 255, 255, 255)

def main():
    sense = MySenseHat()
    sense.clear_pixels()
    ######   Testcases!
    # Normaler Pixel ohne Fehler
    sense.set_pixel(4, 5, 255, 0, 0)
    # Ausserhalb des Bereichs
    sense.set_pixel(8, 5, 0, 255, 0)
    # Strings akzeptieren
    sense.draw_line(2, -1, "6", "10")
    # Dezimalzahlen verarbeiten
    sense.draw_line(3.5, -2.5, 7, 11)
    # Spasseshalber eine Diagonale
    sense.draw_line(0, 0, 7, 7)
    # Division by Zero abgesichert
    sense.draw_line(0, 7, 0, 7)

if __name__ == "__main__":
    main()
