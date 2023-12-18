
# https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2023_03_PY2/04_Flask/01_Hello.py

from flask import Flask, request, redirect, url_for, session, render_template

class State():
    def __init__(self):
        print('State::__init__ called!')
        self.__req_count = 0

    def inc(self):
        self.__req_count += 1

    def get_reg_count(self):
        return str(self.__req_count)



app = Flask(__name__)
app.secret_key = 'geheimnis'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"

@app.route('/')
def index():
    state.inc()
    if session is not None and 'start_point' in session and session['start_point'] is not None:
        local_start_point = session['start_point']
        print('Session: local_start_point:', local_start_point)
    else:
        local_start_point = 'Kein start_point in Session defined'
        print('Session: Kein Start_point defined in Seesion')

    return f'''
    <HTML>
    <BODY>
    <H1>Hallo HBU!!!</H1>
    <A href="/Adressen">Adressen</A><BR/>
    <A href="/Reihe">Zahlenreihe 0..9</A><BR/><BR/>
    <A href="/Reihe?start_point=5">Zahlenreihe 5..9</A><BR/><BR/>
    
    actual: {state.get_reg_count()}<BR/>
    start: {local_start_point}<BR/>
    </BODY>
    </HTML>
    '''

@app.route('/static_index')
def static_index():
    return render_template('static_index.html')

    '''
    filename = 'static/html/static_index.html'
    with open(filename) as text_file:
        file_content = text_file.read()

    return file_content
    '''

@app.route('/adress_list', methods=['GET', 'POST'])
def adresslist():
    # search_criteria = ''
    if request.method == 'POST':
        search_criteria = request.form.get('search_criteria')
    else:
        search_criteria = request.args.get('search_criteria')
    if search_criteria is None:
        search_criteria = ''

    print('new_critera:', search_criteria)
    rs = [
        {'nachname': 'Rothlin', 'vorname': 'Walti'},
        {'nachname': 'Roth', 'vorname': 'Tobias'},
        {'nachname': 'Meier', 'vorname': 'Max'}
    ]
    return render_template('table_template.html', result_liste=rs, search_criteria=search_criteria)

@app.route('/Adressen')
def adressen():
    state.inc()
    return '''
    <HTML>
    <BODY>
    <H1>Adressen</H1>
    <A href="/">Back</A>
    </BODY>
    </HTML>
    '''

@app.route('/Reihe', methods=['GET', 'POST'])
def zahlenreihe():
    state.inc()
    start_point = request.args.get('start_point')
    print(start_point)
    if start_point is None:
        start_point = 0
    session['start_point'] = 'Session: start_point define!'
    response_str = 'Eine Zahlenreihe<br/>'
    response_str += '<table>'
    for i in range(int(start_point), 10):
        response_str += f'<tr><td>{i}</td><td>{i**2}</td><td>{i**3}</td></tr>'

    response_str += '</table>'

    return response_str

@app.route('/JSON', methods=['GET', 'POST'])
def return_json():
    state.inc()
    return {
        'Name': 'Rothlin',
        'Vorname': 'Walti',
        'Nummern': [345, 341, 321],
        'Anzahl_Requests': state.get_reg_count()
    }




if __name__ == '__main__':
    state = State()
    app.run(debug=True, host='127.0.0.1', port=5001)
