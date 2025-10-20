#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Flask_Session_Simple.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/FLASK_App_01/Flask_Session_Simple.py
#
#
# Autor: Walter Rothlin
#
# History:
# 20-Oct_2025   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
#!/usr/bin/python
from flask import Flask, request, render_template, url_for, session, redirect
import requests
import json

app = Flask(__name__)
app.secret_key = 'HalloHFU2025'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"

@app.route('/', methods=['GET', 'POST'])
def index():
    # if session is not None and 'user' in session and session['user'] is not None:
    if session.get('user'):
        return f'''Du bist als <b>{session['user']}</b> eingelogged!<br/><br/><a href="/logout">Logout</a>'''
    else:
        return f'''Du bist nicht eingelogged!<br/><br/><a href="/login">Login</a>'''

@app.route('/login', methods=['GET', 'POST'])
def login():
    session['user'] = 'walter@rothlin.com'
    return redirect('/')

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    session.pop('user', None)
    return redirect('/')




if __name__ == "__main__":
    # app.run(debug=True, host='192.168.107.55', port=5010)
    app.run(debug=True, host='127.0.0.1', port=5010)
