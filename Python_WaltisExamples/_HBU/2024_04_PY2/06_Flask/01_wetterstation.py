from flask import Flask, request, render_template, url_for
import requests
import json


url_str = "https://api.openweathermap.org/data/2.5/weather?q=Wangen+SZ&units=metric&lang=de&appid=144747fd356c86e7926ca91ce78ce170"

class State():
    def __init__(self):
        self.__req_count = 0

    def inc(self):
        self.__req_count += 1

    def get_req_count(self):
        return str(self.__req_count)


app = Flask(__name__)
request_counter = State()


@app.route('/')
def index():
    request_counter.inc()
    return '''
    <H1>Home End-Point (index)</H1>
    <UL>
        <LI><A href="/Hallo">Hallo World example</A></LI>
        <LI><A href="/HFU_Wetterstation">HFU_Wetterstation</A></LI>
        <LI><A href="/get_temp">get_temp</A></LI>
    '''


@app.route('/Hallo')
def hello():
    request_counter.inc()
    temperatur = get_temperatur()
    return render_template('index.html', year=2024, schulnamen=['HBU', 'BZU', 'HWZ'], temperatur=temperatur, counter=request_counter.get_req_count())

@app.route('/HFU_Wetterstation', methods=['GET', 'POST'])
def HFU_Wetterstation():
    if request.method == 'POST':
        ort = request.form.get("location")
    else:
        ort = request.args.get("location")

    if ort is None or ort == '':
        ort = 'Wangen SZ'

    get_temp_json_url = url_for('get_temperatur', location=ort, _external=True)
    print('get_temp_json_url:', get_temp_json_url)

    responseStr = requests.get(get_temp_json_url)
    jsonResponse = json.loads(responseStr.text)

    # weather_data = get_temperatur()
    return render_template('wetter_station.html', weather_data=jsonResponse)

@app.route('/get_temp', methods=['GET', 'POST'])
def get_temperatur():
    app_id = "144747fd356c86e7926ca91ce78ce170"

    if request.method == 'POST':
        ort = request.form.get("location")
    else:
        ort = request.args.get("location")

    if ort is None or ort == '':
        ort = 'Wangen SZ'

    url_str = f"https://api.openweathermap.org/data/2.5/weather?q={ort}&units=metric&lang=de&appid={app_id}"
    responseStr = requests.get(url_str)
    jsonResponse = json.loads(responseStr.text)

    return {'temp': jsonResponse['main']['temp'],
            'unit': '°C',
            'humidity': jsonResponse['main']['humidity'],
            'pressure': jsonResponse['main']['pressure'],
            'location': jsonResponse['name'],
            'description': jsonResponse['weather'][0]['description'],
            'icon': f"https://openweathermap.org/img/wn/{jsonResponse['weather'][0]['icon']}@2x.png"}


# =========================================================
if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)