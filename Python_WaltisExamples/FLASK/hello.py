from flask import Flask, request

app = Flask(__name__)

@app.route('/')
def index():
    return '''<H1>Hello world Walti!!!!!</H1>
    Weitere Text
    '''

@app.route('/hello')
def gugus():
    return 'Hello ????'

@app.route('/post', methods = ['GET', 'POST'])
def post():
    data = request.form
    print(data)
    return 'Hello thanks for the post' + str(data)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
