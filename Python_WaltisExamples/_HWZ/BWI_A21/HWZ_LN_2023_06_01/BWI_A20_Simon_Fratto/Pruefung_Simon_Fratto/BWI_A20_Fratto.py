from flask import Flask, request, render_template, redirect, make_response, url_for, session
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

app = Flask(__name__)
app.secret_key = "xyz"


@app.route('/', methods=['GET'])
def index():
    email = None
    if 'email' in session:
        email = session["email"]
    template = render_template('index.html', email=email)
    return template


@app.route('/kontakt', methods=['GET'])
def kontakt():
    email = None
    if 'email' in session:
        email = session["email"]
    template = render_template('kontakt.html', email=email)
    return template


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        session["email"] = request.form['email']
        return redirect(url_for('index'))


@app.route('/adressliste', methods=['GET'])
def adressliste():
    email = None
    if 'email' in session:
        email = session["email"]
    template = render_template('adress_liste.html', email=email)
    return template


@app.route('/logout', methods=['GET'])
def logout():
    session.pop('email', None)
    return redirect(url_for('index'))


@app.route('/passwortvergessen', methods=['GET', 'POST'])
def passwortvergessen():
    if request.method == 'GET':
        email = None
        if 'email' in session:
            email = session["email"]
        template = render_template('passwort_vergessen.html', email=email)
        return template
    if request.method == 'POST':
        message = MIMEMultipart()
        message["From"] = 'Mockup Adresse'
        message["To"] = 'Mockup Adresse'
        message["Subject"] = 'Registration'
        message.attach(MIMEText('''<a href="http://127.0.0.1:5001/">URL</a>''', "plain"))
        # Connect to the email server and send the email
        try:
            server = smtplib.SMTP("smtp.server.com", 587)
            server.starttls()
            server.login(message["From"], "<your_password>")
            server.sendmail(message["From"], message["To"], message.as_string())
            server.quit()
        except:
            pass
        return redirect(url_for('index'))


@app.route('/registrieren', methods=['GET', 'POST'])
def registrieren():
    if request.method == 'GET':
        email = None
        if 'email' in session:
            email = session["email"]
        template = render_template('registrieren.html', email=email)
        return template
    if request.method == 'POST':
        message = MIMEMultipart()
        message["From"] = 'Mockup Adresse'
        message["To"] = 'Mockup Adresse'
        message["Subject"] = 'Registration'
        message.attach(MIMEText('''<a href="http://127.0.0.1:5001/">URL</a>''', "html"))
        # Connect to the email server and send the email
        try:
            server = smtplib.SMTP("smtp.server.com", 587)
            server.starttls()
            server.login(message["From"], "<your_password>")
            server.sendmail(message["From"], message["To"], message.as_string())
            server.quit()
        except:
            pass
        return redirect(url_for('index'))


# Start Server
if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)
