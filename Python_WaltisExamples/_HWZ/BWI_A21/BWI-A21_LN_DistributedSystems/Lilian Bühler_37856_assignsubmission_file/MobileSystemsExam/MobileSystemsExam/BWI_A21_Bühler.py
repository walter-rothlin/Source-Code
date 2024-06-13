from flask import Flask, render_template, request, redirect, url_for, session, flash

app = Flask(__name__)

# Flask Funktionalität: Der secret_key wird gebraucht um die Session Cookies zu verschlüsseln.
app.secret_key = "c|kQ?@V5z-'}H79`1c@`"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

# Route für den Login, akzeptiert nur POST-Anfragen. Gemäss Anforderung muss das Passwort gleich sein wie der Username.
@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    if password == username:
        session['username'] = username
        flash('Login erfolgreich!', 'success')
        return redirect(url_for('index'))
    else:
        flash('Passwort muss gleich sein, wie Ihre E-Mail-Adresse ' + username, 'danger')
        return redirect(url_for('index'))

# Route für den Logout
@app.route('/logout')
def logout():
    session.pop('username', None)
    flash('Erfolgreich ausgeloggt.', 'info')
    return redirect(url_for('index'))

# Route für das Zurücksetzen des Passworts
@app.route('/password_reset', methods=['GET', 'POST'])
def password_reset():
    if request.method == 'POST':
        email = request.form['email']
        flash('Ein Link zum Zurücksetzen des Passworts wurde an Ihre E-Mail-Adresse ' + email + ' gesendet.', 'info')
    return redirect(url_for('index'))

# Route für die Registrierung
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        salutation = request.form['salutation']
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        username = request.form['register_email']
        password = request.form['register_password']
        flash('Registrierung erfolgreich! Bitte überprüfen Sie Ihre E-Mail ' + username + ' zur Bestätigung.', 'success')
    return redirect(url_for('index'))

# Route für die Adressliste, diese kann erst angezeigt werden, wenn eine aktive Verbindung besteht.
@app.route('/adress_liste')
def adress_liste():
    if 'username' not in session:
        flash('Um auf diesen Endpoint zuzugreifen loggen Sie sich bitte ein.', 'info')
        return redirect(url_for('index'))
    # Pseudodaten für die Adress-Liste. Diese sollten in einem nächsetn Schritt in eine Datenbank ausgelagert werden.
    addresses = [
        {"vorname": "Max", "name": "Mustermann", "strasse": "Hauptstraße", "hausnummer": "123", "plz": "12345",
         "ort": "Musterstadt"},
        {"vorname": "Anna", "name": "Schmidt", "strasse": "Bahnhofstraße", "hausnummer": "456", "plz": "23456",
         "ort": "Musterstadt"},
        {"vorname": "Elena", "name": "Kowalski", "strasse": "Rue de la Liberté", "hausnummer": "789", "plz": "34567",
         "ort": "Paris"},
        {"vorname": "Luca", "name": "Rossi", "strasse": "Via Roma", "hausnummer": "101", "plz": "45678", "ort": "Rom"},
        {"vorname": "Maria", "name": "García", "strasse": "Calle Mayor", "hausnummer": "202", "plz": "56789",
         "ort": "Madrid"}
    ]
    return render_template('adress_liste.html', addresses=addresses)

if __name__ == '__main__':
    app.run(debug=True)
