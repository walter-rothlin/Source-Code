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
from Genossame_Common_Defs import *
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

@app.route("/adress_liste", methods=['GET', 'POST'])
def adress_liste():
    print('adress_liste() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        if request.method == 'POST':
            s_criteria = request.form.get("search_criteria")
        else:
            s_criteria = request.args.get("search_criteria")
        s_criteria = s_criteria.replace("'", "")
        rs = genossame.get_person_details_from_DB_by_ID(search_criterium=s_criteria)
        print(rs)
        rec_found = len(rs)
        print('s_criteria:', s_criteria, '    Anz Rec found: ', rec_found)
        return render_template("adress_liste.html", result_liste=rs, search_criterium=s_criteria, rec_found=rec_found)
    else:
        return render_template("index.html")

@app.route("/personen_details", methods=['GET', 'POST'])
def personen_details():
    print('personen_details() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        if request.method == 'POST':
            pid = request.form.get("pid")
        else:
            pid = request.args.get("pid")
        rs = genossame.get_person_details_from_DB_by_ID(id=pid)
        # print(rs)
        # print('pid:', pid, '    Anz Rec found: ', len(rs))
        return render_template("person_details.html", details=rs[0])
    else:
        return render_template("index.html")

@app.route("/update_person_details", methods=['GET', 'POST',])
def update_person_details():
    print('update_person_details() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())  # Form data parameters
        genossame.update_pers_details_by_ID(new_name_values=all_parameters)
        return render_template("adress_liste.html")
    else:
        return render_template("index.html")

@app.route("/modify_single_person", methods=['GET', 'POST'])
def modify_single_person():
    # print('modify_single_person() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        if request.method == 'POST':
            pid = request.form.get("pid")
        else:
            pid = request.args.get("pid")
        rs = genossame.get_person_details_from_DB_by_ID(id=pid)
        return render_template("person_Change.html", details=rs[0])
    else:
        return render_template("index.html")

@app.route("/delete_single_person", methods=['GET', 'POST'])
def delete_single_person():
    print('delete_single_person() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        if request.method == 'POST':
            pid = request.form.get("pid")
        else:
            pid = request.args.get("pid")
        rs = genossame.get_person_details_from_DB_by_ID(id=pid)
        # print(rs)
        # print('pid:', pid, '    Anz Rec found: ', len(rs))
        return render_template("person_details.html", details=rs[0])
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
        #  password = 'PWD_Hallo'

        password_is_correct, user_id = genossame.is_password_correct(username, password)
        # print('password_is_correct:', password_is_correct, '   user_id:', user_id)
        if password_is_correct:
            session['user_name'] = username
            session['user_id'] = user_id
            session['user_priv'] = genossame.get_priviliges_for_pers_ID(user_id)
            print('session:', session)
            return render_template("index.html")
    return render_template("index.html")

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    if request.method == 'POST':
        if 'stay_logged_in' in request.form:
            return render_template("index.html")
        else:
            session.pop('user_name', None)
            session.pop('user_id', None)
            session.pop('user_priv', None)
            return render_template("index.html")
    return render_template("index.html")

if __name__ == "__main__":
    genossame = Stammdaten()
    app.run(debug=True, port=5002)

