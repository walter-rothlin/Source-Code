#!/usr/bin/python3
# ----------------------------------------------------------------------------
# Name: FlaskApp.py
# 
# Descripton: MLZ Flask / Rest API
# Autor: Emanuel Wettstein
# 
# History: 18:00 - Anlage Flask Ordner-Strukturen (static / templates)
#          18:05 - Erstellung styles.css, index.html
#          *************Aufgabe 2
#          18:25 - Erstellen neuer App_Route / Import Flask, weitere Import-Anpassungen (jsonify etc.)
#          18:48 - Anpsssung der App_Route nach Testing display_status_json.html. Egänzung Mac/WLAN Adresse
#          18:50 - Testen der Funktion abgeschlossen
#          *************Aufgabe 3
#          18:55 - Integration APP_Route für JSON Abfrage RGB LED. Testing 
#          19:10 - Egänzung Koordinaten und RGB Werte in JSON (R,G,B). Testing der Funktion
#          19:15 - Egänzung Navigation auf index.html
#          19:16 - Testen der Funktion abgeschlossen
#          *************Aufgabe 4
#          19:20 - Egänzung neuer App Route, Integration HTML Seite "pixel_designer" für Abruf der LedPixel
#          19:25 - Integraton und Prüfung der Funktion / Anzeige Pixel auf Rasperry und Web
#          19:30 - Ergänzug/Erweiterung der Menüstruktur(en) und html-Nav
#          19:35 - Egänzung Export JSON / Button und Absprünge auf pixel_designer.html
#          19:45 - Setzen von Initalwerte für den Grid 8x8
#          19:55 - Testen der Funktion abgeschlossen
#          *************Aufgabe 5
#          20:00 - Egänzung neuer App Route, Integration HTML Seite "choose_color" für Abruf/Anzeige der Grundfarben
#          20:10 - Integraton und Prüfung der Funktion(en) / Anzeige Farbe im Raster 8x8 auf Rasperry und Web
#          20:15 - Ergänzug/Erweiterung der Menüstruktur(en) und html-Nav
#          20:17 - Egänzung Export JSON / Button und Absprünge auf coose_color.html
#          20:25 - Setzen von Initalwerte für die Grundfarben
#          20:30 - Testen der Funktion abgeschlossen
#          *************Aufgabe 6
#          20:31 - Egänzung neuer App Route, Integration HTML Seite "display_textinput" für Eingabe des Scroll-Textes
#          20:35 - Integraton und Prüfung der Funktion(en) / Anzeige Inputtext. Testing
#          20:40 - Ergänzung Scrollgeschwindigkeit/Wiederholung. Test erfolgreich.
#          20:43 - Ergänzug/Erweiterung der Menüstruktur(en) und html-Nav
#          20:45 - Testen der Funktion abgeschlossen 
#          *************Aufgabe 7 / 8
#          20:50 - Egänzung neuer App Route, Integration HTML Seite "display_sensordata" für Anzeige Meteo + Bewegungsdaten Rasperry
#          20:55 - Integraton und Prüfung der Funktion(en). Mathematische Formeln für Bewegungssensoren gemäss ChatGPT
#          21:10 - Ergänzung Chekbox für Anzeige Raspberry / Scrollgeschwindigkeit Default 0.5. Test erfolgreich.
#          21:15 - Ergänzug/Erweiterung der Menüstruktur(en) und html-Nav
#          21:20 - Testen der Funktion abgeschlossen 
#          *************TESTING / CODECLEANSING
#          21:21 - Testen alle Funktionen
#          21:23 - WLAN-Adresse mit "\n"....Befehl strip: Anpassung der Funktion.
#          21:30 - CodeCleansing    
#          21:40 - Abgabe Arbeit MLZ
# --------------------------------------------------------------------
from flask import Flask, render_template, request, redirect, url_for
from flask.json import jsonify
from sense_hat import SenseHat
from datetime import datetime  
import socket
import subprocess

app = Flask(__name__)
sense = SenseHat()

#----Initialisierungswerte---------------
# Display. Generell inaktiv.
display_enabled = False  

# Farbauswahl
ledRed_status = "OFF"
ledYellow_status = "OFF"
ledGreen_status = "OFF"

# Pixel-Designer
grid_size = 8
grid = [[(255, 255, 255) for _ in range(grid_size)] for _ in range(grid_size)]

#----END Initialisierungswerte---------------

