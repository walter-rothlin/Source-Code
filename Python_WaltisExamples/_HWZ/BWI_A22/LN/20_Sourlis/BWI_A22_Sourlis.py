from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__)
app.secret_key = 'secretkey'

@app.route('/', methods=['GET', 'POST'])
def index():
    error = None
    success = None
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        if len(password) > 5:
            session['user'] = email
            success = "Login erfolgreich!"
        else:
            error = "Passwort muss länger als 5 Zeichen sein."
    return render_template("index.html", error=error, success=success)


@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('index', loggedout=1))

@app.route('/adress_liste')
def adress_liste():
    if 'user' not in session:
        return redirect(url_for('index'))
    return render_template('adress_liste.html')

if __name__ == '__main__':
    app.run(debug=True)
