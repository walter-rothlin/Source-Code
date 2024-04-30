from flask import Flask, request, session

class Counter:
    def __init__(self, start_value):
        self.__start_value = start_value

    def inc(self):
        self.__start_value += 1

    def dec(self):
        self.__start_value -= 1

    def get_counter(self):
        return self.__start_value

app = Flask(__name__)
app.secret_key = 'geheimnis'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"

def sayHallo():
    return 'Hallo:'

def get_html_2er_potenzen_table(start_index, end_index):
    ret_str = '''
    <TABLE>
    <TR><TD>Exponent</TD><TD>2^Exponent</TD></TR>
    '''
    for i in range(start_index, end_index):
        ret_str += f'{get_html_tr_for_2er_potenzen(i)}'


    return ret_str + '</TABLE>'

def get_html_tr_for_2er_potenzen(exponent):
    ret_val = f'''
    <TR><TD>{exponent}</TD><TD>{2 ** exponent}</TD></TR>
    '''
    return ret_val

@app.route('/', methods=["POST", "GET"])
def potenzen_table():
    request_counter.inc()
    print(f'End-Point potenzen_table() called!')
    args = request.args
    print(f'{args}')
    min = request.args.get("Minimum")
    max = request.args.get("Maximum")
    if min is not None:
        print('Min in session speicher')
        session['min'] = min
    else:
        min = session.get('min')
    if max is not None:
        print('Max in session speicher')
        session['max'] = max
    else:
        max = session.get('max')

    if min is None:
        min = '0'
    if max is None:
        max = str(int(min) + 20)
    print(min, max)

    return f'''
    <HTML>
    <HEAD>
    
    </HEAD>
    
    <BODY>
    
    <H1>{sayHallo()} HWZ!!!</H1>
    {get_html_2er_potenzen_table(int(min), int(max))}

    Count of Requests:  {request_counter.get_counter()}
    </BODY>
    </HTML>
    '''

@app.route('/hallo')
def hallo_1():
    request_counter.inc()
    return sayHallo() + 'Guten Abend BWI-A21!'

@app.route('/Hallo')
def hallo_2():
    request_counter.inc()
    return sayHallo() + 'GUTEN ABEND BWI-A21!'

@app.route('/get_adr')
def get_adr_liste():
    request_counter.inc()
    ret_val = [
              {'Name': 'Rothlin',
               'Firstname': 'Walter'
              },
              {'Name': 'Müller',
               'Firstname': 'Max'
              },
              ]
    return ret_val

if __name__ == '__main__':
    request_counter = Counter(10)
    app.run(debug=True, host='127.0.0.1', port=5001)
