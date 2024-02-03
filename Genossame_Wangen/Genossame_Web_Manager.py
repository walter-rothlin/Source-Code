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
    print(f'{getTimestamp()}: home() called!!!')
    return render_template("index.html")

@app.route("/profile")
def profile():
    print(f'{getTimestamp()}: profile() called!')
    return render_template("contact.html")

@app.route("/orte_liste", methods=['GET', 'POST'])
def orte_liste():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: orte_liste()')
    if get_session_attibute(session, "user_name") != 'None':
        if request.method == 'POST':
            s_criteria = request.form.get("search_criteria")
        else:
            s_criteria = request.args.get("search_criteria")

        # print(f'session:{session}')
        if s_criteria is None or s_criteria == '':
            s_criteria = session.get(session_attr_scriteria_orte_list, 'Peterliwiese')
        else:
            s_criteria = s_criteria.replace("'", "")
            session[session_attr_scriteria_orte_list] = s_criteria
        # print(f's_criteria:{s_criteria}')

        genossame.check_and_reconnect_db()
        rs = genossame.get_ort_details_from_DB_by_ID(search_criterium=s_criteria)
        # print(rs)
        rec_found = len(rs)
        # print('s_criteria:', s_criteria, '    Anz Rec found: ', rec_found)
        return render_template("ort_liste.html", result_liste=rs, search_criterium=s_criteria, rec_found=rec_found)
    else:
        return render_template("index.html")

@app.route("/adress_orte_liste", methods=['GET', 'POST'])
def adress_orte_liste():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: adress_orte_liste()')
    if get_session_attibute(session, "user_name") != 'None':
        if request.method == 'POST':
            s_criteria = request.form.get("search_criteria")
        else:
            s_criteria = request.args.get("search_criteria")

        # print(f'session:{session}')
        if s_criteria is None or s_criteria == '':
            s_criteria = session.get(session_attr_scriteria_addr_orte_list, 'SZ')
        else:
            s_criteria = s_criteria.replace("'", "")
            session[session_attr_scriteria_addr_orte_list] = s_criteria
        # print(f's_criteria:{s_criteria}')

        genossame.check_and_reconnect_db()
        rs = genossame.get_addr_ort_details_from_DB_by_ID(search_criterium=s_criteria, tabel_name='Adress_Daten')
        # print(rs)
        rec_found = len(rs)
        # print('s_criteria:', s_criteria, '    Anz Rec found: ', rec_found)
        return render_template("adress_ort_liste.html", result_liste=rs, search_criterium=s_criteria, rec_found=rec_found)
    else:
        return render_template("index.html")


@app.route("/adresse_orte_details", methods=['GET', 'POST'])
def adresse_orte_details():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: adresse_orte_details()')
    if get_session_attibute(session, "user_name") != 'None':
        if request.method == 'POST':
            id = request.form.get("id")
        else:
            id = request.args.get("id")

        genossame.check_and_reconnect_db()
        rs = genossame.get_addr_ort_details_from_DB_by_ID(id=id, tabel_name='Adress_Daten')
        # print(rs)
        return render_template("adresse_orte_details.html", details=rs[0])
    else:
        return render_template("index.html")

@app.route("/show_modify_single_address_ort", methods=['GET', 'POST'])
def show_modify_single_address_ort():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: show_modify_single_address_ort()')
    if get_session_attibute(session, "user_name") != 'None':
        if request.method == 'POST':
            id = request.form.get("id")
        else:
            id = request.args.get("id")

        genossame.check_and_reconnect_db()
        rs = genossame.get_addr_ort_details_from_DB_by_ID(id=id, tabel_name='Adress_Daten')
        # print(rs)
        return render_template("adress_ort_Change.html", details=rs[0])
    else:
        return render_template("index.html")

