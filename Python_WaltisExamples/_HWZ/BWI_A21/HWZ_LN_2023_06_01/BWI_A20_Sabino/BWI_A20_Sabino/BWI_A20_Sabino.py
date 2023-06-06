from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__)
app.secret_key = 'Dein secretkey'  # Sicherheitsschlüssel für die Session


@app.route('/')
def home():
    return render_template('index.html')


@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        password = request.form.get('password')
        if len(password) > 5:
            session['email'] = request.form.get('email')
            return redirect(url_for('home'))
        else:
            return "Ihr Passwort muss mind. 5 Zeichen lang sein."
    else:
        return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('email', None)
    return redirect(url_for('home'))

@app.route('/adress_liste')
def adress_liste():
    persons = [
        {'name': 'Person 1', 'address': 'Adresse 1', 'city': 'Stadt 1'},
        {'name': 'Person 2', 'address': 'Adresse 2', 'city': 'Stadt 2'},
        {'name': 'Person 3', 'address': 'Adresse 3', 'city': 'Stadt 3'},
    ]
    return render_template('adress_liste.html', persons=persons)

@app.route('/impressum')
def impressum():
    return render_template('impressum.html')


@app.route('/ueber_uns')
def ueber_uns():
    return render_template('ueber_uns.html')

if __name__ == "__main__":
    app.run(debug=True)