#-> MLZ Aufgabe 2
@app.route('/display_status', methods=['GET'])
def display_status():
    # Benutzer, Hostname, IP (Host)
    ip_address = socket.gethostbyname(socket.gethostname())
    username = subprocess.getoutput('whoami')
    hostname = socket.gethostname()

   # WLAN-IP-Adresse Rasperry
    try:
        wlan_ip = subprocess.check_output(["hostname", "-I"]).strip().decode("utf-8")
    except subprocess.CalledProcessError:
        wlan_ip = "IP-Adresse nicht gefunden"

    # MAC-Adresse Rasperry
    try:
        mac_address = open('/sys/class/net/eth0/address').read().strip()  # Hier wird strip() hinzugefügt
    except FileNotFoundError:
        mac_address = "MAC-Adresse nicht gefunden"

    # JSON
    status_info = {
        'IP': ip_address,
        'User': username,
        'Hostname': hostname,
        'WLAN_IP': wlan_ip,
        'MAC_Address': mac_address,
    }
    return jsonify(status_info)

#-> MLZ Aufgabe 3
from flask import jsonify

@app.route('/display_rgb_data', methods=['GET'])
def display_rgb_data():
    # Auslesen LED-Matrix pro Punkt, Auslesen x/y Koordinaten / SenseHat
    matrix_status = []
    for y in range(8):
        row = []
        for x in range(8):
            pixel = sense.get_pixel(x, y)
            row.append({"x": x, "y": y, "R": pixel[0], "G": pixel[1], "B": pixel[2]})
        matrix_status.append(row)
    # JSON
    return jsonify(matrix_status)

#-> MLZ Aufgabe 4 - Auswahl Pixel im PixelDesigner
@app.route('/pixel_designer', methods=['GET', 'POST'])
def pixel_designer():
    if request.method == 'POST':
        # Verarbeiten der Formulardaten und Aktualisieren des Rasters
        for i in range(8):
            for j in range(8):
                checkbox_name = f"pixel_{i}_{j}"
                if request.form.get(checkbox_name) == 'on':
                    grid[i][j] = (255, 0, 0)
                else:
                    grid[i][j] = (255, 255, 255)
        # Konvertieren 8x8-Rasters in eine flache Liste von Farbwerten
        flat_grid = [pixel for row in grid for pixel in row]
        # Aktualisieren des Sense HAT
        sense.set_pixels(flat_grid)

    return render_template('pixel_designer.html', grid=grid)

#-> MLZ Aufgabe 4 - Export aktuelle Auswahl im JSON-Format
@app.route('/export_pixels', methods=['GET'])
def export_pixels():
    selected_pixels = []

    for i in range(8):
        for j in range(8):
            if grid[i][j] == (255, 0, 0):
                selected_pixels.append({"row": i, "col": j, "color": [255, 0, 0]})

    return jsonify(selected_pixels)

#-> MLZ Aufgabe 5 - Wähle eine Grundfarbe, Anzeige Raspberry
@app.route("/choose_color", methods=["GET", "POST"])
def choose_color():
    global ledRed_status, ledYellow_status, ledGreen_status
    message = ""  # Variable für eine Nachricht an den Benutzer

    if request.method == "POST":
        ledRed_action = request.form.get("red")
        ledYellow_action = request.form.get("yellow")
        ledGreen_action = request.form.get("green")
        clear_action = request.form.get("clear")
        
        # Zählen, wie viele Farben auf ON gesetzt wurden
        on_count = sum([ledRed_action == "on", ledYellow_action == "on", ledGreen_action == "on"])

        if clear_action == "clear":
            sense.clear()
            ledRed_status, ledYellow_status, ledGreen_status = "OFF", "OFF", "OFF"
        elif on_count > 1:
            # Mehr als eine Farbe ist auf ON gesetzt, zeige eine Nachricht an
            message = "Bitte nur eine Farbe gleichzeitig einschalten."
        else:
            # Nur eine Farbe (oder keine) ist auf ON gesetzt, aktualisiere den Status
            ledRed_status = "ON" if ledRed_action == "on" else "OFF"
            ledYellow_status = "ON" if ledYellow_action == "on" else "OFF"
            ledGreen_status = "ON" if ledGreen_action == "on" else "OFF"

            if ledRed_status == "ON":
                sense.clear((255, 0, 0))
            elif ledYellow_status == "ON":
                sense.clear((255, 255, 0))
            elif ledGreen_status == "ON":
                sense.clear((0, 255, 0))
            else:
                sense.clear()

    templateData = {
        'title': 'Sense HAT LED Status',
        'ledRed': ledRed_status,
        'ledYellow': ledYellow_status,
        'ledGreen': ledGreen_status,
        'message': message  # Füge die Nachricht hinzu
    }
    return render_template('choose_color.html', active_page="choose_color", **templateData)

#-> MLZ Aufgabe 5 - Exportiere gewählte Punkte/Grundfarbe in der gewählten Grundfarbe als JSON
@app.route('/export_pixels_color', methods=['GET'])
def export_pixels_color():
    all_pixels = []

    for i in range(8):
        for j in range(8):
            pixel = {
                "row": i,
                "col": j,
                "color": grid[i][j]
            }
            all_pixels.append(pixel)

    return jsonify(all_pixels)