@app.route("/execute_update_address_ort", methods=['GET', 'POST',])
def execute_update_address_ort():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: execute_update_address_ort()')
    if get_session_attibute(session, "user_name") != 'None':
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())
        print('all_parameters:', all_parameters)

        id = all_parameters['ID']
        # Update DB
        genossame.check_and_reconnect_db()
        genossame.update_adress_ort(id=id, new_name_values=all_parameters)

        # Show modified List
        # print('id         :', id)
        rs = genossame.get_addr_ort_details_from_DB_by_ID(id=id, tabel_name='Adress_Daten')
        # print(rs)
        return render_template("adresse_orte_details.html", details=rs[0])
    else:
        return render_template("index.html")

@app.route("/adress_liste", methods=['GET', 'POST'])
def adress_liste():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: adress_liste()')
    if get_session_attibute(session, "user_name") != 'None':
        if request.method == 'POST':
            s_criteria = request.form.get("search_criteria")
        else:
            s_criteria = request.args.get("search_criteria")

        # print(f'session:{session}')
        if s_criteria is None or s_criteria == '':
            s_criteria = session.get(session_attr_scriteria_addr_list, 'Rothlin Walter')
        else:
            s_criteria = s_criteria.replace("'", "")
            session[session_attr_scriteria_addr_list] = s_criteria
        # print(f's_criteria:{s_criteria}')

        genossame.check_and_reconnect_db()
        rs = genossame.get_person_details_from_DB_by_ID(search_criterium=s_criteria)
        # print(rs)
        rec_found = len(rs)
        # print('s_criteria:', s_criteria, '    Anz Rec found: ', rec_found)
        return render_template("adress_liste.html", result_liste=rs, search_criterium=s_criteria, rec_found=rec_found)
    else:
        return render_template("index.html")

@app.route("/personen_details", methods=['GET', 'POST'])
def personen_details():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: personen_details()')
    if get_session_attibute(session, "user_name") != 'None':
        if request.method == 'POST':
            pid = request.form.get("pid")
        else:
            pid = request.args.get("pid")

        genossame.check_and_reconnect_db()
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
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: show_modify_iban_telnr_email()')
    if get_session_attibute(session, "user_name") != 'None':
        if request.method == 'POST':
            pid = request.form.get("pid")
            change_type = request.form.get("change_type")
        else:
            pid = request.args.get("pid")
            change_type = request.args.get("change_type")

        # print('pid        :', pid)
        # print('change_type:', change_type)

        genossame.check_and_reconnect_db()
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
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: iban_telnr_email_Change()')
    if get_session_attibute(session, "user_name") != 'None':
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

        genossame.check_and_reconnect_db()
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
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: iban_telnr_email_Delete()')
    if get_session_attibute(session, "user_name") != 'None':
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

        genossame.check_and_reconnect_db()
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
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: execute_update_iban_telnr_email()')
    if get_session_attibute(session, "user_name") != 'None':
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())
        # print('all_parameters:', all_parameters)

        pid = all_parameters['Pers_ID']
        id = all_parameters['ID']
        change_type = all_parameters['Change_Type']

        # Update DB
        genossame.check_and_reconnect_db()
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
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: execute_insert_iban_telnr_email()')
    if get_session_attibute(session, "user_name") != 'None':
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())  # Form data parameters
        # print('all_parameters:', all_parameters)

        pid = all_parameters['pid']
        change_type = all_parameters['change_type']

        # create new data set
        genossame.check_and_reconnect_db()
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
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: execute_update_person_details()')
    if get_session_attibute(session, "user_name") != 'None':
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())  # Form data parameters

        # Update DB
        update_status = genossame.update_pers_details_by_ID(new_name_values=all_parameters)
        # print('update_status for ', all_parameters['ID'], ':', update_status)

        # Show updated details
        genossame.check_and_reconnect_db()
        rs = genossame.get_person_details_from_DB_by_ID(id=all_parameters['ID'])
        return render_template("person_details.html", details=rs[0])
    else:
        return render_template("index.html")

