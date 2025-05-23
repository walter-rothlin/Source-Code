from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mail import Mail, Message
import os

# Flask-Anwendung initialisieren
app = Flask(__name__)

# Geheimschlüssel für Session-Management und Flash-Nachrichten festlegen
app.secret_key = os.urandom(24)

# Flask-Mail konfigurieren
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'your-email@gmail.com'  # Mit Ihrer E-Mail ersetzen
app.config['MAIL_PASSWORD'] = 'your-password'  # Mit Ihrem Passwort ersetzen

# Flask-Mail initialisieren
mail = Mail(app)

# Routen für verschiedene Seiten

# Startseite
@app.route('/')
def index():
    return render_template('index.html')

# Kontaktseite
@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

# Datenschutzseite
@app.route('/datenschutz')
def datenschutz():
    return render_template('datenschutz.html')

# Adressliste
@app.route('/adress_liste')
def adress_liste():
    # Prüfen ob Benutzer eingeloggt ist, um die Adressliste anzuzeigen
    if 'email' not in session:
        flash('Bitte loggen Sie sich ein, um die Adress-Liste zu sehen.')
        return redirect(url_for('index'))
    return render_template('adress_liste.html')

# Login-Seite mit POST-Methode
@app.route('/login', methods=['POST'])
def login():
    email = request.form['email']
    password = request.form['password']
    # Einfache Authentifizierung: Passwort muss länger als 5 Zeichen sein
    if len(password) > 5:
        session['email'] = email
        flash('Erfolgreich eingeloggt!')
        return redirect(url_for('index'))
    else:
        flash('Das Passwort muss länger als 5 Zeichen sein!')
        return redirect(url_for('index'))

# Benutzer abmelden und Session löschen
@app.route('/logout')
def logout():
    session.pop('email', None)
    flash('Sie wurden erfolgreich ausgeloggt.')
    return redirect(url_for('index'))

# Passwort-Zurücksetzungsfunktion
@app.route('/password_reset', methods=['POST'])
def password_reset():
    email = request.form['email']
    flash(f'Eine E-Mail zum Zurücksetzen des Passworts wurde an {email} gesendet.')
    return redirect(url_for('index'))

# Registrierungsseite mit POST-Methode
@app.route('/register', methods=['POST'])
def register():
    title = request.form['title']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    email = request.form['email']
    password = request.form['password']
    flash(f'Registrierung erfolgreich! Eine Bestätigungs-E-Mail wurde an {email} gesendet. Bitte loggen Sie sich ein.')
    return redirect(url_for('index'))

# Flask-Anwendung starten
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001) 