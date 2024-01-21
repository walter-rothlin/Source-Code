from flask import Flask, request, redirect, url_for, session, render_template, jsonify
import socket
import os
import sys
import unittest
from MySenseHat import MySenseHat


class State():
    def __init__(self):
        print('State::__init__ called!')
        self.__req_count = 0

    def inc(self):
        self.__req_count += 1

    def get_reg_count(self):
        return str(self.__req_count)

app = Flask(__name__)
app.secret_key = 'geheimnis'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
sense = MySenseHat()

@app.route('/')
def index():
    state.inc()
    if session is not None and 'start_point' in session and session['start_point'] is not None:
        local_start_point = session['start_point']
        print('Session: local_start_point:', local_start_point)
    else:
        local_start_point = 'Kein start_point in Session defined'
        print('Session: Kein Start_point defined in Seesion')

    return f'''
    <HTML>
    <BODY>
    <H1>MLZ</H1>
    <A href="/status">Status</A><BR/><BR/>
    <A href="/led_status">led_status</A><BR/><BR/>
    <A href="/set_pixel">Set Pixel</A><BR/><BR/>
    <A href="/clear_led_matrix">Clear LED</A><BR/><BR/>
    <A href="/show_message">show message</A><BR/><BR/>
    <A href="/meteo">meteo</A><BR/><BR/>
    <A href="/imu_data">IMU Data</A><BR/><BR/>
    
    actual: {state.get_reg_count()}<BR/>
    start: {local_start_point}<BR/>
    </BODY>
    </HTML>
    '''

@app.route('/status')
def status():
    hostname = socket.gethostname()
    user = os.getenv('USER')
    ip_address = socket.gethostbyname(hostname)

    status_info = {
        "Hostname": hostname,
        "User": user,
        "IP": ip_address
    }

    return render_template('status.html', status_info=status_info)
    
@app.route('/led_status')
def led_status():
    pixels = sense.get_pixels()
    led_status_info = [pixels[i:i + 3] for i in range(0, len(pixels), 3)]

    return render_template('led_status.html', led_status_info=led_status_info)

@app.route('/set_pixel', methods=['GET', 'POST'])
def set_pixel():
    x = y = r = g = b = None
    led_status_info = []

    if request.method == 'POST':
        x = request.form.get('x')
        y = request.form.get('y')
        r = request.form.get('r')
        g = request.form.get('g')
        b = request.form.get('b')

        if None in (x, y, r, g, b):
            return jsonify({"error": "Missing data for x, y, r, g, b"}), 400

        sense.set_pixel(int(x), int(y), int(r), int(g), int(b))

        pixels = sense.get_pixels()
        led_status_info = [pixels[i:i + 3] for i in range(0, len(pixels), 3)]

    return render_template('set_pixel.html', x=x, y=y, r=r, g=g, b=b, led_status_info=led_status_info)

@app.route('/clear_led_matrix', methods=['GET', 'POST'])
def clear_led_matrix():
    led_status_info = []
    if request.method == 'POST':
        if request.is_json:
            data = request.json
            color = data.get('color', [0, 0, 0])
        else:
            color = [0, 0, 0]
       
        sense.clear(color)
        updated_pixels = sense.get_pixels()
        led_status_info = [updated_pixels[i:i + 3] for i in range(0, len(updated_pixels), 3)]
   
        return jsonify(led_status_info)
    
    return render_template('clear_led_matrix.html')

@app.route('/show_message', methods=['GET', 'POST'])
def show_message():
    if request.method == 'POST':
        data = request.form
        text = data.get('text', '')  # Default to empty string
        scroll_speed = float(data.get('scroll_speed', 0.1))  # Default scroll speed
        text_color = list(map(int, data.get('text_color', '255,255,255').split(',')))  # Default to white
        back_color = list(map(int, data.get('back_color', '0,0,0').split(',')))  # Default to black

        sense.show_message(text, scroll_speed=scroll_speed, text_colour=text_color, back_colour=back_color)

        message = f"Message displayed: {text}"
        return render_template('show_message.html', message=message)
    
    return render_template('show_message.html')
    
