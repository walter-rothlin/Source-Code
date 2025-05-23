from flask import Flask, render_template, request, redirect, url_for, session, flash

app = Flask(__name__)
app.secret_key = 'secret_key_for_sessions'

@app.route('/')
def index():
    return render_template('index.html')


@app.route('/kontakt', methods=['GET', 'POST'])
def kontakt():
    name = ''
    nachricht = ''
    if request.method == 'POST':
        name = request.form.get('name')
        nachricht = request.form.get('nachricht')
    return render_template('kontakt.html', name=name, nachricht=nachricht)


@app.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    passwort = request.form.get('passwort')

    if passwort and len(passwort) > 5:
        session['user'] = email
        return redirect(url_for('index'))
    else:
        # Bleibe auf der Startseite, aber mit Modal-Fehler
        return render_template('index.html', login_error="Login fehlgeschlagen. Passwort ist kürzer als 5 Buchstaben")


@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('index'))


@app.route('/adressliste')
def adressliste():
    if 'user' in session:
        return render_template('adress_liste.html')
    else:
        return redirect(url_for('login'))


@app.route('/passwort_vergessen', methods=['POST'])
def passwort_vergessen():
    email = request.form.get('email')
    print(f"Simuliere Passwort-Reset-Mail an {email}")
    flash("Eine E-Mail zum Zurücksetzen wurde versendet.")
    return redirect(url_for('index'))


@app.route('/registrieren', methods=['POST'])
def registrieren():
    anrede = request.form.get('anrede')
    vorname = request.form.get('vorname')
    nachname = request.form.get('nachname')
    email = request.form.get('email')
    passwort = request.form.get('passwort')

    # Validierungen
    import re
    name_regex = r"^[a-zA-ZäöüÄÖÜàéèÀÉÈ\- ]+$"
    if not re.match(name_regex, vorname):
        return render_template('index.html', register_error="Der Vorname enthält ungültige Zeichen.")

    if not re.match(name_regex, nachname):
        flash("Der Nachname enthält ungültige Zeichen.")
        return render_template('index.html', register_error="Der Nachname enthält ungültige Zeichen.")


    print(f"Neuer Benutzer: {anrede} {vorname} {nachname} ({email}) – Passwort: {passwort}")
    flash("Registrierung erfolgreich. Bestätigung wurde per E-Mail versendet.")
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True)
