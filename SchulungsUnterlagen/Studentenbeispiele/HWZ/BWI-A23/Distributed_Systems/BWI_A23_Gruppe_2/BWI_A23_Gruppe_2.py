from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__)
app.secret_key = "secret123"

## JINJA
@app.route("/")
def home():
    return render_template("index.html")


@app.route("/kontakt")
def kontakt():
    name = request.args.get("name")
    return render_template("kontakt.html", name=name)


@app.route("/login")
def login_page():
    return render_template("login.html")

## POST methode wird im URL nicht angezeigt
@app.route("/login", methods=["POST"])
def login():

    # email check im HTML als type = email
    email = request.form.get("email")
    password = request.form.get("password")

    if len(password) > 5:
        session["user"] = email
        return redirect(url_for("home"))

    else:
        return render_template(
        "login.html",
        error="Passwort muss länger als 5 Zeichen sein."
    )


@app.route("/logout")
def logout():

    session.pop("user", None)

    return redirect(url_for("home"))


@app.route("/adress-liste")
def adress_liste():

    if "user" not in session:
        return redirect(url_for("login_page"))

    adressen = [
        {
            "vorname": "Ashley",
            "nachname": "Catanjal",
            "adresse": "Bahnhofstrasse 10",
            "ort": "Zürich"
        },
        {
            "vorname": "Nicole",
            "nachname": "Höppli",
            "adresse": "Dorfweg 5",
            "ort": "Winterthur"
        },
        {
            "vorname": "Natalie",
            "nachname": "Singh",
            "adresse": "Seestrasse 22",
            "ort": "Luzern"
        }
    ]

    return render_template(
        "adress_liste.html",
        adressen=adressen
    )


if __name__ == "__main__":
    app.run(debug=True, host='127.0.0.1', port=5001)