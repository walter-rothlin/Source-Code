from flask import Flask, render_template, request, session

from Person import Person

app = Flask(__name__)
app.secret_key = 'MYSECRETKEY'


@app.route('/')
def welcome():
    return render_template("index.html")


@app.route('/login', methods=['POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username.__eq__(password):
            session['username'] = username
            return render_template('index.html')
        else:
            return render_template('index.html', loginError=True)


@app.route('/kontakt')
def contact():
    return render_template("kontakt.html")


@app.route('/signup', methods=['POST'])
def signup():
    if request.method == 'POST':
        anrede = request.form['anrede']
        firstname = request.form['firstname']
        lastname = request.form['lastname']
        username = request.form['username']
        password = request.form['password']

        person = Person(anrede, firstname, lastname, username)
        return render_template("index.html", person=person)


@app.route('/forgot', methods=['POST'])
def forgot_password():
    if request.method == 'POST':
        username = request.form['username']
        return render_template('index.html', resetMessage=username)


@app.route('/logout', methods=['GET', 'POST'])
def logout():
    if request.method == 'POST':
        session.pop('username', None)
        return render_template("index.html")


@app.route("/address")
def address():
    if 'username' in session:
        return render_template("address.html")
    else:
        return render_template("index.html")


if __name__ == '__main__':
    app.run(debug=True)
