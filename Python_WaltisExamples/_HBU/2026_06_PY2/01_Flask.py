#!/usr/bin/python
import json
import requests
from flask import Flask, request, render_template

ip_adr = '192.168.107.161'
port_nr = 5001

import urllib3

urllib3.disable_warnings(
    urllib3.exceptions.InsecureRequestWarning
)


app = Flask(__name__)

@app.route('/')
def index():
    print('index() called!')
    # return 'Hallo HFU'
    datums_str = 'Montag, 28-September 2026'
    return render_template('index.html', dat_str=datums_str)

@app.route('/Reihe', methods=['GET', 'POST'])
def zahlenreihe():
    print('zahlenreihe() called!')
    if request.method == 'POST':
        print('Parameter via POST received')
        max_value = request.form.get('max', default=10, type=int)
        min_value = request.form.get('min', default=0,  type=int)
    else:
        print('Parameter via GET received')
        max_value = request.args.get('max', default=10, type=int)
        min_value = request.args.get('min', default=0,  type=int)
    
    print(f'min:{min_value}  max:{max_value}')
    
    tr_td_str = '\n'
    for i in range(min_value, max_value+1):
        tr_td_str += f'                <TR><TD>{i}</TD><TD>{2**i}</TD></TR>\n'
    
    return f'''
    <HMTL>
        <HEAD> </HEAD>
        <BODY>
            <A href='/'>INDEX</A>
            <H1>2-er Potenzen ({min_value} .. {max_value})</H1>
            <TABLE>
                {tr_td_str}
            </TABLE>
        </BODY>
    </HTML>
    '''

@app.route('/get_adresse', methods=['GET', 'POST'])
def get_adressen():
    print('get_adressen() called!')
    
    if request.method == 'POST':
        print('Parameter via POST received')
        search_str     = request.form.get('search_str',     default='',  type=str)
        case_sensitive = request.form.get('case_sensitive', default='0', type=str)
    else:
        print('Parameter via GET received')
        search_str     = request.args.get('search_str',     default='',  type=str)
        case_sensitive = request.args.get('case_sensitive', default='0', type=str)
    
    # search_str = 'ot'
    print(f'search_str: {search_str}')

    rs = [
     {'firstname': 'Walti', 'lastname': 'Rothlin'},
     {'firstname': 'Max',   'lastname': 'Meier'},
    ]
    
    resultat_set = []
    for a_data_set in rs:
        if search_str in a_data_set['firstname'] or search_str in a_data_set['lastname']:
            resultat_set.append(a_data_set)
            
    return {'result_set': resultat_set}

@app.route('/adresse_liste', methods=['GET', 'POST'])
def adresse_liste():
    if request.method == 'POST':
        print('Parameter via POST received')
        search_str = request.form.get('search_str', default='', type=str)
        case_sensitive = request.form.get('case_sensitive', default='0', type=str)
    else:
        print('Parameter via GET received')
        search_str = request.args.get('search_str', default='', type=str)
        case_sensitive = request.args.get('case_sensitive', default='0', type=str)

    # Parameter für REST-Service
    params = {
        'search_str': search_str
    }

    if case_sensitive:
        params['case_sensitive'] = '1'

    # REST-Service aufrufen
    url = f'https://{ip_adr}:{port_nr}/get_adresse'

    response = requests.get(url, params=params, verify=False)

    # JSON-Antwort auswerten
    response_data = response.json()

    # Resultat aus REST-Service
    rs = response_data['result_set']

    return render_template('adressliste_bootstrap.html', 
                           adress_liste=rs, 
                           search_str=search_str, 
                           case_sensitive=case_sensitive)
    
if __name__ == '__main__':
    app.run(debug=True, host=ip_adr, port=port_nr, ssl_context='adhoc')