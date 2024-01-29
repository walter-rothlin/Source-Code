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
    print('profile() called!')
    return render_template("contact.html")


@app.route("/adress_orte_liste", methods=['GET', 'POST'])
def adress_orte_liste():
    print('adress_orte_liste() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        if request.method == 'POST':
            s_criteria = request.form.get("search_criteria")
        else:
            s_criteria = request.args.get("search_criteria")
        s_criteria = s_criteria.replace("'", "")

        rs = genossame.get_addr_ort_details_from_DB_by_ID(search_criterium=s_criteria)
        print(rs)
        rec_found = len(rs)
        # print('s_criteria:', s_criteria, '    Anz Rec found: ', rec_found)
        return render_template("adress_ort_liste.html", result_liste=rs, search_criterium=s_criteria, rec_found=rec_found)
    else:
        return render_template("index.html")

@app.route("/adresse_orte_details", methods=['GET', 'POST'])
def adresse_orte_details():
    print('adresse_orte_details() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        if request.method == 'POST':
            id = request.form.get("id")
        else:
            id = request.args.get("id")

        rs = genossame.get_addr_ort_details_from_DB_by_ID(id=id)
        print(rs)
        return render_template("adresse_orte_details.html", details=rs[0])
    else:
        return render_template("index.html")


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
        # print(rs)
        rec_found = len(rs)
        # print('s_criteria:', s_criteria, '    Anz Rec found: ', rec_found)
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
        iban_details = genossame.get_Pers_Details_for_Pers_ID(id=pid)
        email_details = genossame.get_Pers_Details_for_Pers_ID(id=pid, table_name='eMail_liste', id_name='Pers_ID', attr_liste=['Email_ID AS ID', 'eMail_adresse AS email', 'Prio AS Prio', 'Type AS Type'])
        telnr_details = genossame.get_Pers_Details_for_Pers_ID(id=pid, table_name='telnr_liste', id_name='Pers_ID', attr_liste=['Tel_ID AS ID', 'Laendercode', 'Vorwahl', 'Nummer', 'Prio', 'Type', 'Endgeraet'])
        return render_template("person_details.html", details=rs[0], iban_details=iban_details, email_details=email_details, telnr_details=telnr_details)
    else:
        return render_template("index.html")

@app.route("/modify_iban_telnr_email", methods=['GET', 'POST'])
def show_modify_iban_telnr_email():
    print('show_modify_iban_telnr_email() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        if request.method == 'POST':
            pid = request.form.get("pid")
            change_type = request.form.get("change_type")
        else:
            pid = request.args.get("pid")
            change_type = request.args.get("change_type")

        # print('pid        :', pid)
        # print('change_type:', change_type)

        rs = genossame.get_person_details_from_DB_by_ID(id=pid)
        # print(rs)
        iban_details = genossame.get_Pers_Details_for_Pers_ID(id=pid)
        email_details = genossame.get_Pers_Details_for_Pers_ID(id=pid, table_name='eMail_liste', id_name='Pers_ID', attr_liste=['Email_ID AS ID', 'eMail_adresse AS email', 'Prio AS Prio', 'Type AS Type'])
        telnr_details = genossame.get_Pers_Details_for_Pers_ID(id=pid, table_name='telnr_liste', id_name='Pers_ID', attr_liste=['Tel_ID AS ID', 'Laendercode', 'Vorwahl', 'Nummer', 'Prio', 'Type', 'Endgeraet'])
        return render_template("iban_telnr_email_liste.html", change_type=change_type, details=rs[0], iban_details=iban_details, email_details=email_details, telnr_details=telnr_details)
    else:
        return render_template("index.html")

@app.route("/iban_telnr_email_Change", methods=['GET', 'POST'])
def iban_telnr_email_Change():
    print('iban_telnr_email_Change() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        if request.method == 'POST':
            pid = request.form.get("pid")
            id = request.form.get("id")
            change_type = request.form.get("change_type")
        else:
            pid = request.args.get("pid")
            id = request.args.get("id")
            change_type = request.args.get("change_type")

        # print('pid        :', pid)
        # print('id         :', id)
        # print('change_type:', change_type)

        rs = genossame.get_person_details_from_DB_by_ID(id=pid)
        # print(rs)
        iban_details = genossame.get_Pers_Details_for_Pers_ID(id=id, table_name='iban', id_name='ID', attr_liste=['*'])
        email_details = genossame.get_Pers_Details_for_Pers_ID(id=id, table_name='email_adressen', id_name='ID', attr_liste=['*'])
        telnr_details = genossame.get_Pers_Details_for_Pers_ID(id=id, table_name='telefonnummern', id_name='ID', attr_liste=['*'])
        return render_template("iban_telnr_email_liste_Change.html", change_type=change_type, details=rs[0], iban_details=iban_details, email_details=email_details, telnr_details=telnr_details)
    else:
        return render_template("index.html")

@app.route("/iban_telnr_email_Delete", methods=['GET', 'POST'])
def iban_telnr_email_Delete():
    print('iban_telnr_email_Delete() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        if request.method == 'POST':
            pid = request.form.get("pid")
            id = request.form.get("id")
            change_type = request.form.get("change_type")
        else:
            pid = request.args.get("pid")
            id = request.args.get("id")
            change_type = request.args.get("change_type")

        # print('pid        :', pid)
        # print('id         :', id)
        # print('change_type:', change_type)

        genossame.delete_iban_telnr_email(pid=pid, change_type=change_type, id=id)

        rs = genossame.get_person_details_from_DB_by_ID(id=pid)
        # print(rs)
        iban_details = genossame.get_Pers_Details_for_Pers_ID(id=pid)
        email_details = genossame.get_Pers_Details_for_Pers_ID(id=pid, table_name='eMail_liste', id_name='Pers_ID', attr_liste=['Email_ID AS ID', 'eMail_adresse AS email', 'Prio AS Prio', 'Type AS Type'])
        telnr_details = genossame.get_Pers_Details_for_Pers_ID(id=pid, table_name='telnr_liste', id_name='Pers_ID', attr_liste=['Tel_ID AS ID', 'Laendercode', 'Vorwahl', 'Nummer', 'Prio', 'Type', 'Endgeraet'])
        return render_template("iban_telnr_email_liste.html", change_type=change_type, details=rs[0], iban_details=iban_details, email_details=email_details, telnr_details=telnr_details)
    else:
        return render_template("index.html")



@app.route("/update_iban_telnr_email", methods=['GET', 'POST',])
def execute_update_iban_telnr_email():
    print('execute_update_iban_telnr_email() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())
        print('all_parameters:', all_parameters)

        pid = all_parameters['Pers_ID']
        id = all_parameters['ID']
        change_type = all_parameters['Change_Type']

        # Update DB
        genossame.update_iban_telnr_email(pid=pid, id=id, new_name_values=all_parameters)

        # Show modified List
        # print('pid        :', pid)
        # print('id         :', id)
        # print('change_type:', change_type)
        rs = genossame.get_person_details_from_DB_by_ID(id=pid)
        iban_details = genossame.get_Pers_Details_for_Pers_ID(id=pid)
        email_details = genossame.get_Pers_Details_for_Pers_ID(id=pid, table_name='eMail_liste', id_name='Pers_ID', attr_liste=['Email_ID AS ID', 'eMail_adresse AS email', 'Prio AS Prio', 'Type AS Type'])
        telnr_details = genossame.get_Pers_Details_for_Pers_ID(id=pid, table_name='telnr_liste', id_name='Pers_ID', attr_liste=['Tel_ID AS ID', 'Laendercode', 'Vorwahl', 'Nummer', 'Prio', 'Type', 'Endgeraet'])
        return render_template("iban_telnr_email_liste.html", change_type=change_type, details=rs[0], iban_details=iban_details, email_details=email_details, telnr_details=telnr_details)
    else:
        return render_template("index.html")


@app.route("/do_insert_new_iban_telnr_email", methods=['GET', 'POST'])
def execute_insert_iban_telnr_email():
    print('execute_insert_iban_telnr_email() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())  # Form data parameters
        # print('all_parameters:', all_parameters)

        pid = all_parameters['pid']
        change_type = all_parameters['change_type']

        # create new data set
        id = genossame.new_iban_telnr_email(pid=pid, change_type=change_type, new_name_values=all_parameters)

        # Show inserted record in GUI for modify
        # print('pid        :', pid)
        # print('id         :', id)
        # print('change_type:', change_type)

        # redirect to change screen
        ## nops = redirect(f"{url_for('iban_telnr_email_Change')}?change_type={change_type}&pid={all_parameters['pid']}&id={id}")
        return redirect(f"{url_for('show_modify_iban_telnr_email')}?change_type={change_type}&pid={all_parameters['pid']}")
    else:
        return render_template("index.html")
@app.route("/update_person_details", methods=['GET', 'POST'])
def execute_update_person_details():
    print('update_person_details() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())  # Form data parameters

        # Update DB
        update_status = genossame.update_pers_details_by_ID(new_name_values=all_parameters)
        # print('update_status for ', all_parameters['ID'], ':', update_status)

        # Show updated details
        rs = genossame.get_person_details_from_DB_by_ID(id=all_parameters['ID'])
        return render_template("person_details.html", details=rs[0])
    else:
        return render_template("index.html")

@app.route("/modify_single_person", methods=['GET', 'POST'])
def show_modify_single_person():
    print('modify_single_person() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        if request.method == 'POST':
            pid = request.form.get("pid")
        else:
            pid = request.args.get("pid")

        rs = genossame.get_person_details_from_DB_by_ID(id=pid)
        # print(rs)

        iban_details = genossame.get_Pers_Details_for_Pers_ID(id=pid)
        email_details = genossame.get_Pers_Details_for_Pers_ID(id=pid, table_name='eMail_liste', id_name='Pers_ID', attr_liste=['Email_ID AS ID', 'eMail_adresse AS email', 'Prio AS Prio', 'Type AS Type'])
        telnr_details = genossame.get_Pers_Details_for_Pers_ID(id=pid, table_name='telnr_liste', id_name='Pers_ID', attr_liste=['Tel_ID AS ID', 'Laendercode', 'Vorwahl', 'Nummer', 'Prio', 'Type', 'Endgeraet'])
        return render_template("person_Change.html", details=rs[0], iban_details=iban_details, email_details=email_details, telnr_details=telnr_details)
    else:
        return render_template("index.html")

@app.route("/do_insert_new_person", methods=['GET', 'POST',])
def execute_insert_person():
    print('execute_insert_person() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())  # Form data parameters
        # print('all_parameters:', all_parameters)

        # insert into DB
        id = genossame.insert_new_person(new_name_values=all_parameters)
        # print('execute_insert_person for ', id)

        # show changed data-set
        rs = genossame.get_person_details_from_DB_by_ID(id=id)
        return render_template("person_Change.html", details=rs[0])
    else:
        return render_template("index.html")
@app.route("/new_person", methods=['GET', 'POST'])
def show_new_single_person():
    print('show_new_single_person() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        return render_template("person_New.html", details={})
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

@app.route("/excec_important_pers_updates", methods=['GET', 'POST'])
def exec_important_db_updates():
    print('exec_important_db_updates() called!!!')
    if session is not None and 'user_name' in session and session['user_name'] is not None:
        execute_important_sql_queries(genossame.get_db_connection())
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
        '''
        isabella.vogt@bluewin.ch
        walter@rothlin.com
        landwirtschaft@genossame-wangen.ch
        
        PWD_Hallo
        '''

        password_is_correct, user_id = genossame.is_password_correct(username, password)
        # print('login():: password_is_correct:', password_is_correct, '   user_id:', user_id)
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
    app.run(debug=True, host='0.0.0.0', port=8080)

