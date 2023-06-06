

# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
from flask import Flask, render_template, url_for, session, request, redirect

app = Flask('name')
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'



class State():
    def __init__(self):
        self.__req_count = 0

    def inc(self):
        self.__req_count += 1

    def get_req_count(self):
        return str(self.__req_count)

# Press the green button in the gutter to run the script.
# =========================================================
# main
# =========================================================

@app.route('/')
def index():
    state.inc()
    username = session.get('email')
    return render_template('index.html', username=username)


@app.route('/kontakt')
def template():
    filename = request.args.get('param')
    state.inc()
    return render_template('kontakt.html')

@app.route('/handleForm', methods=['GET', 'POST'])
def handleForm():
    user_email = request.args.get("user_email")
    user_name = request.args.get("user_name")
    user_message = request.args.get("user_message")

    return render_template('handleContact.html', email=user_email, user_name=user_name, message=user_message)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        if len(password) > 5:
            session['email'] = email
            return redirect(url_for('index'))
        else:
            return render_template('login.html', message='Das eingegebene Passwort ist zu kurz.')

    return render_template('login.html')


@app.route('/adress-list')
def adress_list():
    if 'email' not in session:
        return redirect(url_for('login'))

    return render_template('adress_list.html')

@app.route('/logout')
def logout():
    session.pop('email', None)
    return redirect(url_for('index'))


@app.route('/penis')
def penis():
    return 'penis'

@app.route('/simple_REST', methods=['GET', 'POST'])
def simple_REST():
    lastName = request.args.get("lastName")
    firstName = request.args.get("firstName")

    rs = {'Title:': 'Turnverein',
          'adress_data':
              [
                  {'key': 1, 'lastName': 'Rothlin'    , 'firstName': 'Walter'},
                  {'key': 2, 'lastName': 'Meier'      , 'firstName': 'Max'},
                  {'key': 3, 'lastName': 'Roth'       , 'firstName': 'Josef'},
                  {'key': 4, 'lastName': 'Bamert'     , 'firstName': 'Fritz'},
                  {'key': 5, 'lastName': 'Schnellmann', 'firstName': 'Daniel'}
              ]
         }
    rs['adress_data'].append({'key': 6, 'lastName': lastName, 'firstName': firstName})

    return rs, 200, {'Etag': 'some-opaque-string'}

if __name__ == '__main__':
    state = State()
    app.run(debug=True, host='127.0.0.1', port=5001)

# See PyCharm help at https://www.jetbrains.com/help/pycharm/

