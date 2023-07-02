#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Flask_Session.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/FLASK_App_02/My_Bootstrap_Flask_App.py
#
# Description: FLASK Web-Applikation with Sessions (Login)
# https://www.geeksforgeeks.org/how-to-use-flask-session-in-python-flask/
#
#
# Autor: Walter Rothlin
#
# History:
# 17-Apr-2023   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
# from flask import Flask, redirect, url_for, render_template
from flask import Flask, render_template, request, redirect, url_for, session


app = Flask(__name__)
app.secret_key = 'geheimnis'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"


@app.route("/")
def home():
    print('home() called!!!')
    return render_template("index.html")

@app.route("/profile")
def profile():
    print('profile() called!!!')
    return render_template("contact.html")

@app.route("/adress_liste")
def adress_liste():
    print('adress_liste() called!!!')
    if session is not None and 'username' in session and session['username'] is not None:
        return render_template("adress_liste.html")
    else:
        return render_template("index.html")


# Login / Logout Functions
# ========================
@app.route('/registration', methods=['GET', 'POST'])
def registration():
    print('registration() called!!!')
    if request.method == 'POST':
        anrede = request.form.get("anrede")
        vorname = request.form['vorname']
        nachname = request.form['nachname']
        email = request.form['email']
        password = request.form['password']

        # Hier könnten Sie den Code einfügen, um einen neuen User zu registrieren
        # -----------------------------------------------------------------------
        print("New registered::", anrede, vorname, nachname, email, password)

        recipient = request.form.get("email")
        subject = "Registrierung"
        body = "Guten Tag " + anrede + " " + vorname + " " + nachname + ". Vielen Danke für die Registrierung auf unserer Seite. Ihr Password lautet: " + password

        ### message = Message(subject=subject, recipients=[recipient], body=body, sender='anrima.hwz@gmail.com')

        try:
            ### mail.send(message)
            return redirect("/")
        except Exception as e:
            return str(e)

        return render_template('index.html')
    return render_template('registration.html')

@app.route('/password_reset', methods=['GET', 'POST'])
def password_reset():
    print('password_reset() called!!!')
    if request.method == 'POST':
        email = request.form['email']
        # Hier könnten Sie den Code einfügen, um eine E-Mail mit der Mail-Adresse und dem Passwort zu senden
        print("Passwort zurücksetzen für E-Mail:", email)  # Zum Testen nur Ausgabe im Terminal
        recipient = email
        subject = "Password Reset"
        body = "Dein neues Passwort lautet neuwsPW"

        ### message = Message(subject=subject, recipients=[recipient], body=body, sender='info@blabla.ch')

        try:
            ### mail.send(message)  # E-Mail senden
            return redirect("/")
        except Exception as e:
            return str(e)


        return render_template('index.html')
    return render_template('password_reset.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    print('login() called!!!')
    if request.method == 'POST':
        username = request.form['email']
        password = request.form['password']
        # Hier könnten Sie den Code einfügen, das Passwort für einen Benutzer zu überprüfen
        if len(password) > 5:
            session['username'] = username
            return render_template("index.html")
    return render_template("index.html")

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    if request.method == 'POST':
        if 'stay_logged_in' in request.form:
            return render_template("index.html")
        else:
            session.pop('username', None)
            return render_template("index.html")
    return render_template("index.html")

if __name__ == "__main__":
    app.run(debug=True, port=5001)

