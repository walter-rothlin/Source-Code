from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return '''
    <H1>Home End-Point (index)</H1>
    Hallo HWZ!!!!'
'''
@app.route('/Hallo')
def hello():
    return 'Hallo BWI-A22'

@app.route('/JSON')
def get_JSON():
    return {'Name': 'Rothlin', 'Vorname': 'Walter'}

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)
