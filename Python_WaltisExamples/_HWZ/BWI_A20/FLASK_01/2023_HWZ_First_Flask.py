from flask import Flask, request, render_template

app = Flask(__name__)

class State():
    def __init__(self):
        self.__req_count = 0

    def inc(self):
        self.__req_count += 1

    def get_req_count(self):
        return str(self.__req_count)


@app.route('/')
def index():
    return '''
    <HTML>
    <BODY>
        <H1>Hallo HWZ!!!!!</H1>
        Guten Abend!
    </BODY>
    </HTML>
    '''

@app.route('/Reihe')
def zahlenreihe():
    state.inc()
    ret_string = '<H1>Zahlenreihe</H1>'
    ret_string += 'Zaehlerstand:' + state.get_req_count()
    ret_string += '<table>'
    for i in range(2, 10):
        ret_string += '''
        <TR>
            <TD>''' + str(i)    + '''      </TD>
            <TD>''' + str(i**2) + '''      </TD>
        </TR>'''
    ret_string += '</table>'
    return ret_string

@app.route('/JSON', methods=['GET', 'POST'])
def return_json():
    filename = request.args.get("filename")
    print('request.args:', request.args)
    print('filename:', filename)
    if filename is None:
        return 'Missing Parameter: filename'
    else:
        return {
                 'Name': 'Rothlin',
                 'Vorname': 'Walti',
                 'Filename': filename
                }

@app.route('/static', methods=['GET', 'POST'])
def return_static_page():
    filename = 'static/html/HWZ_Mir_Glauben.html'
    # read file into string variable
    with open(filename) as text_file:
        file_content = text_file.read()
    return file_content

@app.route('/render', methods=['GET', 'POST'])
def render_page():
    filename = request.args.get("filename")
    if filename is None:
        filename = 'index_template.html'

    return render_template(filename)

if __name__ == '__main__':
    state = State()
    app.run(debug=True, host='127.0.0.1', port=5001)
