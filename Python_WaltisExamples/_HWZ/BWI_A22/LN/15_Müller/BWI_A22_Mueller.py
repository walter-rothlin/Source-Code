from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__)
app.secret_key = 'ein_geheimer_schlüssel'  # notwendig für Sessions


# Hilfsfunktion zur E-Mail-Validierung
def is_valid_email(email):
    if '@' in email:
        local, domain = email.split('@', 1)
        if local and '.' in domain:
            return True
    return False


# Startseite
@app.route('/')
def home():
    return render_template('index.html')


# Kontaktseite
@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/adressliste')
def adressliste():
    if 'user' not in session:
        return redirect(url_for('login'))
    return render_template('adress_liste.html')


# Loginseite
@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        if not is_valid_email(email):
            error = 'Ungültige E-Mail-Adresse.'
        elif len(password) <= 5:
            error = 'Passwort muss länger als 5 Zeichen sein.'
        else:
            session['user'] = email
            return redirect(url_for('home'))

    return render_template('login.html', error=error)

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('home'))


# App starten
if __name__ == '__main__':
    app.run(debug=True)
