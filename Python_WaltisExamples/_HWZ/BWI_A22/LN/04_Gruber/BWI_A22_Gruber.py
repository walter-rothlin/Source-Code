from flask import Flask, render_template, request, redirect, session, url_for
import re # Chat GPT

app = Flask(__name__)
app.secret_key = 'geheimer_hwz_key'


@app.route('/')
def home():
    return render_template('index.html')


@app.route('/kontakt', methods=['GET', 'POST'])
def kontakt():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        nachricht = request.form.get('nachricht')

        if not name or not email or not nachricht:
            return "<h3>Bitte füllen Sie alle Felder aus.</h3><a href='/kontakt'>Zurück</a>"

        email_pattern = r'^[\w\.-]+@[\w\.-]+\.(ch|com|net|org|edu|de)$' # Chat GPT
        if not re.match(email_pattern, email):
            return "<h3>Bitte geben Sie eine gültige E-Mail-Adresse ein (z. B. max@example.ch).</h3><a href='/kontakt'>Zurück</a>"

        return f"<h3>Vielen Dank, {name}. Ihre Nachricht wurde erfolgreich gesendet.</h3><a href='/'>Zurück zur Startseite</a>"

    return render_template('kontakt.html')

@app.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')

    pattern = r'^[\w\.-]+@[\w\.-]+\.(ch|com|net|org|edu|de)$' # Chat GPT
    valid_email = re.match(pattern, email)

    if not valid_email:
        return "<h3>Ungültige E-Mail-Adresse. Bitte verwenden Sie eine Endung wie .ch, .com, etc.</h3><a href='/'>Zurück</a>"

    if len(password) <= 5:
        return "<h3>Login fehlgeschlagen: Passwort muss länger als 5 Zeichen sein.</h3><a href='/'>Zurück</a>"

    session['user'] = email
    return redirect(url_for('home'))
@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('home'))

@app.route('/adress_liste')
def adress_liste():
    if 'user' not in session:
        return redirect(url_for('home'))

    adressen = [
        {'name': 'Max Muster', 'email': 'max@example.com', 'handicap': 12},
        {'name': 'Erika Beispiel', 'email': 'erika@golf.ch', 'handicap': 20},
        {'name': 'Lars Lopez', 'email': 'lars@golfclub.ch', 'handicap': 8},
        {'name': 'Adrian Schwergler', 'email': 'adrian@golf.ch', 'handicap': "+7"},
    ]
    return render_template('adress_liste.html', adressen=adressen)

@app.route('/passwort_vergessen', methods=['POST'])
def passwort_vergessen():
    email = request.form.get('reset_email')

    print(f"[DEBUG] Passwort zurücksetzen angefordert für: {email}") # Chat GPT

    return f"""
        <h3>Falls ein Konto mit <strong>{email}</strong> existiert, wurde eine E-Mail zum Zurücksetzen gesendet.</h3>
        <a href="/">Zurück zur Startseite</a>
    """

@app.route('/registrieren', methods=['POST'])
def registrieren():
    anrede = request.form.get('anrede')
    vorname = request.form.get('vorname')
    nachname = request.form.get('nachname')
    email = request.form.get('email')
    passwort = request.form.get('passwort')

    email_pattern = r'^[\w\.-]+@[\w\.-]+\.(ch|com|net|org|edu|de)$' # Chat GPT
    valid_email = re.match(email_pattern, email)

    if not valid_email:
        return f"""
            <h3>Ungültige E-Mail-Adresse: <code>{email}</code></h3>
            <p>Bitte verwenden Sie eine Adresse mit Endung wie .ch, .com usw.</p>
            <a href="/">Zurück</a>
        """

    if len(passwort) <= 5:
        return f"""
            <h3>Das Passwort ist zu kurz.</h3>
            <p>Es muss mindestens 6 Zeichen lang sein.</p>
            <a href="/">Zurück</a>
        """

    print(f"[DEBUG] Registrierung: {anrede} {vorname} {nachname}, {email}, Passwort-Länge: {len(passwort)}") # Chat GPT

    return f"""
        <h3>Vielen Dank für Ihre Registrierung, {anrede} {vorname} {nachname}.</h3>
        <p>Eine Bestätigungsmail wurde an <strong>{email}</strong> gesendet (nur Simulation).</p>
        <a href="/">Zurück zur Startseite</a>
    """


if __name__ == '__main__':
    app.run(debug=True)



