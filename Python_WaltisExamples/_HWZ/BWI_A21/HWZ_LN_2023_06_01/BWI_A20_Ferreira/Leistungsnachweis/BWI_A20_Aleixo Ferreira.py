from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        password = request.form['password']
        if len(password) > 5:
            session['username'] = request.form['email']
            return redirect(url_for('index'))
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('index'))

@app.route('/adress_liste')
def adress_liste():
    if 'username' not in session:
        return redirect(url_for('login'))
    return render_template('adress_liste.html')

if __name__ == '__main__':
    app.secret_key = 'Apfel'
    app.run(debug=True)
