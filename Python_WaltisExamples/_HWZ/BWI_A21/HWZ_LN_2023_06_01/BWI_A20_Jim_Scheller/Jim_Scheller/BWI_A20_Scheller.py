from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__)
app.secret_key = 'geheimnis'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        password = request.form['password']
        if len(password) > 5:
            session['username'] = request.form['email']
            return redirect(url_for('index'))  # Redirect back to index after login
    return redirect(url_for('index'))  # Redirect back to index if GET request

@app.route('/dashboard')
def dashboard():
    if 'username' in session:
        return render_template('dashboard.html', username=session['username'])
    else:
        return redirect(url_for('index'))

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    if request.method == 'POST':
        if 'stay_logged_in' in request.form:
            return redirect(url_for('index'))  # Redirect to index without logging out
        else:
            session.pop('username', None)
            return redirect(url_for('index'))  # Redirect to index after logging out
    return render_template('logout.html')  # Render the logout modal if GET request

@app.route('/adress_liste')
def adress_liste():
    if 'username' in session:
        return render_template('adress_liste.html')
    else:
        return redirect(url_for('index'))

@app.route('/registration')
def registration():
    return render_template('registration.html')

@app.route('/password_reset', methods=['GET', 'POST'])
def password_reset():
    if request.method == 'POST':
        email = request.form['email']
        # Hier könnten Sie den Code einfügen, um eine E-Mail mit der Mail-Adresse und dem Passwort zu senden
        print("Passwort zurücksetzen für E-Mail:", email)  # Zum Testen nur Ausgabe im Terminal
        return redirect(url_for('index'))  # Redirect to index after password reset (Prototyp)
    return render_template('password_reset.html')

if __name__ == '__main__':
    app.run(debug=True)
