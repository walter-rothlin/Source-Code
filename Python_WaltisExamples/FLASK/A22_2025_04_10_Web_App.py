from flask import Flask, render_template, request, session, redirect
import json
import requests

app = Flask(__name__)
app.secret_key = 'geheimnis'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"


anrede_default='Frau'

@app.route('/', methods=['GET', 'POST'])
def index():
    # 1. Hole Anrede aus dem Request (POST oder GET)
    anrede = request.form.get("anrede") or request.args.get("anrede")

    # 2. Falls übergeben, in Session speichern
    if anrede:
        session['anrede'] = anrede

    # 3. Hole Anrede aus Session, wenn vorhanden
    anrede = session.get('anrede', anrede_default)

    adress_liste = [
        {'nachname': 'Rothlin', 'vorname': 'Walter'},
        {'nachname': 'Meier', 'vorname': 'Max'},
        {'nachname': 'Roth', 'vorname': 'Josef'},
        {'nachname': 'Bamert', 'vorname': 'Fritz'},
        {'nachname': 'Schnellmann', 'vorname': 'Daniel'}
    ]

    return render_template('BWI_A22_IndexPage.html', stadt_name='<B>Müller</B>', anrede=anrede, adress_liste=adress_liste)
@app.route('/Hallo')
def hello():
    return 'Hallo BWI-A22'

@app.route('/JSON')
def get_JSON():
    return {'Name': 'Rothlin', 'Vorname': 'Walter'}


def fetch_weather(city="Wangen SZ", units="metric", lang="de"):
    appid = "144747fd356c86e7926ca91ce78ce170"
    url_str = f"https://api.openweathermap.org/data/2.5/weather?q={city}&units={units}&lang={lang}&appid={appid}".replace(" ", "%20")

    print(url_str)

    response = requests.get(url_str)
    data = response.json()

    if lang == "en":
        return {
            'temperatur': data['main']['temp'],
            'pressure': data['main']['pressure'],
            'humidity': data['main']['humidity'],
            'city': data['name'],
            'country': data['sys']['country'],
            'description': data['weather'][0]['description'],
            'weather': data['weather'][0]['main'],
            'image': f"http://openweathermap.org/img/wn/{data['weather'][0]['icon']}@2x.png",
            'longitude': data['coord']['lon'],
            'latitude': data['coord']['lat'],
        }
    else:
        return {
            'Temperatur':       f"{data['main']['temp']}°C",
            'Luftdruck':        f"{data['main']['pressure']}hPa",
            'Luftfeuchtigkeit': f"{data['main']['humidity']}%",
            'Ort': data['name'],
            'Land': data['sys']['country'],
            'Beschreibung': data['weather'][0]['description'],
            'Wetter': data['weather'][0]['main'],
            'Bild': f"http://openweathermap.org/img/wn/{data['weather'][0]['icon']}@2x.png",
            'Laengengrad': data['coord']['lon'],
            'Breitengrad': data['coord']['lat'],
            'Laengengrad': data['coord']['lon'],
        }

@app.route('/Wetterbild', methods=['GET', 'POST'])
def get_weatherpicture():
    city = request.values.get("ort") or request.values.get("city") or "Wangen SZ"
    units = request.values.get("einheiten") or request.values.get("units") or "metric"
    lang = request.values.get("sprache") or request.values.get("lang") or "de"

    weather_data = fetch_weather(city, units, lang)
    print(weather_data)
    return render_template('WetterBild.html', weather_data=weather_data)


@app.route('/Wetter', methods=['GET', 'POST'])
def get_weather():
    city = request.values.get("ort") or request.values.get("city") or "Wangen SZ"
    units = request.values.get("einheiten") or request.values.get("units") or "metric"
    lang = request.values.get("sprache") or request.values.get("lang") or "de"

    return fetch_weather(city, units, lang)


@app.route('/redirect')
def redir():
    print('redirect() called!!!')
    return redirect("http://www.hwz.ch")

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)