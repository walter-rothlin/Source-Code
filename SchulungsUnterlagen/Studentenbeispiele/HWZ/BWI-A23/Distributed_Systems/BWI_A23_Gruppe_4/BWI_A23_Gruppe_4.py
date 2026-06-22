
from flask import Flask, request, render_template, session, redirect, url_for

class State():
    def __init__(self):
        self.__req_count = 0

    def inc(self):
        self.__req_count += 1

    def get_req_count(self):
        return str(self.__req_count)

adressen = [
    {'nachname': 'Rothlin',     'vorname': 'Walter M.', 'ort': 'Uster'},
    {'nachname': 'Meier',       'vorname': 'Max',       'ort': 'Zuerich'},
    {'nachname': 'Roth',        'vorname': 'Josef',     'ort': 'Winterthur'},
    {'nachname': 'Bamert',      'vorname': 'Fritz',     'ort': 'Rapperswil'},
    {'nachname': 'Schnellmann', 'vorname': 'Daniel',    'ort': 'Wetzikon'},
]


app = Flask(__name__)

app.secret_key = 'BWI_A23_Gruppe_4_GeheimerSchluessel'
app.config["SESSION_PERMANENT"] = False

@app.route('/')
def index():
    req_counter.inc()
    return render_template('index.html',
                           request_counter=req_counter.get_req_count(),
                           get_params=request.args)

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        passwort = request.form.get('passwort')

        if email and passwort and len(passwort) > 5:
            session['login_name'] = email
            return redirect(url_for('index'))
        else:
            fehler = 'Login fehlgeschlagen. Bitte E-Mail eingeben und ein Passwort mit mehr als 5 Zeichen.'
            return render_template('login.html', fehler=fehler)

    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('login_name', None)
    return redirect(url_for('index'))

@app.route('/adress_liste')
def adress_liste():
    if not session.get('login_name'):
        return redirect(url_for('login'))
    return render_template('adress_liste.html', adressen=adressen)


if __name__ == '__main__':
    req_counter = State()
    app.run(debug=True, host='127.0.0.1', port=5001)
