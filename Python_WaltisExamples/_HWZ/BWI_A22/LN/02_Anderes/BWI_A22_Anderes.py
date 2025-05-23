from flask import Flask, render_template, request, redirect, session, url_for
import os

app = Flask(__name__)
app.secret_key = os.urandom(24)

@app.route('/')
def home():
    return render_template('index.html')


@app.route('/kontakt')
def kontakt():
    kontakt_info = {
        'name': 'Support Team',
        'email': 'saskia.anderes@student.fh-hwz.ch',
        'telefon': '+41 (41) 630 30 88'
    }
    return render_template('kontakt.html', kontakt=kontakt_info)


@app.route('/login', methods=['POST'])
def login():
    email = request.form['email']
    password = request.form['password']
    if len(password) > 5:
        session['user'] = email
        return redirect(url_for('home'))
    else:
        return render_template('index.html', error='Passwort muss länger als 5 Zeichen sein.')

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('home'))

@app.route('/adressliste')
def adressliste():
    if 'user' not in session:
        return redirect(url_for('home'))
    adressen = [
        {'name': 'Vivienne Bucher', 'strasse': 'Ulmenstrasse 5', 'ort': '6005 Luzern'},
        {'name': 'Sebastian Hafner', 'strasse': 'Kirchgasse 32', 'ort': '8032 Kloten'},
        {'name': 'Bianca Wienstroer', 'strasse': 'Bachstrasse 87', 'ort': '8184 Bachenbülach'},
        {'name': 'Selina Püntener', 'strasse': 'Zentralstrasse 70', 'ort': '4057 Basel'}
    ]
    return render_template('adress_liste.html', adressen=adressen)

if __name__ == '__main__':
    app.run(debug=True)