#!/usr/bin/python
from flask import Flask, request, render_template, url_for, session, redirect
import requests
import json
import urllib3

urllib3.disable_warnings(
    urllib3.exceptions.InsecureRequestWarning
)

ip_adr = '192.168.107.161'
port_nr = 5001


app = Flask(__name__)
app.secret_key = 'HalloHFU2025'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"

def is_password_valid(username, password, application='Geno_Intranet'):
    request_url = f'https://strom.genossame-wangen.ch/crm/is_password_valid?Username={username}&Password={password}&Application={application}'
    # print(request_url)
    
    response = requests.get(request_url)
    responseStr = response.text
    jsonResponse = json.loads(responseStr)
    
    password_matches = jsonResponse['password_matches']
    
    return password_matches, jsonResponse

@app.route('/', methods=['GET', 'POST'])
def index():
    if not session.get("username"):
        return redirect("/login")
    return render_template('index.html')
    
    
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == "POST":
        user_name = request.form.get("user_name")
        password  = request.form.get("password")
        print(f'if {user_name} matches {password}')
        password_matches, login_data = is_password_valid(user_name, password)
        if password_matches:
            session["username"] = user_name
            session["password_expiry_date"] = login_data.get('password_expiry_date')
            session["user_firstname"] = login_data.get('user_firstname')
            session["user_lastname"]  = login_data.get( 'user_lastname')
            session["user_id"] = login_data.get('user_id')
            session["return_msg"] = login_data.get('return_msg')
            session["privilege"] = login_data.get('privileges')[0]['Privilige']
            # print(session)
        return redirect("/")
    return render_template("login.html")

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    session.clear()
    return redirect('/')




if __name__ == "__main__":
    # app.run(debug=True, host=ip_adr, port=port_nr, ssl_context='adhoc')
    app.run(debug=True, host='127.0.0.1', port=5011)
