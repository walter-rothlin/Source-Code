#!/usr/bin/python

from flask import Flask, request, render_template, session, redirect


class State():
    def __init__(self):
        self.__req_count = 0

    def inc(self):
        self.__req_count += 1

    def get_req_count(self):
        return str(self.__req_count)


app = Flask(__name__)
app.secret_key = 'HalloHFU2025'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"

@app.route('/', methods=['GET', 'POST'])
def index():
    req_counter.inc()
    session['login_name'] = 'walter@rothlin.com'
    # session["login_name"] = request.form.get("login_name")
    print("index() called with method:", request.method)
    if request.method == 'POST':
        print("Received POST data:", request.form)
    elif request.method == 'GET':
        print("Received GET parameters:", request.args)


    name_liste = ['Walter', 'Max', 'Josef', 'Fritz', 'Daniel']

    return render_template('index.html',
                           vorname='Walter Rothlin',
                           nameListe=name_liste,
                           get_params=request.args,
                           requestCounter=req_counter.get_req_count(),
                            )


@app.route('/Test')
def index_1():
    if session.get('login_name'):
        return f'''Du bist als <b>{session['login_name']}</b> eingelogged!<br/><br/><a href="/logout">Logout</a>'''
    else:
        return f'''Du bist nicht eingelogged!<br/><br/><a href="/login">Login</a>'''

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    session.pop('login_name', None)
    return redirect('/Test')

@app.route('/get_adressen')
def get_adressen():
    adressen = [
        {'nachname': 'Rothlin'    , 'vorname': 'Walter M.'},
        {'nachname': 'Meier'      , 'vorname': 'Max'},
        {'nachname': 'Roth'       , 'vorname': 'Josef'},
        {'nachname': 'Bamert'     , 'vorname': 'Fritz'},
        {'nachname': 'Schnellmann', 'vorname': 'Daniel'}
    ]
    return adressen

# =========================================================
# main
# =========================================================
if __name__ == '__main__':
    req_counter = State()
    app.run(debug=True, host='127.0.0.1', port=5001)

