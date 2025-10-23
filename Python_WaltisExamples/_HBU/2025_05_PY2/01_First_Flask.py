

from flask import Flask, request, render_template

class State():
    def __init__(self):
        print('State::__init__ called!')
        self.__req_count = 0

    def inc(self):
        self.__req_count += 1

    def get_reg_count(self):
        return str(self.__req_count)

    def __str__(self):
        return f'State: req_count={self.__req_count}'



app = Flask(__name__)

default_maxwert = 15
state = State()

@app.route('/')
def index():
    print('index called!')
    state.inc()
    return render_template('index.html', default_maxwert=default_maxwert, state=state)

@app.route('/Reihe', methods=['GET', 'POST'])
def zahlenreihe():
    state.inc()
    print('zahlenreihe called!')
    if request.method == 'POST':
        print('POST request received!!')
        maxwert = int(request.form.get('maxwert', default=default_maxwert, type=int))
    else:
        print('GET request received')
        maxwert = request.args.get('maxwert', default=default_maxwert, type=int)

    ret_string = f'Zahlenreihe 0..{maxwert - 1}: <br/>\n'
    for i in range(maxwert):
        print(i)
        ret_string += str(i) + '<br/>\n'

    return ret_string

@app.route('/adressen_JSON')
def adressen_json():
    print('adressen_json called!')
    state.inc()
    rs = [
        {'nachname': 'Rothlin', 'vorname': 'Walti', 'email_addr': ['walter@rothlin.com', 'walter.rothlin@hfu.ch']},
        {'nachname': 'Roth', 'vorname': 'Tobias', 'Nummern': [345, 341, 321]},
        {'nachname': 'Meier', 'vorname': 'Max'}
    ]
    return {'result_liste': rs}




if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)




