#Author: David Radovanovic
#Datum: 01.06.2023
#Fach: BWI-A20-6 Distributed und Mobile Systems
#Prüfung.
################################################################################################


#Imports
import secrets
from Forms import RegistrationForm, LoginForm
from datetime import timedelta
from Adress_Data import ADRESS_DATA
#Flask-Imports
from flask import Flask, render_template, request, jsonify, session, redirect, url_for, flash
from flask_session import Session


#Benötigte Parameter für Session
app = Flask(__name__)
app.config["SECRET_KEY"] = secrets.token_hex(16)
app.config["SESSION_TYPE"] = "filesystem"
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=30)

#Hier wird die Session erstellt beim Start.
Session(app)

#Welcome Page
@app.route('/')
@app.route('/home')
def index1():
    if 'username' in session:
        return render_template('index.html', title='Welcome Page', username=session['username'])
    else:
        return render_template('index.html', title='Welcome Page')

#Kontakt Page
@app.route('/kontakt')
def kontakt1():
    if 'username' in session:
        return render_template('kontakt.html', title='Kontakt', username=session['username'])
    else:
        return render_template('kontakt.html', title='Kontakt')

#SESSION HANDLING ########################################################
# Diese Funktion behandelt die Registrierung von Benutzern.
# Sie erzeugt ein Registrierungsformular und validiert die Eingabe des Benutzers.
@app.route("/registration", methods=['GET', 'POST'])
def register1():
    form = RegistrationForm()
    if form.validate_on_submit():
        flash(f'Account wurde erstellt: {form.email.data} !','success')
        session['username'] = form.email.data
        return redirect(url_for('index1'))
    return render_template('registration.html', title='Registration', form=form)

#  Diese Funktion behandelt das Login von Benutzern.
#  Wenn die Eingabe korrekt ist  wird eine Sitzung für den Benutzer erstellt
@app.route("/login", methods=['GET', 'POST'])
def login1():
    form = LoginForm()
    if form.validate_on_submit():
        if len(form.password.data) > 5:
            session['username'] = form.email.data
            flash(f'Willkommen {form.email.data} !', 'success')
            return redirect(url_for('index1'))
        else:
            flash(f'Falsches Login', 'danger')
    return render_template('login.html', title='Login', form=form)

# Diese Funktion loggt den User aus und löscht die Session.
@app.route("/logout")
def logout1():
    session.clear()
    flash('Sie haben sich erfolgreich ausgeloggt', 'success')
    return redirect(url_for('login1'))


#Anpassung der ADRESS-DATA##########################################
# Bei einem GET-Request wird das 'adress_liste.html'-Template mit den aktuellen ADRESS_DATA abgefüllt.
# Bei einem POST-Request wird ein neuer Eintrag zu ADRESS_DATA hinzugefügt,
# basierend auf den im Formular enthaltenen Daten.
@app.route("/adressliste", methods=['GET', 'POST'])
def adressliste1():
    if request.method == 'POST':
        lastName = request.form.get("lastName", default=None)
        firstName = request.form.get("firstName", default=None)
        adresse = request.form.get("adresse", default=None)
        nummer = request.form.get("nummer", default=None)

        if lastName and firstName:
            new_entry = {
                'key': len(ADRESS_DATA) + 1,
                'lastName': lastName,
                'firstName': firstName,
                'adresse': adresse,
                'nummer': nummer,
            }
            ADRESS_DATA.append(new_entry)

    response_data = {
        'Uberschrift': 'Turnverein',
        'adress_data': ADRESS_DATA
    }
    return render_template('adress_liste.html', data=response_data, title='Adress Liste', username=session['username'])


##############################################
#MAIN
##############################################
if __name__ == '__main__':
    app.run(debug=True, port=5001)