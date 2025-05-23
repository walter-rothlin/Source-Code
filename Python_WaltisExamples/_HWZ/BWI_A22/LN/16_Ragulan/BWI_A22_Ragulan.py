from flask import Flask, render_template, request, redirect, url_for, session, flash

app = Flask(__name__)
app.secret_key = 'supersecretkey'  # Für Sessions

ALLOWED_DOMAINS = (".ch", ".com", ".net", ".org")
MIN_PASSWORD_LENGTH = 6
SESSION_USER_KEY = "user"

def is_valid_email(email): # Für Chatgpt
    """Prüft, ob eine Email grundsätzlich erlaubt ist (Struktur + erlaubte Domain)."""
    return "@" in email and email.endswith(ALLOWED_DOMAINS)

def is_valid_password(password):# Für Chatgpt
    """Prüft, ob das Passwort lang genug ist."""
    return len(password) >= MIN_PASSWORD_LENGTH

# --- Dummy-Daten
ADDRESSES = [
    {"name": "Max Mustermann", "street": "Musterweg 1", "city": "8000 Zürich", "function": "Präsident"},
    {"name": "Erika Musterfrau", "street": "Beispielstrasse 2", "city": "9000 St. Gallen", "function": "Vizepräsidentin"},
]

# === ROUTES ===

@app.route("/")
def index():
    return render_template("index.html", errors=None)

@app.route("/kontakt", methods=["GET", "POST"]) # gewisse Teilfunktionen von Chatgpt übernommen
def kontakt():
    errors = []
    if request.method == "POST":
        absender_email = request.form.get("email", "").strip()
        nachricht = request.form.get("msg", "").strip()
        if not is_valid_email(absender_email):
            errors.append("Bitte gib eine gültige E-Mail-Adresse ein (z. B. max@domain.ch, .com, .net, .org).")
        if not nachricht:
            errors.append("Bitte gib eine Nachricht ein.")
        if not errors:
            print(f"[Kontakt] Nachricht von {absender_email}: {nachricht}")
            flash("Nachricht erfolgreich gesendet! Wir antworten so bald wie möglich.", "success")
            return redirect(url_for("kontakt"))
        else:
            flash(" ".join(errors), "danger")
    return render_template("kontakt.html", errors=errors)

@app.route("/login", methods=["GET", "POST"]) # gewisse Teilfunktionen von chatgpt, if schleifen
def login():
    errors = []
    if request.method == "POST":
        email = request.form["email"].strip()
        password = request.form["password"]
        if not is_valid_email(email):
            errors.append("Bitte gib eine gültige E-Mail-Adresse ein (z. B. max@domain.ch, .com, .net, .org).")
        if not is_valid_password(password):
            errors.append(f"Passwort muss mindestens {MIN_PASSWORD_LENGTH} Zeichen lang sein.")
        if not errors:
            session[SESSION_USER_KEY] = email
            flash("Erfolgreich eingeloggt.", "success")
            return redirect(url_for("index"))
        return render_template("index.html", errors=errors, show_login=True)
    else:
        return render_template("index.html", errors=None, show_login=True)

@app.route("/logout") # sessionpop von chatgpt.
def logout():
    session.pop(SESSION_USER_KEY, None)
    flash("Abgemeldet", "info")
    return redirect(url_for("index"))

@app.route("/adress-liste")
def adress_liste():
    if SESSION_USER_KEY not in session:
        return redirect(url_for("index", show_login=True))
    return render_template("adress_liste.html", addresses=ADDRESSES, errors=None)

@app.route("/reset", methods=["POST", "GET"]) # gewisse Teilfunktionen von chatgpt, if schleifen
def reset():
    errors = []
    if request.method == "POST":
        email = request.form.get("resetEmail", "").strip()
        if not is_valid_email(email):
            errors.append("Bitte gib eine gültige E-Mail-Adresse ein (z. B. max@domain.ch, .com, .net, .org).")
        if not errors:
            print(f"Passwort-Reset angefragt für: {email}")
            flash(f"Passwort-Reset für {email} ausgelöst (siehe Terminal).", "info")
            return redirect(url_for("index"))
        else:
            return render_template("index.html", errors=errors, show_reset=True)
    else:
        return render_template("index.html", errors=None, show_reset=True)

@app.route("/register", methods=["POST", "GET"]) # gewisse Teilfunktionen von chatgpt, if schleifen
def register():
    errors = []
    if request.method == "POST":
        anrede = request.form.get("anrede", "")
        vorname = request.form.get("vorname", "").strip()
        nachname = request.form.get("nachname", "").strip()
        email = request.form.get("email", "").strip()
        password = request.form.get("password", "")
        if not is_valid_email(email):
            errors.append("Bitte gib eine gültige E-Mail-Adresse ein (z. B. max@domain.ch, .com, .net, .org).")
        if not is_valid_password(password):
            errors.append(f"Passwort muss mindestens {MIN_PASSWORD_LENGTH} Zeichen lang sein.")
        if not errors:
            print(f"Neuer User: {anrede} {vorname} {nachname}, {email}")
            flash(f"Registrierung für {email} ausgelöst (siehe Terminal).", "success")
            return redirect(url_for("index"))
        else:
            return render_template("index.html", errors=errors, show_register=True)
    else:
        return render_template("index.html", errors=None, show_register=True)

# === START ===
if __name__ == "__main__":
    app.run(debug=True)
