from flask import Flask, request, render_template, redirect, session
from flask_session import Session

# FLASK SHINANIGANS
app = Flask(__name__)  # initialisiert die Flask App
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)


@app.route('/')
def index():
    return render_template("index.html", username=session.get("username"))

@app.route('/kontakt')
def kontakt():
    return render_template("kontakt.html", username=session.get("username"))

@app.route('/adress_liste')
def adress_liste():
    return render_template("adress_liste.html", username=session.get("username"))

@app.route('/login', methods=["POST", "GET"])
def login():

    # Einfacher Umweg zum Template anzeigen ausser User interagiert mit Form
    if request.method == "POST":
        session["username"] = request.form.get("username")
        session["password"] = request.form.get("password")

        return redirect("/")
    return render_template("login.html", username=session.get("username"))

@app.route('/logout', methods=["POST", "GET"])
def logout():

    session["username"] = None
    session["password"] = None

    return redirect("/")


if __name__ == '__main__':
    # Falls globale Calculationen erwünscht sind (Seitenübergreifend / unabhängig von refresh), hier platzieren
    app.run(debug=True, host='127.0.0.1', port=5001)  #Standard Lokalen-Run port per default = 5000