#-> MLZ Aufgabe 6 - Anzeige Displaytext Rasperry aufgrund Input, Geschwindigkeit, Wiederholung
@app.route("/display_textinput", methods=["GET", "POST"])
def display_textinput():
    message = ""
    if request.method == "POST":
        sense = SenseHat()
        text = request.form.get("text")
        speed = request.form.get("speed")
        # Wiederholung Auswahl / Default 1x, wenn keine Wiederholung angegeben wird oder wenn der Wert ungültig ist
        repeat = request.form.get("repeat", "1")
        try:
            repeat = int(repeat)
            if repeat < 1:
                repeat = 1
        except ValueError:
            repeat = 1

        # Integration Geschwindigkeitsmatrix: langsam, mittel, schnell
        speed_map = {"langsam": 0.1, "mittel": 0.05, "schnell": 0.01}
        scroll_speed = speed_map.get(speed, 0.05)

        # Text auf dem Sense HAT anzeigen
        for _ in range(repeat):
            sense.show_message(text, scroll_speed=scroll_speed)
        
        # Anzeige nach Ende im Web
        message = "Text wurde angezeigt."

    return render_template('display_textinput.html', active_page="display_textinput", message=message)


#-> MLZ Aufgabe 7 / 8 - Anzeige Meteodaten + Bewegung im Web + Rasperry
@app.route("/display_sensordata", methods=["GET", "POST"])
def display_sensordata():
    global display_enabled
    sensor_data = None
    sensor_name = ""
    timestamp = ""

    if request.method == "POST":
        selected_sensor = request.form.get("sensor")
        
        # Checkbox/Switch um Daten im Rasparry anzuzeigen
        if request.form.get("display_switch") == "on":
            display_enabled = True
        else:
            display_enabled = False

        # Sensordaten Meteo (Aufgabe 7. MLZ)
        if selected_sensor == "temperatur":
            sensor_data = round(sense.get_temperature(), 2)
            sensor_name = "Temperatur (°C)"
        elif selected_sensor == "luftfeuchtigkeit":
            sensor_data = round(sense.get_humidity(), 2)
            sensor_name = "Luftfeuchtigkeit (%)"
        elif selected_sensor == "druck":
            sensor_data = round(sense.get_pressure(), 2)
            sensor_name = "Luftdruck (hPa)"
        # Sensordaten Bewegung (Aufgabe 8. MLZ)
        elif selected_sensor == "beschleunigung":
            acceleration = sense.get_accelerometer_raw()
            sensor_data = f"x: {round(acceleration['x'], 2)} m/s², y: {round(acceleration['y'], 2)} m/s², z: {round(acceleration['z'], 2)} m/s²"
            sensor_name = "Beschleunigung (m/s²)"
        elif selected_sensor == "drehgeschwindigkeit":
            gyroscope = sense.get_gyroscope_raw()
            sensor_data = f"x: {round(gyroscope['x'], 2)} °/s, y: {round(gyroscope['y'], 2)} °/s, z: {round(gyroscope['z'], 2)} °/s"
            sensor_name = "Drehgeschwindigkeit (°/s)"
        elif selected_sensor == "orientierung":
            orientation = sense.get_orientation()
            sensor_data = f"Gier: {round(orientation['yaw'], 2)} °, Neigung: {round(orientation['pitch'], 2)} °, Rolle: {round(orientation['roll'], 2)} °"
            sensor_name = "Orientierung"
        elif selected_sensor == "neigung":
            orientation = sense.get_orientation()
            sensor_data = f"Neigung (Pitch): {round(orientation['pitch'], 2)} °, Rolle: {round(orientation['roll'], 2)} °"
            sensor_name = "Neigung"

        # Aktuelles Datum und die Uhrzeit beim Abruf
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        # Zeigen die Daten auf dem Raspberry Pi an, falls Checkbox gewählt, Scroll Speed ist = 0.5
        if display_enabled:
            message = f"{sensor_name}: {sensor_data}"
            sense.show_message(message, scroll_speed=0.05) 

    return render_template('display_sensordata.html', active_page="display_sensordata", sensor_data=sensor_data, sensor_name=sensor_name, timestamp=timestamp, display_enabled=display_enabled)

# Index.html / Anzeige aktuelles Datum in Fusszeile
@app.route("/", methods=["GET"])
def index():
    now = datetime.now()
    current_time = now.strftime("%d.%m.%Y %H:%M:%S")
    return render_template('index.html', current_time=current_time)

# Webhost starten / Port 5000
if __name__ == "__main__":
    app.run(debug=True, port=5000, host='0.0.0.0')
