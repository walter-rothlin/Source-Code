from flask import Flask, jsonify, request, render_template_string, url_for
from sense_hat import SenseHat
from flasgger import Swagger
import socket
import os

app = Flask(__name__)
sense = SenseHat()
swagger = Swagger(app)

template_str = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LED Controller</title>
</head>
<body>
    <h1>Index Page</h1>
    <p><a href="/apidocs/">API Dokumentation</a></p>
    <p><a href="{{ status_url }}">Status Page</a></p>
    <p><a href="{{ led_status_url }}">LED Status Page</a></p>
    <form onsubmit="setLED(); return false;">
        <label for="x">X Coordinate:</label>
        <input type="number" id="x" name="x" min="0" max="7"><br><br>

        <label for="y">Y Coordinate:</label>
        <input type="number" id="y" name="y" min="0" max="7"><br><br>

        <label for="r">Red:</label>
        <input type="number" id="r" name="r" min="0" max="255"><br><br>

        <label for="g">Green:</label>
        <input type="number" id="g" name="g" min="0" max="255"><br><br>

        <label for="b">Blue:</label>
        <input type="number" id="b" name="b" min="0" max="255"><br><br>

        <input type="submit" value="Setze das Pixel"><br><br><br><br>
    </form>
    <form onsubmit="clearLEDs(); return false;">
        <label for="clr-r">Red:</label>
        <input type="number" id="clr-r" name="clr-r" min="0" max="255" value="0"><br><br>

        <label for="clr-g">Green:</label>
        <input type="number" id="clr-g" name="clr-g" min="0" max="255" value="0"><br><br>

        <label for="clr-b">Blue:</label>
        <input type="number" id="clr-b" name="clr-b" min="0" max="255" value="0"><br><br>

        <input type="submit" value="Alle LEDs setzen"><br><br><br><br>
    </form>
    <form onsubmit="showMessage(); return false;">
        <label for="msg-text">Mitteilung:</label>
        <input type="text" id="msg-text" name="msg-text"><br><br>

        <label>Textfarbe:</label>
        R <input type="number" id="msg-text-color-r" name="msg-text-color-r" min="0" max="255" value="255">
        G <input type="number" id="msg-text-color-g" name="msg-text-color-g" min="0" max="255" value="255">
        B <input type="number" id="msg-text-color-b" name="msg-text-color-b" min="0" max="255" value="255"><br><br>

        <label>Hintergrundfarbe:</label>
        R <input type="number" id="msg-back-color-r" name="msg-back-color-r" min="0" max="255">
        G <input type="number" id="msg-back-color-g" name="msg-back-color-g" min="0" max ="255">
        B <input type= "number"id =" msg-back -color-b"name =" msg-back -color-b "min =" 0 "max =" 255 "><br><br>

    < label for= " msg-speed ">Scroll Geschwindigkeit (0.1 langsam - 1.0 schnell):</label>
    <input type= "range"id =" msg-speed"name =" msg-speed "min =" 0.1 "max =" 1.0 "step =" 0.1"value =" 0.1 "><br><br>

    <input type= "submit"value ="Text anzeigen">
    </form>

    <script>
    function setLED() {
        var x = document.getElementById('x').value;
        var y = document.getElementById('y').value;
        var r = document.getElementById('r').value;
        var g = document.getElementById('g').value;
        var b = document.getElementById('b').value;

        fetch('/set-led', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ x: parseInt(x), y: parseInt(y), r: parseInt(r), g: parseInt(g), b: parseInt(b) }),
        })
        .then(response => response.json())
        .then(data => console.log(data))
        .catch((error) => {
            console.error('Error:', error);
        });
    }
    function clearLEDs() {
        var r = document.getElementById('clr-r').value;
        var g = document.getElementById('clr-g').value;
        var b = document.getElementById('clr-b').value;

        fetch('/clear-leds', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ r: parseInt(r), g: parseInt(g), b: parseInt(b) }),
        })
        .then(response => response.json())
        .then(data => console.log(data))
        .catch((error) => {
            console.error('Error:', error);
        });
    }
    function showMessage() {
        var text = document.getElementById('msg-text').value;
        var r = document.getElementById('msg-text-color-r').value;
        var g = document.getElementById('msg-text-color-g').value;
        var b = document.getElementById('msg-text-color-b').value;
        var br = document.getElementById('msg-back-color-r').value;
        var bg = document.getElementById('msg-back-color-g').value;
        var bb = document.getElementById('msg-back-color-b').value;
        var speed = parseFloat(document.getElementById('msg-speed').value);

        fetch('/show-message', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                text: text,
                text_color: [parseInt(r), parseInt(g), parseInt(b)],
                back_color: [parseInt(br), parseInt(bg), parseInt(bb)],
                speed: speed
            }),
        })
        .then(response => response.json())
        .then(data => console.log(data))
        .catch((error) => {
            console.error('Error:', error);
        });
    }
    </script>
