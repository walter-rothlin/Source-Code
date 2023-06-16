from flask import Flask, render_template, request, url_for, request, redirect, session
from flask_session import Session
from flask_mail import Mail, Message

app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
app.config['MAIL_SERVER'] = 'smtp.gmail.com'  # SMTP-Server-Adresse
app.config['MAIL_PORT'] = 587  # SMTP-Server-Port
app.config['MAIL_USE_TLS'] = True  # TLS-Verschlüsselung aktivieren
app.config['MAIL_USERNAME'] = 'anrima.hwz@gmail.com'  # Deine E-Mail-Adresse
app.config['MAIL_PASSWORD'] = 'hxjutafqauhxdovq'
app.config['MAIL_SENDER'] = 'anrima.hwz@gmail.com'
Session(app)
mail = Mail(app)


@app.route("/")
def index():
    return render_template('index.html')


@app.route("/login", methods=["POST", "GET"])
def login():
    if request.method == "POST":
        session["username"] = request.form.get("username")
        password = request.form.get("password")
        if password and len(request.form.get("password")) >= 5:
            session["password"] = request.form.get("password")
            return redirect("/")
    return render_template("/")


@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/addresslist')
def address():
    return render_template('addresslist.html', css_styles="static/css/main.css")


@app.route("/logout")
def logout():
    session["username"] = None
    session["password"] = None
    return redirect("/")



@app.route('/password-reset', methods=['POST','GET'])
def passwordReset():

    recipient = request.form.get("email")
    subject = "Password Reset"
    body = "Dein neues Passwort lautet neuwsPW"

    # E-Mail erstellen
    message = Message(subject=subject, recipients=[recipient], body=body, sender='anrima.hwz@gmail.com')

    try:
        mail.send(message)  # E-Mail senden
        return redirect("/")
    except Exception as e:
        return str(e)  # Fehlermeld


@app.route('/register', methods=['POST','GET'])
def register():



    anrede = request.form.get("anrede")
    vorname = request.form.get("vorname")
    name = request.form.get("name")
    password = request.form.get("password")

    recipient = request.form.get("email")
    subject = "Registrierung"
    body = "Guten Tag "+anrede+" "+vorname+" "+name+". Vielen Danke für die Registrierung auf unserer Seite. Ihr Password lautet: "+password

    # E-Mail erstellen
    message = Message(subject=subject, recipients=[recipient], body=body, sender='anrima.hwz@gmail.com')

    try:
        mail.send(message)
        return redirect("/")
    except Exception as e:
        return str(e)  #


if __name__ == "__main__":
    app.run(debug=True)
