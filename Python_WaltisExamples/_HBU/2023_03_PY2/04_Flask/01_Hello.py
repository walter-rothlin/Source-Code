
from flask import Flask, request

class State():
    def __init__(self):
        print('State::__init__ called!')
        self.__req_count = 0

    def inc(self):
        self.__req_count += 1

    def get_reg_count(self):
        return str(self.__req_count)



app = Flask(__name__)


@app.route('/')
def index():
    state.inc()
    return f'''
    <HTML>
    <BODY>
    <H1>Hallo HBU!!!</H1>
    <A href="/Adressen">Adressen</A><BR/>
    <A href="/Reihe">Zahlenreihe 0..9</A><BR/><BR/>
    <A href="/Reihe?start_point=5">Zahlenreihe 5..9</A><BR/><BR/>
    
    {state.get_reg_count()}<BR/>
    </BODY>
    </HTML>
    '''

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
    response_str = 'Eine Zahlenreihe<br/>'
    response_str += '<table>'
    for i in range(int(start_point), 10):
        response_str += f'<tr><td>{i}</td><td>{i**2}</td><td>{i**3}</td></tr>'

    response_str += '</table>'

    return response_str

@app.route('/JSON', methods=['GET', 'POST'])
def return_json():
    return {
        'Name': 'Rothlin',
        'Vorname': 'Walti',
        'Nummern': [345, 341, 321],
    }




if __name__ == '__main__':
    state = State()
    app.run(debug=True, host='127.0.0.1', port=5001)
