from flask import Flask, request, render_template, session, redirect

app = Flask(__name__)
app.secret_key = "Miroskey"


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        if len(password) < 5:
            return render_template('index.html')

        session['username'] = email

    return render_template('index.html')


@app.route('/logout')
def logout():
    session.clear()
    return redirect('/login')


@app.route('/adressliste')
def adress_liste():
    if session['username']:
        return render_template('adress_liste.html')


@app.route('/fp', methods=['GET', 'POST'])
def forgot_password():
    # Logic to send mail
    return render_template('index.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    # Logic to send mail
    return render_template('index.html')


if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)