@app.route('/meteo')
def meteo():
    temperature = sense.get_temperature()
    humidity = sense.get_humidity()
    pressure = sense.get_pressure()

    meteo_data = {
        "temperature": round(temperature, 2),
        "humidity": round(humidity, 2),
        "pressure": round(pressure, 2)
    }

    return render_template('meteo.html', temperature=meteo_data["temperature"],
                           humidity=meteo_data["humidity"], pressure=meteo_data["pressure"])

    
@app.route('/imu_data')
def imu_data():
    orientation = sense.get_orientation() 
    accelerometer = sense.get_accelerometer_raw() 
    gyroscope = sense.get_gyroscope_raw()

    imu_data = {
        "orientation": orientation,
        "acceleration": accelerometer,
        "gyroscope": gyroscope
    }
    return render_template('imu_data.html', orientation=imu_data["orientation"],
                           acceleration=imu_data["acceleration"], gyroscope=imu_data["gyroscope"])




    
class FlaskTest(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_status_endpoint(self):
        response = self.app.get('/status')
        self.assertEqual(response.status_code, 200)
        self.assertIn('Hostname', response.json)
    
    def test_led_status_endpoint(self):
        response = self.app.get('/led_status')
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response.json, list)

    def test_set_pixel_endpoint(self):
        response = self.app.post('/set_pixel', json={'x': 0, 'y': 0, 'r': 255, 'g': 255, 'b': 255})
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response.json, list)
        
    def test_missing_data_in_set_pixel(self):
        response = self.app.post('/set_pixel', json={'x': 0, 'y': 0, 'r': 255, 'g': 255})
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.json)
        
    def test_incorrect_data_types_in_set_pixel(self):
        response = self.app.post('/set_pixel', json={'x': 'invalid', 'y': 0, 'r': 255, 'g': 255, 'b': 255})
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.json)
        
    def test_invalid_color_range_in_set_pixel(self):
        response = self.app.post('/set_pixel', json={'x': 0, 'y': 0, 'r': 300, 'g': 200, 'b': 100})
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.json)

    def test_clear_led_matrix_endpoint(self):
        response = self.app.post('/clear_led_matrix', json={'color': [0, 0, 0]})
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response.json, list)

    def test_show_message_endpoint(self):
        response = self.app.post('/show_message', json={'text': 'Test', 'scroll_speed': 0.1, 'text_color': [255, 255, 255], 'back_color': [0, 0, 0]})
        self.assertEqual(response.status_code, 200)
        self.assertIn('Message displayed', response.json['message'])
       
    def test_invalid_text_color_in_show_message(self):
        response = self.app.post('/show_message', json={'text': 'Test', 'scroll_speed': 0.1, 'text_color': [255, 255, 'invalid'], 'back_color': [0, 0, 0]})
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.json)
    
    def test_invalid_background_color_in_show_message(self):
        response = self.app.post('/show_message', json={'text': 'Test', 'scroll_speed': 0.1, 'text_color': [255, 255, 255], 'back_color': [0, 0]})
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.json)
        
    def test_invalid_scroll_speed_in_show_message(self):
        response = self.app.post('/show_message', json={'text': 'Test', 'scroll_speed': 'invalid', 'text_color': [255, 255, 255], 'back_color': [0, 0, 0]})
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.json)
        
    def test_invalid_scroll_speed_in_show_message(self):
        response = self.app.post('/show_message', json={'text': 'Test', 'scroll_speed': 'invalid', 'text_color': [255, 255, 255], 'back_color': [0, 0, 0]})
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.json)

        response = self.app.post('/show_message', json={'text': 'Test', 'scroll_speed': -0.1, 'text_color': [255, 255, 255], 'back_color': [0, 0, 0]})
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.json)

        response = self.app.post('/show_message', json={'text': 'Test', 'scroll_speed': 1.5, 'text_color': [255, 255, 255], 'back_color': [0, 0, 0]})
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', response.json)

    def test_meteo_endpoint(self):
        response = self.app.get('/meteo')
        self.assertEqual(response.status_code, 200)
        self.assertIn('temperature', response.json)

    def test_imu_data_endpoint(self):
        response = self.app.get('/imu_data')
        self.assertEqual(response.status_code, 200)
        self.assertIn('orientation', response.json)
        
        
if __name__ == '__main__':
    if "test" in sys.argv:
        # Run the tests
        unittest.main()
    else:
        state = State()
        app.run(debug=True, host='0.0.0.0', port=5001)