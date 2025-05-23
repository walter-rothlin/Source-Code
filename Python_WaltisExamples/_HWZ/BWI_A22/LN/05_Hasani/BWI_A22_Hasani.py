from flask import Flask, render_template, request, redirect, session, url_for, flash

app = Flask(__name__)
app.secret_key = 'geheim'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/adress_liste')
def adressen_liste():
    if 'user' not in session:
        flash("Bitte zuerst einloggen")
        return redirect(url_for('index'))
    return render_template('adress_liste.html')

@app.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')

    if len(password) > 5:
        session['user'] = email
        flash('Erfolgreich eingeloggt')
        return redirect(url_for('index'))
    else:
        flash('Passwort zu kurz (mind. 6 Zeichen)')
        return redirect(url_for('index'))

@app.route('/logout')
def logout():
    session.clear()
    flash('Erfolgreich ausgeloggt')
    return redirect(url_for('index'))

@app.route('/passwort_vergessen', methods=['POST'])
def passwort_vergessen():
    flash('Wenn dies eine echte Anwendung wäre, hättest du nun eine E-Mail erhalten 😉')
    return redirect(url_for('index'))

@app.route('/registrieren', methods=['POST'])
def registrieren():
    vorname = request.form.get('vorname')
    nachname = request.form.get('nachname')
    email = request.form.get('email')
    password = request.form.get('password')

    if len(password) > 5:
        flash(f'Danke {vorname}, deine Registrierung war erfolgreich.')
    else:
        flash('Passwort zu kurz (mind. 6 Zeichen)')
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)