</body>
</html>
'''

@app.route('/')
def index():
    """
    Startseite
    ---
    responses:
      200:
        description: Übersicht der verfügbaren Aktionen.
    """
    status_url = url_for('status', _external=True)
    led_status_url = url_for('led_status', _external=True)
    set_led_url = url_for('set_led', _external=True)  # Beispiel-URL ohne Parameter
    return render_template_string(template_str, status_url=status_url, led_status_url=led_status_url)

@app.route('/status')
def status():
    """
    Hostinformationen
    ---
    responses:
      200:
        description: Zeigt hostname, user und ip an.
    """
    hostname = socket.gethostname()
    user = os.getenv('USER')  # oder os.getlogin() je nach Systemkonfiguration
    ip_address = socket.gethostbyname(hostname)

    return jsonify({
        'hostname': hostname,
        'user': user,
        'ip': ip_address
    })

@app.route('/led-status')
def led_status():
    """
    LED-Status
    ---
    responses:
      200:
        description: Status der LEDs als JSON.
    """
    pixels = sense.get_pixels()
    return jsonify(pixels)

@app.route('/set-led', methods=['POST'])
def set_led():
    """
    Einzelnes LED setzen
    ---
    responses:
      200:
        description: Setzt ein einzelnes LED gemäss Input.
    """
    data = request.get_json()

    x = data.get('x', 0)
    y = data.get('y', 0)
    r = data.get('r', 0)
    g = data.get('g', 0)
    b = data.get('b', 0)

    if None in (x, y, r, g, b):
        return jsonify({'error': 'Setzen war nicht möglich.'}), 400

    try:
        sense.set_pixel(int(x), int(y), int(r), int(g), int(b))
        return jsonify(sense.get_pixels())
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/clear-leds', methods=['POST'])
def clear_leds():
    """
    Setzten aller LEDs
    ---
    responses:
      200:
        description: Alle LEDs in einer Farbe gemäss Input.
    """
    data = request.get_json()

    r = data.get('r', 0)
    g = data.get('g', 0)
    b = data.get('b', 0)

    try:
        # Alle Pixel durchlaufen
        for x in range(8):
            for y in range(8):
                sense.set_pixel(x, y, int(r), int(g), int(b))
        return jsonify(sense.get_pixels())
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/show-message', methods=['POST'])
def show_message():
    """
    Mitteilung Scrollen
    ---
    responses:
      200:
        description: Funktioniert leider noch nicht wie erwartet.
    """
    data = request.get_json()

    text = data.get('text', '')
    text_color = data.get('text_color', [255, 255, 255])
    back_color = data.get('back_color', [0, 0, 0])
    speed = data.get('speed', 0.1)

    try:
        sense.show_message(text, text_colour=text_color, back_colour=back_color, scroll_speed=speed)
        return jsonify({'status': 'Message displayed'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)