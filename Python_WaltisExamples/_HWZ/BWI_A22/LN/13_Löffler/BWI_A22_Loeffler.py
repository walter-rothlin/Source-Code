from flask import Flask, render_template, request, redirect, url_for, session, flash

app = Flask(__name__)
app.secret_key = 'super_secret_key'

# Dummy-Daten für Adressliste
address_list = [
    {'Name': 'Max Muster', 'Email': 'max@muster.ch', 'Ort': 'Zürich'},
    {'Name': 'Anna Beispiel', 'Email': 'anna@example.com', 'Ort': 'Bern'},
]

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/kontakt', methods=['GET', 'POST'])
def kontakt():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        nachricht = request.form['nachricht']
        print(f"Kontaktformular abgeschickt von {name} ({email}): {nachricht}")
        flash("Danke für deine Nachricht! Wir melden uns bald.")
        return redirect(url_for('index'))
    return render_template('kontakt.html')

@app.route('/login', methods=['POST'])
def login():
    email = request.form['email']
    password = request.form['password']
    if len(password) > 5:
        session['user'] = email
        return redirect(url_for('index'))
    else:
        return render_template('index.html', error='Passwort zu kurz!')

@app.route('/logout_confirmed')
def logout_confirmed():
    session.pop('user', None)
    return redirect(url_for('index'))

@app.route('/adressliste')
def adressliste():
    if 'user' in session:
        return render_template('adress_liste.html', addresses=address_list)
    return redirect(url_for('index'))

@app.route('/passwort_vergessen', methods=['POST'])
def passwort_vergessen():
    email = request.form['reset_email']
    print(f"Passwort-Reset-Link an {email} gesendet (simuliert).")
    flash(f"Ein Link zum Zurücksetzen wurde an {email} gesendet.")
    return redirect(url_for('index'))

@app.route('/registrieren', methods=['POST'])
def registrieren():
    print("Registrierungsdaten empfangen:", request.form)
    email = request.form.get('email')
    password = request.form.get('password')
    if len(password) > 5:
        print(f"Registrierungsbestätigungs-Link an {email} gesendet (simuliert).")
        flash(f"Ein Bestätigungslink wurde an {email} gesendet. Bitte prüfe deine E-Mails.")
    else:
        flash("Das Passwort muss mindestens 6 Zeichen lang sein.")
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)
