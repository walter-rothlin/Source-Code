from flask import Flask, render_template, request, session, redirect, url_for
# Es wurde teilweise ChatGPT zur Vervollständigung des Codes verwendet. Und zwar in den Bereichen
# Logout, Session, redirect. 

app = Flask(__name__)  # starten der Applikation


# Endpoints kommen nachfolgend => Bezeichnung für die Funktionen
@app.route('/')  # Adresse: wenn ich nur IP Adresse und Port eingebe, lande ich hier auf dem index-file
def index():  # def() Funktion - hier ist meine Hauptseite, nachfolgend Template Integration mit
    # Links auf Unterseiten
    return render_template('index.html')


@app.route('/Home')  # Unterseite 1
def home():  # Funktion
    if 'email' in session:
        email = session['email']
        return render_template('index.html', email=email)
    # Benutzer ist nicht eingeloggt, Weiterleitung zur Login-Seite
    return redirect(url_for('login'))


@app.route('/Logout')
def logout():
    session.pop('email', None)
    return redirect(url_for('login'))


@app.route('/Kontakt')  # gibt Dictionnary zurück
def kontakt():
    return render_template('kontakt.html')


@app.route('/Login', methods=['GET', 'POST'])  # statische Seiten in filesystem platzieren und via
# file-Operationen lesen
def login():
    if 'email' in session:
        # Benutzer ist bereits eingeloggt, Weiterleitung zur Hauptseite
        return redirect(url_for('home'))

    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        # Serverseitige Validierung des Passworts
        if len(password) > 5 and '@' in email:
            # Passwort gültig, führe den entsprechenden Code aus
            return "Erfolgreich angemeldet!"

        # Falls das Passwort nicht gültig ist
        error_message = "Ungültiges Passwort. Bitte versuche es erneut."

        # Rendern der Login-Seite mit dem Fehlerhinweis
        return render_template('login.html', error=error_message)

    # Bei GET-Anfragen wird die Login-Seite ohne Fehlermeldung angezeigt
    return render_template('login.html')


if __name__ == '__main__':  # hier wird das Programm ausgeführt => Server-Teil wird aufgestartet
    app.run(debug=True, host='127.0.0.1', port=5001)  # Bedingungen für Ausführung des Programms
