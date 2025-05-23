# BWI_A21_Hurschler.py
from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mail import Mail, Message

users = {
    'gringotvch@gmail.com': {
        'passwort': '123456',
    }
}  # eine Mail als DEFAULT-User definiert, als Testdaten für Prüfung.
app = Flask(__name__)
app.secret_key = 'ac12fb45234!'

app.config['MAIL_SERVER'] = 'sandbox.smtp.mailtrap.io'
app.config['MAIL_PORT'] = 2525
app.config['MAIL_USERNAME'] = 'a01da874ce0fda'
app.config['MAIL_PASSWORD'] = '21e06114cddb20'
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False

mail = Mail(app)


@app.route('/')
def home():
    email = ''
    password = ''
    error = session.pop('login_error', None)
    return render_template('index.html', email=email, password=password, error=error, current_page='home')


@app.route('/kontakt', methods=['GET', 'POST'])
def kontakt():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        nachricht = request.form['nachricht']

        print(f"Neue Nachricht von {name} <{email}>: {nachricht}")

        # Mail senden
        try:
            msg = Message(
                subject="Neue Kontaktanfrage",
                sender='noreply@example.com',  # optional: kann auch email sein
                recipients=["gringotvch@gmail.com"],  # HIER deine Zieladresse!
                body=f"Name: {name}\nE-Mail: {email}\n\nNachricht:\n{nachricht}"
            )
            mail.send(msg)
            print("✅ Kontakt-Mail gesendet.")
            return render_template('kontakt.html', success=True, current_page='kontakt')
        except Exception as e:
            print(f"❌ Fehler beim Mailversand im Kontaktformular: {e}")
            return render_template('kontakt.html', success=False, error=str(e), current_page='kontakt')

    return render_template('kontakt.html', current_page='kontakt')

@app.route('/login', methods=['POST'])
def login():
    email = request.form['email']
    password = request.form['password']

    # ✅ E-Mail validieren
    if '@' not in email or '.' not in email:
        session['login_error'] = 'Bitte geben Sie eine gültige E-Mail-Adresse ein.'
        return redirect(url_for('home'))

    # ✅ Passwort validieren
    if len(password) < 6:
        session['login_error'] = 'Passwort muss mindestens 6 Zeichen lang sein.'
        return redirect(url_for('home'))

    # 🆕 Benutzer automatisch erstellen, falls nicht vorhanden
    if email not in users:
        users[email] = {'passwort': password}
    else:
        # ✅ Passwort prüfen, wenn Benutzer schon existiert
        if users[email]['passwort'] != password:
            session['login_error'] = 'Falsches Passwort.'
            return redirect(url_for('home'))

    # ✅ Login erfolgreich
    session['user'] = email
    flash('Erfolgreich eingeloggt.')
    return redirect(url_for('home'))


@app.route('/register', methods=['POST'])
def register():
    email = request.form['email']
    passwort = request.form['passwort']
    anrede = request.form['anrede']
    vorname = request.form['vorname']
    nachname = request.form['nachname']

    # E-Mail prüfen
    if '@' not in email or '.' not in email:
        session['login_error'] = 'Ungültige E-Mail-Adresse.'
        return redirect(url_for('home'))

    # Passwort prüfen
    if len(passwort) < 6:
        session['login_error'] = 'Passwort muss mindestens 6 Zeichen lang sein.'
        return redirect(url_for('home'))

    # E-Mail schon vorhanden?
    if email in users:
        flash("Diese E-Mail ist bereits registriert.")
        return redirect(url_for('home'))

    # Benutzer speichern
    users[email] = {
        'anrede': anrede,
        'vorname': vorname,
        'nachname': nachname,
        'passwort': passwort
    }

    # Aktivierungslink und Mail
    token = email.replace('@', '_at_')
    link = url_for('activate', token=token, _external=True)
    html_content = f"""
    <h3>Hallo {anrede} {vorname} {nachname},</h3>
    <p>Vielen Dank für Ihre Registrierung.</p>
    <p><a href="{link}">Konto aktivieren</a></p>
    <p>Falls Sie sich nicht registriert haben, ignorieren Sie diese E-Mail.</p>
    """

    try:
        msg = Message(subject='Aktivierung Ihrer Registrierung',
                      sender='noreply@example.com',
                      recipients=[email],
                      html=html_content)
        mail.send(msg)
        print(f"➤ Mail gesendet an {email}")
    except Exception as e:
        print("❌ Fehler beim Mailversand:", e)
        session['login_error'] = 'Fehler beim Mailversand.'

    session['login_error'] = 'Registrierung erfolgreich. Bitte prüfen Sie Ihre E-Mail.'
    return redirect(url_for('home'))  # ✅ garantiertes return


