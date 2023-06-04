from flask import Flask, render_template, request, redirect, url_for, flash, session

app = Flask(__name__)
app.secret_key = 'your secret key'

@app.route('/')
def index():
    username = session.get('username')
    return render_template('index.html', username=username)

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']

        if len(password) < 5:
            flash('Login failed, password must be more than 5 characters')
            return render_template('login.html')
        else:

            session['username'] = username

            return redirect(url_for('index'))

    return render_template('login.html')

@app.route('/adress_liste')
def adress_liste():
    return render_template('adress_liste.html', username=session['username'])

@app.route('/logout', methods=['GET', 'POST'])
def logout():
    if request.method == 'POST':
        session.clear()
        return redirect(url_for('index'))

    return render_template('logout.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        if len(password) < 5:
            return redirect(url_for('register'))

        if password != confirm_password:
            return redirect(url_for('register'))

        else:
            return redirect(url_for('index'))

    return render_template('register.html')

@app.route('/forgot_password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form['email']

        return redirect(url_for('login'))

    return render_template('forgot_password.html')

if __name__ == '__main__':
    app.run(debug=True)