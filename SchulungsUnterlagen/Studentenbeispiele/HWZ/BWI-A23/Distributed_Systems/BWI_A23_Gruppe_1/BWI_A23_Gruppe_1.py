"""
BWI_A23_Gruppe_1.py
Flask/Jinja2 Web-Applikation für den Leistungsnachweis
Fach: Distributed and Mobile-Systems (HWZ)
Authors: Gruppe 1 (Marvin Alla, Sean Caroppo, Tim Rüegg, Taro Etter)
"""

import re

from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_session import Session

# Flask-Applikation erstellen. secret_key wird benötigt, um das Session-Cookie
# zu signieren (gegen Fälschung).
app = Flask(__name__)
app.secret_key = "bwi-a23-gruppe-1-secret-key"

# Serverseitige Sessions via Flask-Session:
# - SESSION_PERMANENT=False: die Session endet, wenn der Browser geschlossen wird.
# - SESSION_TYPE="filesystem": die Session-Daten liegen auf dem Server (Ordner
#   'flask_session'); im Cookie steht nur eine ID, nicht der Inhalt.
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Fiktive Adressliste (FR-8). Statt einer Datenbank halten wir die Daten
# als Modul-Konstante (Liste von Dictionaries) und übergeben sie ans Template.
ADDRESS_LIST = [
    {"first_name": "Anna", "last_name": "Meier", "city": "Zürich", "email": "anna.meier@example.com"},
    {"first_name": "Bruno", "last_name": "Keller", "city": "Bern", "email": "bruno.keller@example.com"},
    {"first_name": "Clara", "last_name": "Huber", "city": "Basel", "email": "clara.huber@example.com"},
    {"first_name": "David", "last_name": "Schmid", "city": "Luzern", "email": "david.schmid@example.com"},
    {"first_name": "Eva", "last_name": "Brunner", "city": "St. Gallen", "email": "eva.brunner@example.com"},
]

# Minimale Passwortlänge: zentral steuerbar; Meldung und Hinweis im Login
# verwenden diesen Wert dynamisch.
MIN_PASSWORD_LENGTH = 6

# Einfaches Muster zur Prüfung des E-Mail-Formats (etwas@etwas.tld).
EMAIL_PATTERN = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")

# Auswahlmöglichkeiten für das Anrede-Dropdown im Registrieren-Fenster (OPT-4).
SALUTATION_OPTIONS = ["Herr", "Frau", "Divers"]

# Datengetriebener Menübalken (OPT-1): ein neuer Menüpunkt = ein Eintrag hier
# (plus passende Route). 'login_required' blendet den Punkt nur für eingeloggte
# Benutzer ein. base.html rendert diese Liste in einer Schleife.
MENU_ITEMS = [
    {"label": "Home", "endpoint": "index", "login_required": False},
    {"label": "Kontakt", "endpoint": "kontakt", "login_required": False},
    {"label": "Adress-Liste", "endpoint": "adress_liste", "login_required": True},
]


@app.context_processor
def inject_globals():
    """Stellt allen Templates gemeinsame Werte zur Verfügung.

    Enthält den Login-Status (für die Navbar), das datengetriebene Menü, die
    Mindest-Passwortlänge sowie die Fehler/Eingaben für die drei Modals (Login,
    Passwort-Vergessen, Registrieren). Die Fehler werden mit 'pop' aus der Session
    entnommen, damit sie nur einmal angezeigt werden und das passende Modal bei
    Bedarf automatisch erneut geöffnet wird.
    """
    user_email = session.get("user_email")
    user_name = user_email.split("@")[0] if user_email else None
    # Login-Modal
    login_errors = session.pop("login_errors", {})
    login_email = session.pop("login_email", "")
    # Passwort-Vergessen-Modal
    forgot_errors = session.pop("forgot_errors", {})
    forgot_email = session.pop("forgot_email", "")
    # Registrieren-Modal
    register_errors = session.pop("register_errors", {})
    register_data = session.pop("register_data", {})
    open_auth_modal = ""
    if login_errors:
        open_auth_modal = "#loginModal"
    elif forgot_errors:
        open_auth_modal = "#forgotModal"
    elif register_errors:
        open_auth_modal = "#registerModal"
    return {
        "is_logged_in": user_email is not None,
        "user_name": user_name,
        "menu_items": MENU_ITEMS,
        "min_password_length": MIN_PASSWORD_LENGTH,
        "salutation_options": SALUTATION_OPTIONS,
        "login_errors": login_errors,
        "login_email": login_email,
        "forgot_errors": forgot_errors,
        "forgot_email": forgot_email,
        "register_errors": register_errors,
        "register_data": register_data,
        "open_auth_modal": open_auth_modal,
    }