@app.route('/reset', methods=['POST'])
def reset_password():
    print("🟢 reset_password() wurde aufgerufen")  # ← genau hier

    email = request.form['email']

    if email not in users:
        flash("Diese E-Mail ist nicht registriert.")
        return redirect(url_for('home'))

    token = email.replace('@', '_at_')
    link = url_for('reset_confirm', token=token, _external=True)

    html_content = f"""
    <p>Sie haben eine Zurücksetzung Ihres Passworts angefordert.</p>
    <p><a href="{link}">Klicken Sie hier, um Ihr Passwort zurückzusetzen</a></p>
    <p>Falls Sie diese Anfrage nicht gestellt haben, ignorieren Sie bitte diese E-Mail.</p>
    """

    try:
        msg = Message(subject='Passwort zurücksetzen',
                      sender='noreply@example.com',
                      recipients=[email],
                      html=html_content)
        print("📧 E-Mail wird nun versendet...")
        mail.send(msg)
        print("✅ E-Mail erfolgreich versendet.")
        flash("E-Mail mit Link wurde verschickt.")
    except Exception as e:
        print(f"❌ Fehler beim Mailversand: {e}")
        flash("Fehler beim Versand der E-Mail.")

    return redirect(url_for('home'))




@app.route('/activate/<token>')
def activate(token):
    email = token.replace('_at_', '@')
    return f"Konto für {email} wurde erfolgreich aktiviert!"

@app.route('/reset/<token>', methods=['GET', 'POST'])
def reset_confirm(token):
    email = token.replace('_at_', '@')

    if request.method == 'POST':
        neues_passwort = request.form['neues_passwort']

        if len(neues_passwort) < 6:
            flash("Passwort muss mindestens 6 Zeichen lang sein.")
            return redirect(request.url)

        if email in users:
            users[email]['passwort'] = neues_passwort
            flash("Passwort wurde erfolgreich geändert.")
        else:
            flash("Benutzer nicht gefunden.")

        return redirect(url_for('home'))

    return render_template('reset_confirm.html', email=email) #HTML-Template wurde nicht implementiert, da es nicht Teil der Prüfung war.

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('home'))

@app.route('/adress_liste')
def adress_liste():
    if 'user' not in session:
        return redirect(url_for('home'))
    adressen = [
        {'vorname': 'Max', 'name': 'Muster', 'strasse': 'Bahnhofstrasse', 'nr': '10', 'plz': '8001', 'ort': 'Zürich'},
        {'vorname': 'Anna', 'name': 'Meier', 'strasse': 'Seestrasse', 'nr': '25', 'plz': '6006', 'ort': 'Luzern'},
        {'vorname': 'Peter', 'name': 'Huber', 'strasse': 'Aeschenplatz', 'nr': '3', 'plz': '4052', 'ort': 'Basel'},
        {'vorname': 'Sabine', 'name': 'Keller', 'strasse': 'Marktgasse', 'nr': '12', 'plz': '3011', 'ort': 'Bern'},
        {'vorname': 'Lukas', 'name': 'Schmid', 'strasse': 'Poststrasse', 'nr': '5', 'plz': '9000', 'ort': 'St. Gallen'},
    ]

    return render_template('adress_liste.html', current_page='adress_liste', adressen=adressen)

if __name__ == '__main__':
    app.run(debug=True)