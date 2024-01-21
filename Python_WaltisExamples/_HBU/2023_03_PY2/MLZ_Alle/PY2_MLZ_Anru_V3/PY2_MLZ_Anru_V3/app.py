from flask import Flask, render_template, Response, jsonify, request
import json
import re
import socket
import getpass

import requests
from Class_SenseHat import MySenseHat

app = Flask(__name__)
sense_hat = MySenseHat()
api_key = '6e91edcdce1d08917dfeaebccc7b3db1'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/data', methods=['GET', 'POST'])
def data():
    imu_data = sense_hat.get_orientation()
    roll_data = str(imu_data['roll'])
    pitch_data = str(imu_data['pitch']) 
    yaw_data = str(imu_data['yaw'])
    print(yaw_data)       
    return render_template('data.html', roll_data=roll_data, pitch_data=pitch_data, yaw_data=yaw_data)

@app.route('/led-status')
def led_status():
    pixels = sense_hat.get_pixels()
    matrix = [pixels[i:i+8] for i in range(0, len(pixels), 8)]
    return jsonify(matrix)


@app.route('/set-led', methods=['GET'])
def set_led():
    sense_hat.clear()  # Schaltet alle LEDs aus
    return render_template('set_led.html')


@app.route('/set-color', methods=['POST'])
def set_color():
    led_colors = request.get_json()
    for led in led_colors:
        x = int(led['x'])
        y = int(led['y'])
        css_color = led['color']
        
        if css_color == 'clear':
            sense_hat.set_pixel(x, y, 0, 0, 0)
        else:
            rgb = parse_rgb_color(css_color)
            if rgb:
                sense_hat.set_pixel(x, y, *rgb, pixel_color=None)

    return jsonify({"message": "LEDs aktualisiert"})

@app.route('/meteo', methods=['GET', 'POST'])
def meteo():
    if request.method == 'POST':
        city = request.form['city']
        url = f'http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric'
        response = requests.get(url)

        if response.ok:
            weather = response.json()
            temperature = weather['main']['temp']
            sense_hat.show_message(f"{city}: {round(temperature,1)} C", scroll_speed=0.1)
            return render_template('meteo.html', weather=f"{city}: {round(temperature,1)} C")
        else:
            error_message = "Stadt nicht gefunden oder API-Anfrage fehlgeschlagen."
            sense_hat.show_message(error_message, scroll_speed=0.1)
            return render_template('meteo.html', weather=error_message)
        
    return render_template('meteo.html')

@app.route('/text', methods=['GET', 'POST'])
def text():
    if request.method == 'POST':
        text_to_show = request.form['text']
        sense_hat.show_message(text_to_show, scroll_speed=0.08)

        return jsonify({"message": "Text wurde angezeigt."})

    return render_template('text.html')

@app.route('/loeschen')
def loeschen():
    sense_hat.clear()
    pixels = sense_hat.get_pixels()
    matrix = [pixels[i:i+8] for i in range(0, len(pixels), 8)]
    return jsonify(matrix)

@app.route('/status')
def status():
    hostname = socket.gethostname()
    user = getpass.getuser()
    ip = socket.gethostbyname(hostname)

    status_info = {
        'hostname': hostname,
        'user': user,
        'ip': ip
    }

    status_json = json.dumps(status_info)
    return Response(status_json, mimetype='application/json')

     
def parse_rgb_color(rgb_string):
    match = re.match(r'rgb\((\d+),\s*(\d+),\s*(\d+)\)', rgb_string)
    if match:
        return (int(match.group(1)), int(match.group(2)), int(match.group(3)))
    else:
        return None

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5029)