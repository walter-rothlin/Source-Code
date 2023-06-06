from flask import Flask, render_template, request, url_for, request, redirect, session, make_response, flash, jsonify
from flask_session import Session

app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
app.config["SECRET_KEY"] = 'DasIstEinSecretKey'
Session(app)

@app.route('/')
def index():
    email = session.get("email")
    return render_template('index.html', dictionary=handleLogin(email))

@app.route('/kontakt')
def kontakt():
    email = session.get("email")
    return render_template('kontakt.html', dictionary=handleLogin(email))

@app.route('/adress_liste')
def adress_liste():
    email = session.get("email")

    return render_template('adress_liste.html', dictionary=handleLogin(email))

@app.route('/logout')
def logout():
    session["email"] = None
    return redirect(url_for('index'))

@app.route('/login', methods=["POST", "GET"])
def login():
    email = session.get("email")
    if request.method == "POST":
        session["email"] = request.form.get("email")
        return redirect("/")
    return render_template("login.html", dictionary=handleLogin(email))

def handleLogin(email):
    logged_in = False
    if email is not None:
        logged_in = True

    return {
        "email": email,
        "logged_in": logged_in
    }


if __name__ == '__main__':
   app.run()