#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Class_MySenseHat.py
# 
#
# Description: SUB-CLASS OF SENSE (HAT) / Teilprüfung 2
#
#
# Autor: Emanuel Wettstein
#
# History:
# 11.12.2023, 18:00 - Erstelle File, Import SenseHat
# 11.12.2023, 18:20 - Neue Klasse namens MySenseHat, die von der SenseHat-Klasse abgeleitet ist. 
# 11.12.2023, 18:25 - Integration roter Punkt
# 11.12.2023, 18:40 - Integration grüner Punkt  mit Try and Error.
# 11.12.2023, 19:00 - Überarbeitung der set_pixel Methode mit Grenzüberprüfung und Konvertierungsfunktionen.
# 11.12.2023, 19:30 - Anzeigen einer Meldung auf dem Sense HAT-Display.
# 11.12.2023, 19:40 - Integration Test.
# 11.12.2023, 19:55 - Integration Berrechnung Draw aus CHATGPT. Probleme...Division/0
# 11.12.2023  20:00 - Defineren einiger Tests für Draw auf Senshat Display
# 11.12.2023  20:10 - Test und Codcleaning
#
# ------------------------------------------------------------------
import time
from sense_hat import SenseHat

class MySenseHat(SenseHat):
    def __init__(self):
        super().__init__()

    def set_pixel(self, x, y, r, g, b):
        # Überprüft ob x und y Dezimalzahlen oder Strings sind, ansonsten wird as konvertiert
        # print(f'calling set_pixel(self, {x}, {y}, {r}, {g}, {b})')
        try:
            x = round(float(x))
            y = round(float(y))
            r = round(float(r))
            g = round(float(g))
            b = round(float(b))
        except ValueError:
            error_message = "Fehler x- und y-Werte müssen als Dezimalzahlen oder als Strings übergeben werden."
            print(error_message)
            ## self.show_message(error_message)
            return

        # Überprüft ob x und y innerhalb der Grenze
        if not (0 <= x < 8 and 0 <= y < 8):
            error_message = "Fehler: Die x- und y-Werte müssen im Range von 0 bis 7 liegen."
            print(error_message)
            ## self.show_message(error_message)
            return

        # Setze das Pixel, wenn die Überprüfungen erfolgreich waren
        # print(f'calling super().set_pixel(self, {x}, {y}, {r}, {g}, {b})')
        super().set_pixel(x, y, r, g, b)

    def display_error_message(self, message):
        # Zeigt eine Nachricht auf dem Senshat-Display
        print(message)

    def draw_line(self, x1, y1, x2, y2, r, g, b):
        # Überprüft die Start- und Endpunkte innerhalb der Grenzen liegen
        ##if not (0 <= x1 < 8 and 0 <= y1 < 8 and 0 <= x2 < 8 and 0 <= y2 < 8):
        ##    raise ValueError("Die Start- und Endpunkte müssen im Bereich von 0 bis 7 liegen.")

        # RGB-Werte gültig sind und wandeln Sie sie in ganze Zahlen um
        r = round(r)
        g = round(g)
        b = round(b)

        # Berechnet die Steigung der Linie (a) und den y (b)
        if x1 == x2:
            # Vertikale Linie
            for y in range(min(y1, y2), max(y1, y2) + 1):
                # print('FEHLER (1): super().set_pixel(x1, y, r, g, b)')
                self.set_pixel(x1, y, r, g, b)
        else:
            a = (y2 - y1) / (x2 - x1)
            b = y1 - a * x1

            # Zeichnen Sie die Linie
            for x in range(min(x1, x2), max(x1, x2) + 1):
                y = a * x + b
                # print('FEHLER (2): super().set_pixel(x, y, r, g, b)')
                self.set_pixel(x, y, r, g, b)

if __name__ == "__main__":
    def test_my_sense_hat():
        my_sense_hat = MySenseHat()

        # Test1: Setzt eines Pixels innerhalb der Grenzen
        my_sense_hat.set_pixel(3, 4, 255, 0, 0)
        pixel_color = my_sense_hat.get_pixel(3, 4)
        expected_color = [255, 0, 0]
        if pixel_color != expected_color:
            print("Test 1 fehlgeschlagen: Erwartet:", expected_color, "erhalten:", pixel_color)

        # Test2: Setzen eines Pixels außerhalb der Grenze
        try:
            my_sense_hat.set_pixel(8, 5, 0, 255, 0)
            print("Test 2 fehlgeschlagen: Pixel außerhalb der Grenzen")
        except ValueError as e:
            expected_error_message = "Fehler: Die x- und y-Werte müssen im Bereich von 0 bis 7 liegen."
            if str(e) != expected_error_message:
                print("Test 2 fehlgeschlagen: Erwartet:", expected_error_message, "erhalten:", str(e))

        # Test3: Anzeige einer Fehlermeldung
        my_sense_hat.display_error_message("Das ist ein Fehler.")
        time.sleep(5) 

    my_sense_hat = MySenseHat()

    # Pixel auf rot stetzen
    my_sense_hat.set_pixel(4, 5, 255, 0, 0)

    # Warten bis weiter
    delay_seconds = 3
    start_time = time.time()

    while True:
        current_time = time.time()
        elapsed_time = current_time - start_time

        if elapsed_time >= delay_seconds:
            break  # Verlasse die Schleife nach Timeout

    try:
        # Versucht das Pixel (8, 5) auf Grün zu setzen (-> Fehler)
        my_sense_hat.set_pixel(8, 5, 0, 255, 0)
    except ValueError as e:
        error_message = str(e)  # Erfasse die Fehlermeldung als String
        print("Fehler beim Setzen des Pixels:", error_message)

        # Zeige die Fehlermeldung auf dem Sense HAT-Display an
        my_sense_hat.display_error_message("Fehler: " + error_message)


    # Löscht das Display
    my_sense_hat.clear()

  # Führe die Tests aus
    test_my_sense_hat()

    # Zeichnet eine horizontale Linie von (0, 3) nach (7, 3) in Rot
    my_sense_hat.draw_line(0, 3, 7, 3, 255, 0, 0)
    time.sleep(5)

    # Zeichnet eine vertikale Linie von (4, 0) nach (4, 7) in Grün
    my_sense_hat.draw_line(4, 0, 4, 7, 0, 255, 0)
    time.sleep(5)

    # Zeichnet eine Linie von (1, 1) nach (6, 6) in Blau
    my_sense_hat.draw_line(1, 1, 6, 6, 0, 0, 255)
    time.sleep(6)

    # Löscht das Display am Schluss
    my_sense_hat.clear()