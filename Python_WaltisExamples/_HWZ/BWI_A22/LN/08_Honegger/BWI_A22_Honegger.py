from flask import Flask, render_template, request, redirect, url_for, session, flash

app = Flask(__name__)
app.secret_key = 'maras_secret_key'  # für Sessions

@app.route('/')
def index():
    response = render_template('index.html')
    session.pop('login_failed', None)
    session.pop('email_temp', None)
    session.pop('register_failed', None)
    session.pop('register_data', None)
    return response

@app.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')

    if len(password) > 5:
        session['email'] = email
        return redirect(url_for('index'))
    else:
        # Login fehlgeschlagen: Flash-Benachrichtigung + E-Mail merken + Login-Modal anzeigen
        flash("Passwort ist nicht korrekt.", category="login")
        session['login_failed'] = True
        session['email_temp'] = email
        return redirect(url_for('index'))

@app.route('/logout')
def logout():
    session.pop('email', None)
    flash("Du wurdest erfolgreich ausgeloggt.", category="logout")
    return redirect(url_for('index'))

@app.route('/kontakt', methods=['GET', 'POST'])
def kontakt():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        message = request.form.get('message')

        # Bestätigung anzeigen
        flash(f"Danke für deine Nachricht, {name}!", category="kontakt")
        return redirect(url_for('kontakt'))
    return render_template('kontakt.html')

@app.route('/adress_liste')
def adress_liste():
    if 'email' not in session:
        flash("Du musst dich zuerst einloggen, damit du die Adress-Liste sehen kannst!", category="adress_liste")
        return redirect(url_for('index'))
    return render_template('adress_liste.html')

@app.route('/password_reset', methods=['POST'])
def password_reset():
    email = request.form.get('email')
    session['login_failed'] = True  # damit man anschliessend zurück zum Login-Modal kommt
    flash(f"Eine E-Mail zum Zurücksetzen des Passworts wurde an {email} gesendet.", category="reset")
    return redirect(url_for('index'))

@app.route('/register', methods=['POST'])
def register():
    anrede = request.form.get('anrede')
    first_name = request.form.get('first_name')
    last_name = request.form.get('last_name')
    email = request.form.get('email')
    password = request.form.get('password')
    password_repeat = request.form.get('password_repeat')

    # Formulardaten speichern für Rückgabe
    session['register_data'] = {
        'anrede': anrede,
        'first_name': first_name,
        'last_name': last_name,
        'email': email
    }

    # Validierung
    if not anrede:
        flash("Bitte wähle eine Anrede aus.", category="register")
        session['register_failed'] = True
        session['register_data'] = {
            'anrede': '',  # keine Auswahl
            'first_name': first_name,
            'last_name': last_name,
            'email': email
        }
        return redirect(url_for('index'))
    if len(password) <= 5:
        flash("Das Passwort muss länger als 5 Zeichen sein.", category="register")
        session['register_failed'] = True
        return redirect(url_for('index'))

    if password != password_repeat:
        flash("Die Passwörter stimmen nicht überein.", category="register")
        session['register_failed'] = True
        return redirect(url_for('index'))

    # Registrierung erfolgreich
    session.pop('register_failed', None)
    session.pop('register_data', None)
    flash(f"Ein Bestätigungslink für die Registrierung wurde an {email} gesendet", category="register_success")
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True)
