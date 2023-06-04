from flask import Flask, render_template, request, redirect, url_for, session, flash

app = Flask(__name__)
app.secret_key = 'djellor123'

users = []

# Statische Liste von Benutzern (zum Testen)
users = [{'email': 'user1@example.com', 'password': '12345', 'name': 'User 1'},
         {'email': 'user2@example.com', 'password': '123456', 'name': 'User 2'}]


# Index-Seite
@app.route('/')
def index():
    return render_template('index.html')


# Kontakt-Seite
@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')


# Adress-Liste-Seite
@app.route('/adress_liste')
def adress_liste():
    # Überprüfen, ob der Benutzer angemeldet ist
    if 'user' in request.cookies:
        return render_template('adress_liste.html')
    else:
        return redirect(url_for('login'))


# Login-Seite
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        # Überprüfen der Anmeldeinformationen
        for user in users:
            if user['email'] == email and user['password'] == password:
                session['email'] = email
                return redirect(url_for('index'))

        # Falls die Anmeldeinformationen ungültig sind
        return render_template('login.html', error='Email oder Passwort stimmen nicht überein oder noch nicht registriert!')

    return render_template('login.html', error='')


# Logout
@app.route('/logout', methods=['GET', 'POST'])
def logout():
    if request.method == 'POST':
        if request.form.get('action') == 'logout':
            session.pop('email', None)
            flash('Sie haben sich erfolgreich abgemeldet.', 'success')
        return redirect(url_for('index'))

    return render_template('logout.html')

# Registrierung-Seite
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        if len(password) < 5:
            return render_template('register.html', error='Das Passwort muss mindestens 5 Zeichen lang sein.')

        # Überprüfen, ob die E-Mail bereits registriert ist
        for user in users:
            if user['email'] == email:
                return render_template('register.html', error='Diese E-Mail ist bereits registriert.')

        # Registrierung erfolgreich
        users.append({'email': email, 'password': password, 'name': ''})
        return redirect(url_for('login'))

    return render_template('register.html', error='')


if __name__ == '__main__':
    app.run()
