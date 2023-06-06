from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__)
app.secret_key = 'geheimeschluessel'

@app.route('/')
def index():
    user_name = session.get('user_name')
    return render_template('index.html', user_name=user_name)

@app.route('/kontakt')
def kontakt():
    user_name = session.get('user_name')
    return render_template('kontakt.html', user_name=user_name)

@app.route('/adressliste')
def adress():
    user_name = session.get('user_name')
    return render_template('adress_liste.html', user_name=user_name)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        password = request.form.get('password')
        if password and len(password) > 5:
            session['user_name'] = request.form.get('username')
            return redirect(url_for('index'))
        else:
            error_message = 'Ungültiges Login. Das Passwort muss länger als 5 Zeichen sein.'
            return render_template('login.html', error_message=error_message)
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('user_name', None)
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run()