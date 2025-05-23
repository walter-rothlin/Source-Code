from flask import Flask, render_template, request, redirect, session, url_for, flash

app = Flask(__name__)
app.secret_key = 'vAliBabA@91'

@app.route('/')
def startseite():
    return render_template('index.html')

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/login', methods=['POST'])
def login():
    email = request.form['email']
    password = request.form['password']

    if len(password) < 6:
        session['login_error'] = "Das Passwort muss mindestens 6 Zeichen lang sein."
        return redirect(url_for('startseite', login_failed='1'))

    session.pop('login_error', None)
    session['user'] = email
    return redirect(url_for('startseite'))

@app.route('/clear_login_error', methods=['POST'])
def clear_login_error():
    session.pop('login_error', None)
    return '', 204  # Empty response

@app.route('/pw_reset', methods=['POST'])
def pw_reset():
    email = request.form.get('email')
    reset_link = f"http://localhost:5000/passwort-zuruecksetzen/{email}/123456"
    flash(f"Ein Link zum Zurücksetzen wurde an {email} gesendet.")
    return redirect(url_for('startseite'))

@app.route('/registrieren', methods=['POST'])
def registrieren():
    email = request.form.get('email')
    vorname = request.form.get('vorname')
    passwort = request.form['passwort']

    if len(passwort) < 6:
        session['register_error'] = "Das Passwort muss mindestens 6 Zeichen lang sein."
        return redirect('/?register_failed=1')

    flash(f"Vielen Dank, {vorname}. Ein Registrierungslink wurde an {email} gesendet.")
    return redirect(url_for('startseite'))

@app.route('/clear_register_error', methods=['POST'])
def clear_register_error():
    session.pop('register_error', None)
    return '', 204

@app.route('/logout')
def logout():
    session.pop('user', None)
    flash("Du wurdest erfolgreich ausgeloggt.")
    return redirect(url_for('startseite'))

@app.route('/adress_liste')
def adress_liste():
    if 'user' in session:
        return render_template('adress_liste.html')
    return redirect(url_for('startseite'))

if __name__ == '__main__':
    app.run(debug=True)