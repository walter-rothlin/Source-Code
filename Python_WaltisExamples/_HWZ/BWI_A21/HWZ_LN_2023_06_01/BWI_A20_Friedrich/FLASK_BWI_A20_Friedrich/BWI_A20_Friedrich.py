from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__)
app.secret_key = 'cceaf5204aeafb5c9978c6e93c56e03e'

logged_in = False


@app.route("/")
@app.route("/home")
def index():
    global logged_in
    email = session.get('email')
    logged_in = True if email else False
    return render_template('index.html', logged_in=logged_in, email=email)


@app.route("/login", methods=['GET', 'POST'])
def login():
    global logged_in

    if request.method == 'POST':

        email = request.form['email']
        password = request.form['password']

        if len(password) > 5:
            session['email'] = email
            return redirect(url_for('index'))
        else:
            error_message = 'Ungültiges Passwort'
            return render_template('login.html', error_message=error_message)

    return render_template('login.html')


@app.route('/logout')
def logout():
    session.pop('email', None)
    return redirect(url_for('index'))


@app.route('/register', methods=['POST', 'GET'])
def register():
    global logged_in
    if request.method == 'POST':
        email = request.form.get('email')
        logged_in = True
        return redirect(url_for('index'))
    else:
        return render_template('register.html')


@app.route('/forgot_password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form.get('email')
        return render_template('password_reset_sent.html')
    else:
        return render_template('forgot_password.html')


@app.route('/kontakt')
def kontakt():
    global logged_in
    email = session.get('email')
    logged_in = True if email else False
    return render_template('kontakt.html', logged_in=logged_in, email=email)


@app.route('/adressen')
def adressen():
    global logged_in
    email = session.get('email')
    logged_in = True if email else False
    return render_template('adress_liste.html', logged_in=logged_in, email=email)


if __name__ == '__main__':
    app.run(debug=True)