@app.route("/modify_single_person", methods=['GET', 'POST'])
def show_modify_single_person():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: show_modify_single_person()')
    if get_session_attibute(session, "user_name") != 'None':
        if request.method == 'POST':
            pid = request.form.get("pid")
        else:
            pid = request.args.get("pid")

        genossame.check_and_reconnect_db()
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
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: execute_insert_person()')
    if get_session_attibute(session, "user_name") != 'None':
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())  # Form data parameters
        # print('all_parameters:', all_parameters)

        # insert into DB
        genossame.check_and_reconnect_db()
        id = genossame.insert_new_person(new_name_values=all_parameters)
        # print('execute_insert_person for ', id)

        # show changed data-set
        rs = genossame.get_person_details_from_DB_by_ID(id=id)
        return render_template("person_Change.html", details=rs[0])
    else:
        return render_template("index.html")

@app.route("/execute_insert_adresse", methods=['GET', 'POST',])
def execute_insert_adresse():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: execute_insert_adresse()')
    if get_session_attibute(session, "user_name") != 'None':
        all_parameters = dict(request.args.items())  # Query string parameters
        all_parameters.update(request.form.to_dict())  # Form data parameters
        print('all_parameters:', all_parameters)

        # insert into DB
        genossame.check_and_reconnect_db()
        id = genossame.insert_new_adresse(new_name_values=all_parameters)
        # print('execute_insert_adresse for ', id)

        # show changed data-set
        rs = genossame.get_addr_ort_details_from_DB_by_ID(id=id)
        # print(rs)
        return render_template("adress_ort_Change.html", details=rs[0])
    else:
        return render_template("index.html")

@app.route("/new_adresse", methods=['GET', 'POST'])
def show_new_single_adresse():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: show_new_single_adresse()')
    if get_session_attibute(session, "user_name") != 'None':
        return render_template("adresse_New.html", details={'Ort_ID': '4797', 'Politisch_Wangen': 0})
    else:
        return render_template("index.html")

@app.route("/new_person", methods=['GET', 'POST'])
def show_new_single_person():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: show_new_single_person()')
    if get_session_attibute(session, "user_name") != 'None':
        return render_template("person_New.html", details={})
    else:
        return render_template("index.html")

@app.route("/delete_single_person", methods=['GET', 'POST'])
def delete_single_person():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: delete_single_person()')
    if get_session_attibute(session, "user_name") != 'None':
        if request.method == 'POST':
            pid = request.form.get("pid")
        else:
            pid = request.args.get("pid")

        genossame.check_and_reconnect_db()
        rs = genossame.get_person_details_from_DB_by_ID(id=pid)
        # print(rs)
        # print('pid:', pid, '    Anz Rec found: ', len(rs))
        return render_template("person_details.html", details=rs[0])
    else:
        return render_template("index.html")

@app.route("/excec_important_pers_updates", methods=['GET', 'POST'])
def exec_important_db_updates():
    print(f'{getTimestamp()}: {get_session_attibute(session, "user_name"):40s}: exec_important_db_updates()')
    if get_session_attibute(session, "user_name") != 'None':
        genossame.check_and_reconnect_db()
        execute_important_sql_queries(genossame.get_db_connection())
    return render_template("index.html")

# Login / Logout Functions
# ========================
@app.route('/registration', methods=['GET', 'POST'])
def registration():
    print(f'{getTimestamp()}: registration() called!!!')
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
    print(f'{getTimestamp()}: password_reset() called!!!')
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
    print(f'{getTimestamp()}: login() called!!!')
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
        session[session_attr_scriteria_addr_list] = 'Walter'
        session[session_attr_scriteria_addr_orte_list] = 'Peterliwiese'
        session[session_attr_scriteria_orte_list] = 'SZ'
        if password_is_correct:
            session['user_name'] = username
            session['user_id'] = user_id
            session['user_priv'] = genossame.get_priviliges_for_pers_ID(user_id)
            print('session:', session)
            return render_template("index.html")
    return render_template("index.html")

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    print(f'{getTimestamp()}: logout() called!!!')
    if request.method == 'POST':
        if 'stay_logged_in' in request.form:
            return render_template("index.html")
        else:
            print('session löschen!!')
            print('session:', session)
            session.clear()
            print('session:', session)

            return render_template("index.html")
    return render_template("index.html")

if __name__ == "__main__":
    genossame = Stammdaten()
    app.run(debug=True, host='0.0.0.0', port=8080)

