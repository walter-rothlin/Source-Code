# Import der benötigten Flask-Module und Erweiterungen
from flask import Flask, render_template, request, redirect, url_for, flash, session
import flask_session # Erweiterung für server-seitige Session-Verwaltung

# Erstelle eine neue Flask-Anwendungsinstanz
app = Flask(__name__)

# Konfiguration der Flask-Anwendung
app.secret_key = 'geheimer_schlüssel_123'  # Geheimer Schlüssel für Session-Sicherheit und Flash-Nachrichten
app.config["SESSION_PERMANENT"] = False  # Sessions sind nicht permanent (werden beim Schließen des Browsers gelöscht)
app.config["SESSION_TYPE"] = "filesystem"  # Sessions werden im Dateisystem des Servers gespeichert
session(app)  # Initialisiere die Session-Erweiterung mit der App


# Route für die Startseite
@app.route('/')
def index():
    """
    Startseite der Anwendung
    - Zeigt die Hauptseite (index.html) an
    - Enthält normalerweise Login/Logout-Buttons und Navigation
    """
    return render_template('index.html')


# Route für das Kontaktformular
@app.route('/kontakt', methods=['GET', 'POST'])
def kontakt():
    """
    Kontaktseite mit Formular
    - GET: Zeigt das Kontaktformular an
    - POST: Verarbeitet das gesendete Formular
    """
    if request.method == 'POST':
        # Wenn das Formular abgesendet wurde (POST-Request)
        # Hier könnte die Verarbeitung der Formulardaten erfolgen
        # (z.B. E-Mail versenden, in Datenbank speichern)
        flash('Deine Nachricht wurde erfolgreich gesendet.')
        return redirect(url_for('kontakt'))  # Umleitung zurück zur Kontaktseite

    # Wenn GET-Request: Zeige das Kontaktformular an
    return render_template('kontakt.html')


# Route für den Login-Prozess
@app.route('/login', methods=['POST'])
def login():
    """
    Verarbeitung der Login-Daten
    - Nur POST-Methode, da Login über Modal/Formular erfolgt
    - Validiert Passwort und setzt Session bei erfolgreicher Anmeldung
    """
    # Hole E-Mail und Passwort aus dem Formular
    # get() mit leerem String als Default verhindert None-Werte
    email = request.form.get('email', '')
    password = request.form.get('password', '')

    # Einfache Passwort-Validierung (in echter Anwendung würde Passwort gehasht verglichen)
    if len(password) > 5:
        # Passwort ist lang genug - Login erfolgreich
        session['email'] = email  # Speichere E-Mail in der Session (User ist jetzt eingeloggt)
        flash('Erfolgreich eingeloggt!')
    else:
        # Passwort zu kurz - Login fehlgeschlagen
        flash('Das Passwort muss mindestens 6 Zeichen lang sein.')

    # Umleitung zur Startseite nach Login-Versuch
    return redirect(url_for('index'))


# Route für den Logout-Prozess
@app.route('/logout')
def logout():
    """
    Benutzer ausloggen
    - Entfernt die E-Mail aus der Session
    - Leitet zur Startseite um
    """
    # Entferne 'email' aus der Session (None als Default falls nicht vorhanden)
    session.pop('email', None)
    flash('Du wurdest ausgeloggt.')
    return redirect(url_for('index'))


# Route für "Passwort vergessen" Funktionalität
@app.route('/forgot_password', methods=['POST'])
def forgot_password():
    """
    Verarbeitung der "Passwort vergessen" Anfrage
    - Validiert E-Mail-Adresse
    - In echter Anwendung würde hier ein Reset-Link per E-Mail versendet
    """
    # Hole E-Mail aus dem Formular
    email = request.form.get('email', '')

    # Einfache E-Mail-Validierung
    if len(email) > 3 and "@" in email:
        # E-Mail-Format scheint gültig zu sein
        # Hier würde normalerweise ein Reset-Token generiert und per E-Mail versendet
        flash(f'Eine E-Mail zum Zurücksetzen des Passworts wurde an {email} gesendet.')
    else:
        # Ungültige E-Mail-Adresse
        flash('Bitte gib eine gültige E-Mail-Adresse ein.')

    # Umleitung zur Startseite
    return redirect(url_for('index'))


# Route für die Benutzerregistrierung
@app.route('/register', methods=['POST'])
def register():
    """
    Verarbeitung der Registrierungsdaten
    - Validiert E-Mail und Passwort
    - In echter Anwendung würde hier der User in einer Datenbank gespeichert
    """
    # Hole Registrierungsdaten aus dem Formular
    email = request.form.get('email', '')
    password = request.form.get('password', '')

    # Validierung der Eingabedaten
    if len(password) < 6:
        # Passwort zu kurz
        flash('Das Passwort muss mindestens 6 Zeichen lang sein.')
    elif '@' not in email:
        # Ungültige E-Mail (sehr einfache Prüfung)
        flash('Bitte gib eine gültige E-Mail-Adresse ein.')
    else:
        # Alle Validierungen bestanden
        # Hier würde normalerweise der User in der Datenbank angelegt
        flash('Registrierung erfolgreich! Du kannst dich jetzt einloggen.')

    # Umleitung zur Startseite
    return redirect(url_for('index'))


# Route für die Adressliste (geschützter Bereich)
@app.route('/adress_liste')
def adress_liste():
    """
    Adressliste - nur für eingeloggte Benutzer zugänglich
    - Prüft ob Benutzer eingeloggt ist (Session enthält 'email')
    - Zeigt Adressliste an oder leitet um
    """
    # Prüfe ob Benutzer eingeloggt ist
    if 'email' not in session:
        # Benutzer ist nicht eingeloggt - Zugriff verweigert
        flash('Bitte logge dich zuerst ein.')
        return redirect(url_for('index'))

    # Benutzer ist eingeloggt - zeige Adressliste an
    return render_template('adress_liste.html')


# Hauptprogramm - startet die Flask-Anwendung
if __name__ == '__main__':
    """
    Startet den Flask-Entwicklungsserver
    - debug=True aktiviert den Debug-Modus (automatisches Neuladen bei Änderungen)
    - Sollte in Produktion auf False gesetzt werden
    """
    app.run(debug=True)