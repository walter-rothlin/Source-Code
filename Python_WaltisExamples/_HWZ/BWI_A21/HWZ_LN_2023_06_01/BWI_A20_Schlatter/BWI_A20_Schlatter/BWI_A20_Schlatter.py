from flask import Flask, render_template, request, session, redirect, url_for

app = Flask(__name__)
app.secret_key = 'your-secret-key'


@app.route('/')
def index():
    username = session.get('email')
    return render_template('index.html', username=username)


@app.route('/login', methods=['POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        if len(password) > 5:
            session['email'] = email
            return ''
        else:
            return 'Das eingegebene Passwort ist zu kurz.'


@app.route('/logout')
def logout():
    session.pop('email', None)
    return redirect(url_for('index'))


@app.route('/adress-liste')
def adress_liste():
    username = session.get('email')
    if not username:
        return redirect(url_for('login'))

    return render_template('adress_liste.html', username=username)


@app.route('/kontakt')
def kontakt():
    username = session.get('email')
    return render_template('kontakt.html', username=username)


if __name__ == '__main__':
    app.run(debug=True)
