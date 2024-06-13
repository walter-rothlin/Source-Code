from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mail import Mail, Message

# Initialisiere die Flask-Anwendung
app = Flask(__name__)

# Setze einen Schlüssel für Session-Management und Flash-Nachrichten
app.secret_key = 'ac12fb45234!'

# Initialisiere die Flask-Mail-Erweiterung
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

#Adressliste
@app.route('/adress_liste')
def adress_liste():
    # Überprüfe, ob der Benutzer eingeloggt ist, um die Adressliste anzuzeigen. Ansonsten Hinweis-Meldung
    if 'email' not in session:
        flash('Bitte loggen Sie sich ein, um die Adress-Liste zu sehen.')
        return redirect(url_for('index'))
    return render_template('adress_liste.html')

# Anmeldeseite mit POST-Methode zum Einloggen
@app.route('/login', methods=['POST'])
def login():
    email = request.form['email']
    password = request.form['password']
    # Einfache Authentifizierung: Das Passwort ist gleich der E-Mail-Adresse; ansonsten Fehlermeldung (gemäss Anforderung)
    if password == email:
        session['email'] = email
        flash('Erfolgreich eingeloggt!')
        return redirect(url_for('index'))
    else:
        flash('Das Passwort ist falsch!')
        return redirect(url_for('index'))

# Ausloggen des Benutzers und Löschen der Session
@app.route('/logout')
def logout():
    session.pop('email', None)
    # Flash-Nachricht zur Bestätigung des erfolgreichen Ausloggens
    flash('Sie wurden erfolgreich ausgeloggt.')
    return redirect(url_for('index'))

# Passwort-Zurücksetzen-Funktionalität
@app.route('/password_reset', methods=['POST'])
def password_reset():
    email = request.form['email']
    # Flash-Nachricht mit der E-Mail-Adresse des Benutzers, an die das Zurücksetzungs-E-Mail gesendet wurde
    flash('Eine E-Mail zum Zurücksetzen des Passworts wurde an ' + email + ' gesendet.')
    return redirect(url_for('index'))

# Registrierungsseite mit POST-Methode zum Registrieren neuer Benutzer
@app.route('/register', methods=['POST'])
def register():
    anrede = request.form['anrede']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    email = request.form['email']
    password = request.form['password']
    # Flash-Nachricht zur Bestätigung der erfolgreichen Registrierung
    flash('Registrierung erfolgreich! Bitte loggen Sie sich ein.')
    return redirect(url_for('index'))

# Starte die Flask-Anwendung
if __name__ == '__main__':
    app.run(debug=False)
