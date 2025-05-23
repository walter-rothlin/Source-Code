from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mail import Mail, Message

app = Flask(__name__)
app.secret_key = 'mein_super_sicherer_key_2025'

# Mail-Konfiguration (nicht aktiv verwendet, nur Platzhalter)
app.config['MAIL_SERVER'] = 'smtp.example.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'deine@email.com'
app.config['MAIL_PASSWORD'] = 'deinpasswort'
app.config['MAIL_DEFAULT_SENDER'] = 'deine@email.com'

mail = Mail(app)

# Startseite
@app.route('/')
def index():
    return render_template('index.html')

# Kontaktseite
@app.route('/kontakt', methods=['GET', 'POST'])
def kontakt():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        nachricht = request.form.get('message')
        flash(f'Danke {name}, deine Nachricht wurde übermittelt!')
        return redirect(url_for('kontakt'))
    return render_template('kontakt.html')

# Adressliste (nur sichtbar nach Login)
@app.route('/adress_liste')
def adress_liste():
    if 'email' not in session:
        flash('Bitte zuerst einloggen, um die Adressliste zu sehen.')
        return redirect(url_for('index'))
    return render_template('adress_liste.html')

# Login-Logik
@app.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')
    if email and len(password) > 5:
        session['email'] = email
        flash('Login erfolgreich!')
    else:
        flash('Bitte gib eine gültige E-Mail und ein Passwort mit mindestens 6 Zeichen ein.')
    return redirect(url_for('index'))

# Logout-Logik
@app.route('/logout')
def logout():
    session.pop('email', None)
    flash('Sie wurden erfolgreich ausgeloggt.')
    return redirect(url_for('index'))

# Passwort zurücksetzen (Mail-Versand simuliert)
@app.route('/password_reset', methods=['POST'])
def password_reset():
    email = request.form['email']
    flash(f'Eine E-Mail zum Zurücksetzen des Passworts wurde an {email} gesendet. (Simuliert)')
    return redirect(url_for('index'))

# Registrierung (mit Passwortprüfung, Mail-Versand simuliert)
@app.route('/register', methods=['POST'])
def register():
    anrede = request.form['anrede']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    email = request.form['email']
    password = request.form['password']

    if len(password) < 6:
        flash('Das Passwort muss mindestens 6 Zeichen lang sein.')
        return redirect(url_for('index'))

    # E-Mail-Versand wird nicht durchgeführt – nur simuliert
    flash(f'Registrierung erfolgreich für {anrede} {first_name} {last_name}. (E-Mail-Versand simuliert)')
    return redirect(url_for('index'))

# Start der Applikation
if __name__ == '__main__':
    app.run(debug=False)
