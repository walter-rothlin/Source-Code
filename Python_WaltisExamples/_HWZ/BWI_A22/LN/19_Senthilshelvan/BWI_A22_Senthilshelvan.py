from flask import Flask, render_template, request, redirect, url_for, flash, session

app = Flask(__name__)
app.secret_key = 'geheim123'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        if len(password) > 5:
            session['email'] = email
            flash('Login erfolgreich!')
            return redirect(url_for('index'))
        else:
            flash('Passwort muss länger als 5 Zeichen sein!')
    return redirect(url_for('index'))

@app.route('/password_reset', methods=['POST'])
def password_reset():
    email = request.form['email']
    fake_link = f"http://localhost:5000/reset/{email.replace('@', '_')}"
    print(f"[MAIL] Passwort-Zurücksetzen-Link an {email} gesendet: {fake_link}")
    flash(f'Passwort-Zurücksetzungslink wurde an {email} gesendet.')
    return redirect(url_for('index'))

@app.route('/register', methods=['POST'])
def register():
    anrede = request.form['anrede']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    email = request.form['email']
    password = request.form['password']
    confirm_link = f"http://localhost:5000/confirm/{email.replace('@', '_')}"
    print(f"[MAIL] Registrierung erfolgreich für {anrede} {first_name} {last_name} ({email})")
    print(f"[MAIL] Bestätigungs-Link: {confirm_link}")
    flash('Registrierung erfolgreich! Bitte logge dich ein.')
    return redirect(url_for('index'))

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/adress_liste')
def adress_liste():
    if 'email' not in session:
        flash('Bitte zuerst einloggen!')
        return redirect(url_for('login'))
    return render_template('adress_liste.html')

@app.route('/logout')
def logout():
    session.pop('email', None)
    flash('Du wurdest erfolgreich ausgeloggt.')
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True)