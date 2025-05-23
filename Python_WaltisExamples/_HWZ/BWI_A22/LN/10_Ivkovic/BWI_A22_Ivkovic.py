from flask import Flask, render_template, request, redirect, url_for, flash, session

# Initialisiere die Flask-Anwendung
app = Flask(__name__)

# Setze einen Schlüssel für Session-Management und Flash-Nachrichten
app.secret_key = 'geheim123!'

# Routen für verschiedene Seiten

# Startseite
@app.route('/')
def index():
    return render_template('index.html')

# Kontaktseite
@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

# Adressliste
@app.route('/adress_liste')
def adress_liste():
    if 'email' not in session:
        flash('Bitte loggen Sie sich ein, um die Adress-Liste zu sehen.')
        return redirect(url_for('index'))
    return render_template('adress_liste.html')

# Login-Route
@app.route('/login', methods=['POST'])
def login():
    email = request.form['email']
    password = request.form['password']
    if len(password) > 5:  # Überprüfung der Passwortlänge
        session['email'] = email
        flash('Erfolgreich eingeloggt!')
        return redirect(url_for('index'))
    else:
        flash('Das Passwort muss länger als 5 Zeichen sein!')
        return redirect(url_for('index'))

# Logout-Route
@app.route('/logout')
def logout():
    session.pop('email', None)
    flash('Sie wurden erfolgreich ausgeloggt.')
    return redirect(url_for('index'))

# Logout-Bestätigungs-Route
@app.route('/logout_confirm')
def logout_confirm():
    return render_template('logout_confirm.html')

# Passwort-Vergessen Route
@app.route('/passwort_vergessen', methods=['GET', 'POST'])
def passwort_vergessen():
    if request.method == 'POST':
        email = request.form['email']
        # Simuliere das Senden einer E-Mail
        flash('Eine E-Mail mit Anweisungen zum Zurücksetzen des Passworts wurde an ' + email + ' gesendet.')
        return redirect(url_for('index'))
    return render_template('passwort_vergessen.html')

# Passwort zurücksetzen Route
@app.route('/passwort_zuruecksetzen/<token>')
def passwort_zuruecksetzen(token):
    flash('Bitte setzen Sie Ihr neues Passwort.')
    return redirect(url_for('index'))

# Registrieren Route
@app.route('/registrieren', methods=['GET', 'POST'])
def registrieren():
    if request.method == 'POST':
        anrede = request.form['anrede']
        vorname = request.form['vorname']
        nachname = request.form['nachname']
        email = request.form['email']
        password = request.form['password']
        
        # Simuliere das Senden einer Bestätigungs-E-Mail
        flash(f'Vielen Dank für Ihre Registrierung, {anrede} {vorname} {nachname}! Eine Bestätigungs-E-Mail wurde an {email} gesendet.')
        return redirect(url_for('index'))
    return render_template('registrieren.html')

# E-Mail-Bestätigung Route
@app.route('/email_bestaetigen/<token>')
def email_bestaetigen(token):
    flash('Ihre E-Mail-Adresse wurde bestätigt.')
    return redirect(url_for('index'))

# Starte die Flask-Anwendung
if __name__ == '__main__':
    app.run(debug=True) 