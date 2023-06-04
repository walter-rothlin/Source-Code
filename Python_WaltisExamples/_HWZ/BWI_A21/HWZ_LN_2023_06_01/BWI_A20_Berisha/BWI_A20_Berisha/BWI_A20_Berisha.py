from flask import Flask, render_template, request, session, redirect, url_for

app = Flask(__name__)
app.secret_key = 'Banissessionkey'

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        if len(request.form['password']) > 5:
            session['email'] = request.form['email']
            return redirect(url_for('home'))
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('email', None)
    return redirect(url_for('home'))

@app.route('/adress_liste')
def adress_liste():
    if 'email' not in session:
        return redirect(url_for('login'))
    return render_template('adress_liste.html')

if __name__ == '__main__':
    app.run(debug=True)