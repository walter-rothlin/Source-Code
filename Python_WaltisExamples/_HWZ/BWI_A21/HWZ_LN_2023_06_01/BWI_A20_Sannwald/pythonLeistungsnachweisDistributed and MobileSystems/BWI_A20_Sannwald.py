from flask import Flask, render_template, request, session, redirect, url_for
app = Flask(__name__)
app.secret_key = '12345'

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
        if len(password) > 5:
            session['username'] = email
            session['logged_in'] = True
            return redirect(url_for('index'))
        else:
            return 'Passwort zu kurz`!'
    return render_template('login.html')

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    if request.method == 'POST':
        if request.form['action'] == 'logout':
            session.pop('username')
            session['logged_in'] = False
        return redirect(url_for('index'))
    return render_template('logout.html')

@app.route('/adressen')
def adressen():
    if session.get('logged_in'):
        return render_template('adress_liste.html')
    else:
        return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True, port=5001)
