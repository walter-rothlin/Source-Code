from flask import Flask, render_template, request, redirect, url_for, session
from datetime import timedelta
import os

app = Flask(__name__)
app.secret_key = 'bwi_secret_key'
app.permanent_session_lifetime = timedelta(minutes=30)

address_data = [
    {"name": "Alessia Utz", "adresse": "Maneggpromenade 152", "city": "8041 Zürich"},
    {"name": "Debora Piceci", "adresse": "Werkstrasse 4", "city": "8645 Rapperswil"},
    {"name": "Julia Huber", "adresse": "Poststrasse 23", "city": "8134 Hombrechtikon"},
    {"name": "Giovanna Müller", "adresse": "Waffenplatz 3", "city": "8001 Zürich"}
]

@app.route("/")
def index():
    user = session.get("user")
    error = session.pop("error", None)
    success = session.pop("success", None)
    return render_template("index.html", user=user, error=error, success=success)

@app.route("/kontakt")
def kontakt():
    user = session.get("user")
    return render_template("kontakt.html", user=user)

@app.route("/login", methods=["POST"])
def login():
    email = request.form.get("email")
    password = request.form.get("password")
    if password and len(password) > 5:
        session["user"] = email
    else:
        session["error"] = "Passwort muss länger als 5 Zeichen sein."
    return redirect(url_for("index"))

@app.route("/logout", methods=["POST"])
def logout():
    session.clear()
    return redirect(url_for("index"))

@app.route("/reset_password", methods=["POST"])
def reset_password():
    email = request.form.get("email")
    print("Passwort zurücksetzen für:", email)
    session["success"] = f"Ein Link zum Zurücksetzen wurde an {email} gesendet."
    return redirect(url_for("index"))

@app.route("/register", methods=["POST"])
def register():
    anrede = request.form.get("anrede")
    vorname = request.form.get("vorname")
    nachname = request.form.get("nachname")
    email = request.form.get("email")
    passwort = request.form.get("passwort")

    print(f"Neuer Benutzer: {anrede} {vorname} {nachname} | {email}")

    with open("registrierte_nutzer.txt", "a", encoding="utf-8") as f:
        f.write(f"{anrede};{vorname};{nachname};{email};{passwort}\n")

    session["user"] = email
    session["success"] = "Registrierung erfolgreich. Willkommen!"
    return redirect(url_for("index"))

@app.route("/adress_liste")
def adress_liste():
    if "user" in session:
        return render_template("adress_liste.html", addresses=address_data, user=session["user"])
    return redirect(url_for("index"))

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(debug=True, port=port)