@app.route("/")
def index():
    """Welcome-Page (Startseite). Rendert index.html (erbt von base.html)."""
    return render_template("index.html")


@app.route("/kontakt")
def kontakt():
    """Kontakt-Seite. Rendert kontakt.html (erbt von base.html)."""
    return render_template("kontakt.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    """
    GET:  es gibt keine eigene Login-Seite -> zurück zur Startseite.
    POST: prüft beide Felder einzeln (E-Mail-Format, Passwort lang genug).
          - Erfolg: E-Mail in der Session speichern, Erfolgs-Flash, Startseite.
          - Fehler: Fehler und E-Mail in der Session ablegen und zur Herkunftsseite
            zurückleiten. Dort öffnet das Login-Modal automatisch erneut und zeigt
            die roten Feldfehler an (siehe inject_globals / base.html).
    """
    if request.method == "POST":
        # Formulardaten via POST auslesen.
        email = request.form.get("email", "").strip()
        password = request.form.get("password", "")

        # Pro Feld eine mögliche Fehlermeldung sammeln.
        errors = {}

        # E-Mail-Format serverseitig prüfen.
        if not email:
            errors["email"] = "Bitte geben Sie eine E-Mail-Adresse ein."
        elif not EMAIL_PATTERN.match(email):
            errors["email"] = "Bitte geben Sie eine gültige E-Mail-Adresse ein."

        # Passwortlänge prüfen (Klartext, kein Hashing); Meldung nutzt die Variable.
        if len(password) < MIN_PASSWORD_LENGTH:
            errors["password"] = f"Das Passwort muss mindestens {MIN_PASSWORD_LENGTH} Zeichen lang sein."

        if not errors:
            session["user_email"] = email
            flash("Login erfolgreich. Willkommen!", "success")
            return redirect(url_for("index"))

        # Fehlerfall: Daten für das erneute Öffnen des Modals merken.
        session["login_errors"] = errors
        session["login_email"] = email
        return redirect(request.referrer or url_for("index"))

    # GET: kein eigenes Login-Template mehr nötig.
    return redirect(url_for("index"))


@app.route("/passwort-vergessen", methods=["GET", "POST"])
def password_forgot():
    """Verarbeitet das Passwort-Vergessen-Fenster.

    POST: prüft die E-Mail (nicht leer + Format). Bei Erfolg erscheint eine
          neutrale Bestätigungs-Meldung (kein E-Mail-Versand, keine Speicherung).
          Bei einem Fehler wird via Session zurückgeleitet und das Modal öffnet
          automatisch erneut mit dem roten Feldfehler.
    GET:  läuft über das Modal -> zurück zur Startseite.
    """
    if request.method == "POST":
        email = request.form.get("email", "").strip()
        errors = {}

        # E-Mail serverseitig prüfen.
        if not email:
            errors["email"] = "Bitte geben Sie eine E-Mail-Adresse ein."
        elif not EMAIL_PATTERN.match(email):
            errors["email"] = "Bitte geben Sie eine gültige E-Mail-Adresse ein."

        if not errors:
            flash("Wenn die E-Mail existiert, senden wir Anweisungen zum Zurücksetzen.", "success")
            return redirect(url_for("index"))

        # Fehlerfall: Daten für das erneute Öffnen des Modals merken.
        session["forgot_errors"] = errors
        session["forgot_email"] = email
        return redirect(request.referrer or url_for("index"))

    return redirect(url_for("index"))


@app.route("/registrieren", methods=["GET", "POST"])
def register():
    """Verarbeitet das Registrieren-Fenster (OPT-4, Demo ohne echte Speicherung).

    POST: validiert Anrede, Vorname, Nachname, E-Mail und Passwort feldweise. Bei
          Erfolg erscheint eine Bestätigungs-Meldung (kein Konto wird angelegt). Bei
          Fehlern wird via Session zurückgeleitet; das Modal öffnet erneut mit den
          roten Feldfehlern, die Eingaben (ausser Passwort) bleiben erhalten.
    GET:  läuft über das Modal -> zurück zur Startseite.
    """
    if request.method == "POST":
        # Eingaben auslesen.
        salutation = request.form.get("salutation", "").strip()
        first_name = request.form.get("first_name", "").strip()
        last_name = request.form.get("last_name", "").strip()
        email = request.form.get("email", "").strip()
        password = request.form.get("password", "")
        password_confirm = request.form.get("password_confirm", "")

        errors = {}

        # Pflichtfelder und Formate prüfen.
        if salutation not in SALUTATION_OPTIONS:
            errors["salutation"] = "Bitte wählen Sie eine Anrede."
        if not first_name:
            errors["first_name"] = "Bitte geben Sie Ihren Vornamen ein."
        if not last_name:
            errors["last_name"] = "Bitte geben Sie Ihren Nachnamen ein."
        if not email:
            errors["email"] = "Bitte geben Sie eine E-Mail-Adresse ein."
        elif not EMAIL_PATTERN.match(email):
            errors["email"] = "Bitte geben Sie eine gültige E-Mail-Adresse ein."
        if len(password) < MIN_PASSWORD_LENGTH:
            errors["password"] = f"Das Passwort muss mindestens {MIN_PASSWORD_LENGTH} Zeichen lang sein."
        # Wiederholung prüfen (zusätzlich zur clientseitigen Live-Prüfung).
        if password != password_confirm:
            errors["password_confirm"] = "Die Passwörter stimmen nicht überein."

        if not errors:
            flash("Registrierung erfolgreich. (Demo: keine Speicherung)", "success")
            return redirect(url_for("index"))

        # Fehlerfall: Fehler und Eingaben (ohne Passwort) für das Modal merken.
        session["register_errors"] = errors
        session["register_data"] = {
            "salutation": salutation,
            "first_name": first_name,
            "last_name": last_name,
            "email": email,
        }
        return redirect(request.referrer or url_for("index"))

    return redirect(url_for("index"))


@app.route("/logout")
def logout():
    """Loggt den Benutzer aus, indem die Session geleert wird (FR-9)."""
    session.clear()
    flash("Sie wurden abgemeldet.", "success")
    return redirect(url_for("index"))


@app.route("/adress-liste")
def adress_liste():
    """Adress-Listen-Seite. Nur für eingeloggte Benutzer erreichbar.

    Ist niemand eingeloggt, wird zur Startseite weitergeleitet (das Login erfolgt
    dort über das Modal). Sonst wird die Tabelle mit den Adressen gerendert.
    """
    if not session.get("user_email"):
        flash("Bitte loggen Sie sich ein, um die Adress-Liste zu sehen.", "warning")
        return redirect(url_for("index"))

    return render_template("adress_liste.html", addresses=ADDRESS_LIST)


# Startet den Entwicklungs-Server, wenn die Datei direkt ausgeführt wird.
if __name__ == "__main__":
    app.run(
        debug=True,
        host="127.0.0.1",
        port=5001
    )
